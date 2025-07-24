import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class phonePe_PaymentModel {
  String custId;
  String custName;
  double amount;
  String note;
  double custPhone;
  String merchantId;
  String currency;
  String status;

  phonePe_PaymentModel(
      {required this.custId,
      required this.amount,
      required this.note,
      required this.custName,
      required this.custPhone,
      required this.merchantId,
      required this.currency,
      required this.status});
}

class phonePe_Payment with ChangeNotifier {
  late FirebaseFirestore firestore;
  initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('online_Transaction');
  String cmpnyCode = "MLBR";
  Future addTransaction(var paymentData) async {
    DateTime now = DateTime.now();
    String id = "";
    // DocumentReference docRef =
    print("+++++++");
    // print(paymentData["custId"]);
    // print(paymentData["TransactionId"]);
    // print(paymentData.custId);

    // print(paymentData.custName);
    // print(paymentData.amount);
    // print(paymentData.custId);
    await collectionReference.add({
      "custId": paymentData["custId"],
      "order_Id": paymentData["TransactionId"],
      "custName": paymentData["custName"],
      "amount": paymentData["amount"],
      "note": paymentData["note"],
      "date": now,
      "custPhone": paymentData["custPhone"],
      "currency": "INR",
      "status": "Initated",
    });

    // id = cmpnyCode + "_" + docRef.id.toUpperCase();
    // docRef.update({
    //   "TransactionId": id,
    // });
    // return id;
  }

  updateTransaction(String orderId, String status) async {
    try {
      // Query the collection where 'orderId' matches the given value
      QuerySnapshot snapshot =
          await collectionReference // Replace with your collection name
              .where('order_Id', isEqualTo: orderId)
              .limit(1) // Limit the result to 1 document
              .get();

      // Check if any document was found
      if (snapshot.docs.isNotEmpty) {
        // Return the document ID
        await collectionReference
            .doc(snapshot.docs.first.id)
            .update({"status": status});
      } else {
        // No document found
        return null;
      }
    } catch (e) {
      // print('Error fetching document: $e');
      return null;
    }
  }

  Future updatePaymentbyTransactionId(
      String id, String status, var data) async {
    var transaction =
        await collectionReference.where("TransactionId", isEqualTo: id).get();

    if (transaction.docs.isNotEmpty) {
      var docId = transaction.docs.first.id;

      await collectionReference
          .doc(docId)
          .update({"status": status, "payment_responce": data});
    }
    // print(querySnapshot.docs[0]);
    return;
  }
}
