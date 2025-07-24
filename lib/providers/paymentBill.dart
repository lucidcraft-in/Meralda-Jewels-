import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firbase_storage;

class PaymentBillProvider with ChangeNotifier {
  late FirebaseFirestore firestore;
  initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  final firbase_storage.FirebaseStorage storage =
      firbase_storage.FirebaseStorage.instance;

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('paymentRequst');

  addPayment(double amount, String note, double goldRate, DateTime date,
      File file, String fileName, var user) async {
    try {
      final Directory systemTempDir = Directory.systemTemp;

      firbase_storage.TaskSnapshot taskSnapshot =
          await storage.ref('paymentRec/$fileName').putFile(file);
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      // print(downloadUrl);
      collectionReference.add({
        "amount": amount,
        "note": note,
        "image": downloadUrl,
        "imageName": fileName,
        "status": "Request",
        "userId": user["id"],
        "userName": user["name"],
        "date": date,
        "goldRate": goldRate,
        "timestamp": FieldValue.serverTimestamp()
      });
      return 200;
    } catch (e) {
      return 400;
    }
  }

  // getAllData(String userId) async {
  //   QuerySnapshot querySnapshot =
  //       await collectionReference.where("userId", isEqualTo: userId).get();
  // }

  Stream<QuerySnapshot> getAllData(String userId) {
    return collectionReference
        .where("userId", isEqualTo: userId)
        .orderBy("date", descending: true)
        .snapshots();
  }
}
