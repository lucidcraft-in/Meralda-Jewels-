import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../Providers/transaction.dart';
import '../../common/colo_extension.dart';

class SingleViewPayment extends StatefulWidget {
  final String documentId;

  SingleViewPayment({required this.documentId});

  @override
  _SingleViewPaymentState createState() => _SingleViewPaymentState();
}

class _SingleViewPaymentState extends State<SingleViewPayment> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  DateTime? _selectedDate;
  String? _pickedFile;
  File? selectedFile;
  bool checkValue = false;
  var user;
  TextEditingController _amountController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  TextEditingController _graRateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // getGoldRate();

    getDocumentData();
  }

  var data;
  getDocumentData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('paymentRequst') // Replace with your collection name
        .doc(widget.documentId)
        .get();

    if (doc.exists) {
      data = doc.data() as Map<String, dynamic>;
      if (data != null) {
        setState(() {
          isLoad = true;
          _amountController.text = data['amount'].toString();
          _noteController.text = data['note'];
          _selectedDate = (data['date'] as Timestamp).toDate();
          _graRateController.text = data['goldRate'] != null
              ? data['goldRate'].toString()
              : 0.toString();
        });
      }
    }
  }

  bool isLoad = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Upload Screenshot'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: isLoad == true
          ? Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('Customer Name : '),
                        Text(data['userName']),
                      ],
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter valid amount';
                        }
                        return null;
                      },
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Amount",
                        labelStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
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
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _noteController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Note",
                        labelStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
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
                    Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromARGB(255, 185, 185, 185)),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
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
                    SizedBox(height: 16.0),
                    Container(
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
                            height: 200,
                            image: NetworkImage(data['image']),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(height: 16.0),
                    // data['status'] != "approve"
                    //     ? Container(
                    //         width: 200,
                    //         height: 50,
                    //         child: ElevatedButton(
                    //           style: ElevatedButton.styleFrom(
                    //             primary: Theme.of(context)
                    //                 .primaryColor, // Background color
                    //             onPrimary: Colors.white, // Text color
                    //             shape: RoundedRectangleBorder(
                    //               borderRadius:
                    //                   BorderRadius.circular(10), // Rounded corners
                    //             ),
                    //           ),
                    //           onPressed: _isSubmitting ? null : null
                    //           // _submitForm,
                    //           ,
                    //           child: _isSubmitting
                    //               ? CircularProgressIndicator(
                    //                   valueColor:
                    //                       AlwaysStoppedAnimation<Color>(Colors.white),
                    //                 )
                    //               : Text('Approve'),
                    //         ),
                    //       )
                    //     : Container(),
                  ],
                ),
              ),
            )
          : Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 80.0,
                      width: 80.0,
                      color: Colors.white,
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      height: 20.0,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      height: 20.0,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // var goldRate;
  // List goldrateList = [];
  // Goldrate? dbGoldrate;
  // var StaffData;
  // getGoldRate() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   setState(() {
  //     StaffData = jsonDecode(prefs.getString('staff')!);
  //   });
  //   dbGoldrate = Goldrate();
  //   dbGoldrate!.initiliase();
  //   dbGoldrate!.read().then((value) => {
  //         setState(() {
  //           goldrateList = value!;

  //           goldRate = goldrateList[0]['gram'].toString();
  //         }),
  //       });
  // }
}
