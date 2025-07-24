import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PaymentDetails with ChangeNotifier {
  late FirebaseFirestore firestore;
  initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("QRdetails");
  Stream<QuerySnapshot> getAQR() {
    return collectionReference
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots();
  }
}
