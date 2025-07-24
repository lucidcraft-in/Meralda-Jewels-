import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../Providers/transaction.dart';
import '../functions/SHA256.dart';
import '../functions/base64.dart';
import '../providers/phonePe_payment.dart';
import '../providers/staff.dart';
import '../providers/user.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'paymentResponseScreen.dart';

// import 'package:url_launcher/url_launcher.dart';

class PaymentScreen extends StatefulWidget {
  static const routeName = '/payment-screen';
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  TextEditingController amountController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  double paidAmount = 0;
  String description = "";
  bool webview = false;
  var userData;
  String custId = "";
  String userName = "";
  String mobileNo = "";
  String status = "";
  int userBranch = 0;
  String transactionId = "";
  var paymentDetails;
  Future checkUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var user = pref.getString("user");
    if (user != null) {
      var decodedJson = json.decode(user);
      userData = decodedJson;

      setState(() {
        custId = userData["custId"];
        userName = userData["name"];
        mobileNo = userData["phoneNo"];
        userBranch = userData["branch"];
      });

      Provider.of<User>(context, listen: false)
          .getUserById(custId)
          .then((value) {
        // print("========");
        // print(value);
        if (value == true) {
          clearData();
        }
      });
      getAdminStaff(userBranch);
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  clearData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.getKeys();
    for (String key in preferences.getKeys()) {
      preferences.remove(key);
    }
    Navigator.pushReplacement(context,
        new MaterialPageRoute(builder: (context) => new LoginScreen()));
  }

  var inserUrl = "https://sarathihelp.com/phonepay/api/insert_payment";
  var phonePeUrl = "https://api.phonepe.com/apis/hermes/pg/v1/pay";
  var rediarectUrl = "https://sarathihelp.com/phonepay/api/paymentResponse";
  var checkServerAPI = "https://sarathihelp.com/phonepay/api/paymentStatus";
  String saltKey = "4a6c9e0c-49d4-40e8-8300-47409a49fd6b";
  String _merchantId = "MALABARIJEWELONLINE";
  bool pressPay = false;

  tokenGenarate(String amt, String note) async {
    getAdminStaff(userBranch);
    var amount = double.parse(amt);

    var data = phonePe_PaymentModel(
        merchantId: _merchantId,
        custId: custId,
        custName: userName,
        amount: amount,
        note: note,
        custPhone: double.parse(mobileNo),
        currency: "INR",
        status: "Initaiated");

    firebaseInsert(data);
  }

  // ------ insert transtaction data in firebase ---------
  firebaseInsert(var data) {
    var db = phonePe_Payment();
    db.initiliase();
    db.addTransaction(data).then((value) {
      // print("----payment data ----");
      setState(() {
        transactionId = value.toUpperCase();
      });
      // print("----- Firebase insert ----------");
      // print(transactionId);
      if (transactionId != "") {
        insertAPI(data.amount, data.note, transactionId);
      } else {
        // print("----- Firebase insert error----------");
      }
    });
  }

// ------ insert transtaction data in Backend ---------
  insertAPI(double amt, String note, String transId) async {
    var rspncData;
    // phonePeFn(amt, transId);
    // print(inserUrl);
    final response = await http.post(
      Uri.parse(inserUrl),
      headers: {
        'Content-Type': 'application/json',
        'Content-type': 'application/json',
        '_token': "SnPm0X8XsudS0klJjW31B0RkI2w5pFfxOZog8kbt"
      },
      body: jsonEncode({
        "customer_id": custId,
        "amount": amt,
        "customer_name": userName,
        "merchantId": _merchantId,
        "transaction_id": transId,
        "message": note
      }),
    );
    // print("---- Backend Insert  -----------");
    // print(rspncData);
    setState(() {
      rspncData = jsonDecode(response.body);
    });
    // print("---- Backend Insert  -----------");

    if (rspncData["statusCode"] == 200) {
      phonePeFn(amt, transId);
    } else {
      // print("---- Backend Insert Error -----------");
    }
  }

  // --------- PhonePe API -------------
  phonePeFn(double amount, String transactionId) async {
    String base64data = "";
    String input;
    String hashedOutput;
    String hash = "";
    var data1;
    var url;
    // print("--------- phone pe -------------");

    var PhonePedata = {
      "merchantId": _merchantId,
      "merchantTransactionId": transactionId,
      "merchantUserId": custId,
      "amount": amount * 100,
      "redirectUrl": rediarectUrl,
      "redirectMode": "POST",
      "callbackUrl": rediarectUrl,
      "mobileNumber": mobileNo,
      "paymentInstrument": {"type": "PAY_PAGE"}
    };
    setState(() {});
    // print(PhonePedata);
    setState(() {
      base64data = encodeJsonToBase64(PhonePedata);
      input = base64data + "/pg/v1/pay" + saltKey;
      hashedOutput = convertToSHA256(input);
      hash = hashedOutput + "###" + "1";
    });

    final response = await http.post(
      Uri.parse(phonePeUrl),
      headers: {
        'Content-Type': 'application/json',
        'Content-type': 'application/json',
        'X-VERIFY': hash
      },
      body: jsonEncode({"request": base64data}),
    );

    setState(() {
      data1 = jsonDecode(response.body);
    });
    // print("-----------------------------------");
    // print(data1);
    setState(() {
      url = data1["data"]["instrumentResponse"]["redirectInfo"]["url"];
    });
    // print(url);

    _launchURL(
      url,
      data1["data"]["merchantTransactionId"],
      data1["data"]["merchantId"],
      amount * 100,
    );
  }

