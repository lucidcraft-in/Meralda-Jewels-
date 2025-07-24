import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/colo_extension.dart';
import '../../providers/goldrate.dart';
import '../../providers/paymentBill.dart';
import '../../providers/paymentConfi.dart';

class SendPaymentRec extends StatefulWidget {
  @override
  _SendPaymentRecState createState() => _SendPaymentRecState();
}

class _SendPaymentRecState extends State<SendPaymentRec> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  DateTime? _selectedDate;
  String? _pickedFile;
  File? selectedFile;
  bool checkValue = false;
  var user;
  bool _isExpanded = false;
  TextEditingController _amountController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  TextEditingController _graRateController = TextEditingController();
  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    checkValue = prefs.containsKey('user');
    if (checkValue == true) {
      setState(() {
        var data = prefs.getString("user");
        // print(data);
        setState(() {
          user = jsonDecode(data!);
        });
      });
    }
    Provider.of<Goldrate>(context, listen: false).read().then((value) {
      setState(() {
        print("++++++++++++++++++++");
        print(value![0]["gram"]);
        var rate = value[0]["gram"].toDouble();
        print(value[0]["gram"].runtimeType);
        goldRate = rate;
        _graRateController.text = goldRate.toString();
      });
      print("------- --------");

      print(goldRate);
    });
  }

  double goldRate = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    fetchData();
  }

  Map<String, dynamic> aboutUsData = {};
  Future<void> fetchData() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('aboutUs').limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          aboutUsData = data;
        });

        print(aboutUsData["whatsapp"]);
      } else {}
    } catch (e) {}
  }

  void _launchWhatsApp() async {
    print(aboutUsData);
    String phone = "91${aboutUsData["phone"]}";
    // String phone = "919961624063";
    print(phone);
    // Compose a meaningful WhatsApp message with product details
    String message = '''Name : ${user["name"]}
Customer Id : ${user["custId"]}
Hello, I have completed the payment. Please find the screenshot attached for your reference.
''';
    ;

    // Encode message for URL
    String whatsappUrl =
        "https://wa.me/$phone/?text=${Uri.encodeComponent(message)}";

    try {
      final Uri url = Uri.parse(whatsappUrl);
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("Error launching WhatsApp: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Upload Screenshot'),
          // iconTheme: IconThemeData(color: Colors.black),
          // backgroundColor: Theme.of(context).primaryColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: Provider.of<PaymentDetails>(context, listen: false)
                        .getAQR(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        print(snapshot.error);
                        return Center(child: Text('Something Error Occured'));
                      } else if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No data found'));
                      } else {
                        var documents = snapshot.data!.docs;
                        var data = documents[0].data() as Map<String, dynamic>;

                        return Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 252, 243, 216),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isExpanded =
                                          !_isExpanded; // Toggle the expanded state
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Payment Info"),
                                      Container(
                                        width: 100,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                _downloadQRCode(
                                                    data["qrcode"], context);
                                              },
                                              child: Icon(
                                                Icons.download,
                                                size: 22,
                                                color: Colors.blueGrey,
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                            Icon(
                                              _isExpanded
                                                  ? Icons.arrow_drop_up_outlined
                                                  : Icons.arrow_drop_down,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                if (_isExpanded) ...[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Column(
                                      children: [
                                        if (data["qrcode"] != "")
                                          Container(
                                            child: Image.network(
                                              data["qrcode"],
                                            ),
                                          ),
                                        SizedBox(
                                            height:
                                                10), // Space between image and UPID

                                        if (data["upiId"] != "")
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                Clipboard.setData(ClipboardData(
                                                    text: data["upiId"]));
                                                final snackBar = SnackBar(
                                                    content: const Text(
                                                        "Copied UPI ID to clipboard"));

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              },
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .07,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "UPI ID: ${data["upiId"]}",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Icon(
                                                      Icons.copy,
                                                      size: 22,
                                                      color: Colors.blueGrey,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        if (data["ac_no"] != "")
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .07,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Clipboard.setData(
                                                          ClipboardData(
                                                              text: data[
                                                                  "ac_no"]));
                                                      final snackBar = SnackBar(
                                                          content: const Text(
                                                              "Copied Account number to clipboard"));

                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "A/C NO : ${data["ac_no"]}",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(width: 5),
                                                        Icon(
                                                          Icons.copy,
                                                          size: 22,
                                                          color:
                                                              Colors.blueGrey,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Clipboard.setData(
                                                          ClipboardData(
                                                              text: data[
                                                                  "ifsc"]));
                                                      final snackBar = SnackBar(
                                                          content: const Text(
                                                              "Copied IFSC to clipboard"));

                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "IFSC : ${data["ifsc"]}",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(width: 5),
                                                        Icon(
                                                          Icons.copy,
                                                          size: 22,
                                                          color:
                                                              Colors.blueGrey,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter valid amount';
                      }
                      return null;
                    },
                    focusNode: _amountFocusNode,
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Amount",
                      labelStyle: TextStyle(color: TColo.primaryColor1),
                      hintText: 'Enter Amount',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 185, 185, 185)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 185, 185, 185)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 185, 185, 185)),
                      ),
                      // border: UnderlineInputBorder(
                      //     borderSide: BorderSide(
                      //         color: Color.fromARGB(255, 119, 18,
                      //             92))), // Customize underline color
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    focusNode: _noteFocusNode,
                    controller: _noteController,
                    decoration: InputDecoration(
                      labelText: "Note",
                      labelStyle: TextStyle(color: TColo.primaryColor1),
                      hintText: 'Enter Note',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 185, 185, 185)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 185, 185, 185)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 185, 185, 185)),
                      ),
                      // border: UnderlineInputBorder(
                      //     borderSide: BorderSide(
                      //         color: Color.fromARGB(255, 119, 18,
                      //             92))), // Customize underline color
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    readOnly: true,
                    controller: _graRateController,
                    decoration: InputDecoration(
                      labelText: "Gram Rate",
                      labelStyle: TextStyle(color: TColo.primaryColor1),
                      hintText: 'Gram Rate',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 185, 185, 185)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 185, 185, 185)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 185, 185, 185)),
                      ),
                      // border: UnderlineInputBorder(
                      //     borderSide: BorderSide(
                      //         color: Color.fromARGB(255, 119, 18,
                      //             92))), // Customize underline color
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        // Pick a time
                        TimeOfDay currentTime = TimeOfDay.now();

                        // Combine picked date with current time
                        setState(() {
                          _selectedDate = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            currentTime.hour,
                            currentTime.minute,
                          );
                        });
                      }
                    },
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromARGB(255, 185, 185, 185)),
                        borderRadius:
                            BorderRadius.circular(8.0), // Border radius
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 10), // Padding inside the container

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_selectedDate == null
                              ? 'Select Date'
                              : DateFormat('yyyy-MM-dd')
                                  .format(_selectedDate!)),
                          Icon(Icons.calendar_month)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles();
                      if (result != null) {
                        // print(result);
                        setState(() {
                          _pickedFile = result.files.single.name;
                          selectedFile = File(result.files.single.path!);
                        });
                      }
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * .25,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Color.fromARGB(255, 185, 185, 185)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image(
                            height: 60,
                            image: AssetImage("assets/images/file.png"),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Upload ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: TColo
                                    .primaryColor1, // Replace TColo.primaryColor1 with actual color
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Payment Image ',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          if (_pickedFile != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _pickedFile!,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                                SizedBox(width: 30),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _pickedFile = null;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      size: 25,
                                      color: Color.fromARGB(255, 196, 55, 45),
                                    ))
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).primaryColor),
                      ),
                      onPressed: _isSubmitting
                          ? null
                          :
                          // _submitForm,
                          _submitFor,
                      child: _isSubmitting
                          ? CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Text(
                              'Submit',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitFor() async {
    setState(() {
      _isSubmitting = true;
    });
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState!.validate() &&
        _pickedFile != null &&
        _selectedDate != null) {
      print("------");
      Provider.of<PaymentBillProvider>(context, listen: false)
          .addPayment(
              double.parse(_amountController.text),
              _noteController.text,
              goldRate,
              _selectedDate!,
              selectedFile!,
              _pickedFile!,
              user)
          .then((val) async {
        print("-------------");
        // print(val);
        if (val == 200) {
          // Handle successful submission
          await Future.delayed(Duration(milliseconds: 300));
          setState(() {
            _isSubmitting = false;
          });
          FocusScope.of(context).unfocus();
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Screenshot Submitted Successfully')),
          );
          _launchWhatsApp();

          // Clear form
          // _amountController.clear();
          // _noteController.clear();
          setState(() {
            _pickedFile = null;
            _selectedDate = null;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('An error occurred. Please try again.')),
          );
        }
      });
    } else {
      print("++++++");
      setState(() {
        _isSubmitting = false;
      });
      final snackBar =
          SnackBar(content: const Text("Please fill out all fields"));

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // Set focus back to the first empty field if necessary
      // if (_amountController.text.isEmpty) {
      //   _amountFocusNode.requestFocus();
      // } else if (_noteController.text.isEmpty) {
      //   _noteFocusNode.requestFocus();
      // }
    }
  }

  // FocusNodes
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _noteFocusNode = FocusNode();
  @override
  void dispose() {
    // Dispose controllers and FocusNodes
    _amountController.dispose();
    _noteController.dispose();
    _graRateController.dispose();
    _amountFocusNode.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

  bool _isDownloading = false;
  double _downloadProgress = 0.0;

  Future<void> _downloadQRCode(String url, BuildContext context) async {
    print("====================");
    setState(() {
      _isDownloading = true;
    });
    if (_isDownloading) print(_isDownloading);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          children: [
            Text("Downloading...."),
            // CircularProgressIndicator(
            //   color: Color.fromARGB(255, 173, 162, 232),
            //   value: _downloadProgress,
            // ),
          ],
        ),
      )),
    );
    try {
      final dio = Dio();
      final appDocDir =
          await getApplicationDocumentsDirectory(); // Get the app's document directory
      print(appDocDir);
      final filePath =
          '${appDocDir.path}/qr_code.png'; // File path to save the QR code

      await dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _downloadProgress = received / total;
            });
          }
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('QR Code downloaded successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download QR Code')),
      );
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }
}
