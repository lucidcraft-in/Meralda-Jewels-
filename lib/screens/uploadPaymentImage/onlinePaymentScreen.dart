// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:oro_user/common/colo_extension.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Onlinepaymentscreen extends StatefulWidget {
//   @override
//   _OnlinePaymentScreenState createState() => _OnlinePaymentScreenState();
// }

// class _OnlinePaymentScreenState extends State<Onlinepaymentscreen> {
//   bool _checkValue = false;
//   var user;
//   String userName = "User"; // Default name

//   TextEditingController amountController = TextEditingController();
//   TextEditingController noteController = TextEditingController();
//   bool isPayNowEnabled = false;

//   @override
//   void initState() {
//     super.initState();
//     amountController.addListener(checkInputs);
//     noteController.addListener(checkInputs);
//     checkLogin();
//   }

//   Future<void> checkLogin() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     _checkValue = prefs.containsKey('user');

//     if (_checkValue) {
//       var data = prefs.getString("user");

//       if (data != null) {
//         var userData = jsonDecode(data);
//         setState(() {
//           user = userData;
//           userName = userData["name"] ?? "User"; // Get user's name
//         });
//       }
//     }
//   }

//   void checkInputs() {
//     setState(() {
//       isPayNowEnabled = amountController.text.isNotEmpty &&
//           noteController.text.isNotEmpty &&
//           double.tryParse(amountController.text) != null &&
//           double.parse(amountController.text) > 0;
//     });
//   }

//   void showPaymentNotAvailable() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text("Currently, payment is not available"),
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     amountController.dispose();
//     noteController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: TColo.primaryColor1,
//         title: Text('Payment'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(height: 50),
//             Text(
//               "Hello...",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//             ),
//             Text(
//               userName, // Display the logged-in user's name
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 30),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "₹",
//                   style: TextStyle(
//                       fontSize: 30,
//                       fontWeight: FontWeight.bold,
//                       color: TColo.primaryColor1),
//                 ),
//                 SizedBox(width: 5),
//                 Container(
//                   width: 100,
//                   child: TextField(
//                     controller: amountController,
//                     keyboardType: TextInputType.number,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//                     decoration: InputDecoration(
//                       border: InputBorder.none,
//                       hintText: "0",
//                       hintStyle: TextStyle(color: Colors.grey, fontSize: 30),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: TextField(
//                 controller: noteController,
//                 textAlign: TextAlign.center,
//                 decoration: InputDecoration(
//                   hintText: "Add a note",
//                   border: InputBorder.none,
//                   contentPadding: EdgeInsets.symmetric(vertical: 10),
//                 ),
//               ),
//             ),
//             SizedBox(height: 30),
//             Text(
//               "Plane Price ₹",
//               style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//             ),
//             Text(
//               "Including convenience fee(2%) : ₹0.0",
//               style: TextStyle(fontSize: 14, color: Colors.grey),
//             ),
//             SizedBox(height: 30),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor:
//                     isPayNowEnabled ? TColo.primaryColor1 : Colors.grey,
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                 textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               onPressed: isPayNowEnabled ? showPaymentNotAvailable : null,
//               child: Text("Pay Now"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
