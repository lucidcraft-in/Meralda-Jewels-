// import 'dart:convert';

// import 'package:crypto/crypto.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

// import 'package:http/http.dart' as http;

// class PhonePePayment extends StatefulWidget {
//   const PhonePePayment({super.key});

//   @override
//   State<PhonePePayment> createState() => _PhonePePaymentState();
// }

// class _PhonePePaymentState extends State<PhonePePayment> {
//   String environment = "UAT_SIM";
//   String appId = "null";
//   String transactionId = DateTime.now().millisecondsSinceEpoch.toString();

//   String merchantId = "MALABARIJEWELONLINE";
//   bool enableLogging = true;
//   String checksum = "";
//   String saltKey = "4a6c9e0c-49d4-40e8-8300-47409a49fd6b";

//   String saltIndex = "1";

//   String callbackUrl =
//       "https://webhook.site/f63d1195-f001-474d-acaa-f7bc4f3b20b1";

//   String body = "";
//   String apiEndPoint = "/pg/v1/pay";

//   Object? result;

//   getChecksum() {
//     final requestData = {
//       "merchantId": merchantId,
//       "merchantTransactionId": transactionId,
//       "merchantUserId": "90223250",
//       "amount": 100,
//       "mobileNumber": "9999999999",
//       "callbackUrl": callbackUrl,
//       "paymentInstrument": {"type": "PAY_PAGE"}
//     };

//     String base64Body = base64.encode(utf8.encode(json.encode(requestData)));

//     checksum =
//         '${sha256.convert(utf8.encode(base64Body + apiEndPoint + saltKey)).toString()}###$saltIndex';

//     return base64Body;
//   }

//   @override
//   void initState() {
//     super.initState();

//     phonepeInit();

//     body = getChecksum().toString();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text("Phonepe Payment Gateway"),
//         ),
//         body: Column(
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 startPgTransaction();
//               },
//               child: Text("Start Transaction"),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             Text("Result \n $result")
//           ],
//         ),
//       ),
//     );
//   }

//   void phonepeInit() {
//     // print("------");
//     PhonePePaymentSdk.init(environment, appId, merchantId, enableLogging)
//         .then((val) => {
//               setState(() {
//                 result = 'PhonePe SDK Initialized - $val';
//               }),
//               // print(result),
//             })
//         .catchError((error) {
//       handleError(error);
//       return <dynamic>{};
//     });
//   }

//   void startPgTransaction() async {
//     try {
//       var response = PhonePePaymentSdk.startPGTransaction(
//           body, callbackUrl, checksum, {}, apiEndPoint, "");
//       response.then((val) async {
//         if (val != null) {
//           String status = val['status'].toString();
//           String error = val['error'].toString();

//           if (status == 'SUCCESS') {
//             result = "Flow complete - status : SUCCESS";

//             await checkStatus();
//           } else {
//             result = "Flow complete - status : $status and error $error";
//           }
//         } else {
//           result = "Flow Incomplete";
//         }
//       }).catchError((error) {
//         handleError(error);
//         return <dynamic>{};
//       });
//     } catch (error) {
//       handleError(error);
//     }
//   }

//   void handleError(error) {
//     setState(() {
//       result = {"error": error};
//     });
//   }

//   checkStatus() async {
//     try {
//       String url =
//           "https://api-preprod.phonepe.com/apis/pg-sandbox/pg/v1/status/$merchantId/$transactionId"; //Test

//       String concatenatedString =
//           "/pg/v1/status/$merchantId/$transactionId$saltKey";

//       var bytes = utf8.encode(concatenatedString);
//       var digest = sha256.convert(bytes);
//       String hashedString = digest.toString();

//       //  combine with salt key
//       String xVerify = "$hashedString###$saltIndex";

//       Map<String, String> headers = {
//         "Content-Type": "application/json",
//         "X-MERCHANT-ID": merchantId,
//         "X-VERIFY": xVerify,
//       };

//       await http.get(Uri.parse(url), headers: headers).then((value) {
//         Map<String, dynamic> res = jsonDecode(value.body);

//         try {
//           if (res["code"] == "PAYMENT_SUCCESS" &&
//               res['data']['responseCode'] == "SUCCESS") {
//             Fluttertoast.showToast(msg: res["message"]);
//           } else {
//             Fluttertoast.showToast(msg: " Something went wrong");
//           }
//         } catch (e) {
//           Fluttertoast.showToast(msg: " Something went wrong");
//         }
//       });
//     } catch (e) {
//       Fluttertoast.showToast(msg: " Error");
//     }
//   }
// }