  _launchURL(
      var data, String transactionId, String merchantId, double amount) async {
    final Uri url = Uri.parse(data);

    launchUrl(url, mode: LaunchMode.inAppWebView).then((value) {
      // launch(url.toString()).then((value) {

      setState(() {
        webview = value;
        _isLoading = true;
      });

      if (webview == true) {
        _startTimer(transactionId, merchantId, amount);
      }
    });
  }

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUser();
    setState(() {
      noteController.text = "";
      amountController.text = 0.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Payment"),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,

          // leading: Icon(Icons.arrow_back_ios),
        ),
        body: webview == false
            ? Container(
                width: double.infinity,
                height: 800,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text("Hello...",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          userData != null ? userName.toUpperCase() : "",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          height: 100,
                          child: IntrinsicWidth(
                            child: TextField(
                              onChanged: (amountController) {
                                setState(() {});
                              },
                              controller: amountController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30.0,
                                  height: 2.0,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  FontAwesomeIcons.rupeeSign,
                                  size: 25,
                                  color: Colors.black,
                                ),
                                hintStyle: TextStyle(fontSize: 50),
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: -12.0),
                              ),
                            ),
                          ),
                        ),
                        Container(
                            width: 250,
                            height: 65,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: IntrinsicWidth(
                                  child: TextField(
                                    controller: noteController,
                                    onChanged: (noteController) {
                                      setState(() {});
                                    },
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.black),
                                    decoration: InputDecoration(
                                        hintText: "add a note",
                                        hintStyle: TextStyle(fontSize: 14),
                                        border: InputBorder.none),
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     getAdminStaff(userBranch);
                    //   },
                    //   child: Container(
                    //     width: 100,
                    //     height: 40,
                    //     color: Color.fromARGB(255, 56, 56, 56),
                    //     child: Center(
                    //       child: Text(
                    //         "Get Admin",
                    //         style: TextStyle(color: Colors.white),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Container(
                      height: 50,
                      width: 150,
                      child: noteController.text.isEmpty
                          ? Center(child: Text("Pay Now"))
                          : pressPay == false
                              ? Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: OutlinedButton(
                                      onPressed: () {
                                        if (amountController.text.isNotEmpty) {
                                          setState(() {
                                            pressPay = true;
                                          });
                                          final snackBar = SnackBar(
                                              content: Text(
                                                  "Payment must be at least ₹1"));
                                          if (double.parse(
                                                  amountController.text) >
                                              0) {
                                            tokenGenarate(amountController.text,
                                                noteController.text);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                            setState(() {
                                              pressPay = false;
                                            });
                                          }
                                        } else {
                                          final snackBar = SnackBar(
                                              content: Text(
                                                  "Payment must be at least ₹1"));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      },
                                      child: Text(
                                        "Pay Now",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      )))
                              : Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Center(
                                      child: Text(
                                    "Wait...!",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ))),
                    )
                  ],
                ),
              )
            : Center(
                child: _isLoading
                    ? Container(
                        color: Colors.white,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * .3,
                              width: MediaQuery.of(context).size.height * .3,
                              child: Image(
                                  image: AssetImage("assets/images/wait.jpg")),
                            ),
                            Text(
                              "\" Don't Press Back \" ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "don't press back while payment initiating...!",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 12),
                            )
                          ],
                        ),
                      )
                    : ResponseScreen(
                        response: paymentDetails,
                      )
                // : success
                //     ? ResponseScreen(
                //         response: paymentDetails,
                //         note: noteController.text,
                //         userBranch: userBranch,
                //         adminToken: adminToken,
                //       )
                //     : error
                //         ? ResponseScreen(
                //             response: paymentDetails,
                //             note: noteController.text,
                //             userBranch: userBranch,
                //             adminToken: adminToken,
                //           )
                //         : Container()),
                ));
  }

  bool _isLoading = false;
  int totalTimeElapsed = 0;
  Timer? timer;
  void _startTimer(String transactionId, String merchantId, double amount) {
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      // Counter to track the total elapsed time

      // Send API request every 3 seconds for 5 minutes (300 seconds)

      if (totalTimeElapsed < 300) {
        // Call your API function here
        statusApi(merchantId, transactionId);
        // Update the total elapsed time
        totalTimeElapsed += 3;
        if (containApi == true) {
          timer.cancel();
        }
      } else {
        // Cancel the timer after 5 minutes
        closeInAppWebView();
        timer.cancel();
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  statusApi(String merchantId, String merchantTransactionId) async {
    String input;
    String hashedOutput;
    String hash;

    input = "/pg/v1/status/${merchantId}/${merchantTransactionId}" + saltKey;
    hashedOutput = convertToSHA256(input);
    var url =
        "https://api.phonepe.com/apis/hermes/pg/v1/status/${merchantId}/${merchantTransactionId}";
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Content-type': 'application/json',
        'X-VERIFY': "${hashedOutput}###1",
        "X-MERCHANT-ID": merchantId
      },
    );
    // print("----------phonepe payment Status Response -------");

    var data;
    setState(() {
      data = jsonDecode(response.body);
      paymentDetails = data;
      pressPay = false;
    });
    // print(data);
    if (data["code"] != "PAYMENT_PENDING") {
      checkTransctionApi(data["data"]["merchantTransactionId"],
          data["data"]["merchantId"], data["data"]["amount"]);

      if (containApi == true) {
//  ----- update firebase database work done in backend -----

        // updateFirebaseStatus(paymentDetails);
        closeInAppWebView();
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool containApi = false;
  late String apiResult;
  checkTransctionApi(
      String merchantTransactionId, String merchantId, int amount) async {
    // print("----------checkTransctionApi -------");

    final apiResponse = await http.post(
      Uri.parse(checkServerAPI),
      headers: {
        'Content-Type': 'application/json',
        'Content-type': 'application/json',
      },
      body: jsonEncode({
        "transactionId": merchantTransactionId,
        "merchantId": merchantId,
        "amount": amount / 100
      }),
    );
    // print("---------- API Status Response -------");
    var data = jsonDecode(apiResponse.body);
    setState(() {
      containApi = data["status"];
    });
  }

  Staff? db;
  List staffList = [];
  List filterList = [];
  String adminToken = "";
  getAdminStaff(int brchId) async {
    db = Staff();
    db!.initiliase();
    db!.read().then((value) => {
          setState(() {
            staffList = value!;
          }),
        });

    filterList = staffList
        .where((element) => (element['type'].toString().contains("1")))
        .toList();

    setState(() {
      adminToken = filterList[0]["token"];
    });
  }

  //-------- Below code will work after payment error or success --------

  updateFirebaseStatus(var response) {
    Provider.of<phonePe_Payment>(context, listen: false)
        .updatePaymentbyTransactionId(response["data"]["merchantTransactionId"],
            response["code"], response)
        .then((value) {
      // print("------------- value ----------");
      // print(value);
    }).then((value) {
      if (response["code"] == "PAYMENT_SUCCESS") {
        // add Transaction if payment success
        addTransaction(response);
      } else {
        // add Transaction if payment failed
      }
    });
  }

  DateTime today = DateTime.now();
  addTransaction(var response) async {
    var amount = response["data"]["amount"] / 100;
    var data = TransactionModel(
        id: "",
        customerName: userName,
        customerId: userData["id"],
        date: today,
        amount: response["data"]["amount"].toDouble() / 100,
        transactionType: 0,
        note: noteController.text,
        invoiceNo: response["data"]["merchantTransactionId"],
        category: "GOLD",
        discount: 0,
        staffId: "",
        merchentTransactionId: response["data"]["merchantTransactionId"],
        transactionMode: "online");
    var db = Transaction();
    db.initiliase();
    db.create(data).then((value) {
      final snackBar =
          SnackBar(content: const Text("Transaction Add Successfully...."));

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // Navigator.pushReplacement(context,
      //     MaterialPageRoute(builder: (context) => TransactionScreen()));
    });
    final title = "Successfully Deposited";

    sendNotification(
      title,
      adminToken,
      response["data"]["amount"].toDouble() / 100,
    );
  }

  sendNotification(String title, String token, double amt) async {
    // print("check notification");
    // // print(token);
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': 1,
      'status': 'done',
      'message': title,
    };
    try {
      http.Response response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization':
                    'key=AAAAYxF4bUQ:APA91bE-vvHQIfOI27flf420DjMEb1fkc0rlrFLz6N5HqVKvstpVEl-HzVmubii6ZDHDO5AYHVdvauIbGC0T-dS9yXskwgi4XVd38HOaix_hwBt7riU3tjDBdYx4mGAgglXPP3cEp5jX'
              },
              body: jsonEncode(<String, dynamic>{
                'notification': <String, dynamic>{
                  'title': title,
                  'body':
                      "You have received a deposit of Rs $amt from a $userName"
                },
                'priority': 'high',
                'data': data,
                'to': "$token"
              }));
      // print(response.body);
      if (response.statusCode == 200) {
        // print("notification is sended");
      } else {
        // print("error");
      }
    } catch (e) {}
  }
}
