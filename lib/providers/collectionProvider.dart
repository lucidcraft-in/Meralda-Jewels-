// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';

// class CollectionModel {
//   final String? id;
//   final String staffId;
//   final String staffname;
//   final double recievedAmount;
//   final double paidAmount;
//   final double balance;
//   final DateTime date;
//   final int type;
//   final String branch;
//   CollectionModel({
//     this.id,
//     required this.staffId,
//     required this.staffname,
//     required this.recievedAmount,
//     required this.paidAmount,
//     required this.balance,
//     required this.date,
//     required this.type,
//     required this.branch,
//   });
// }

// class CollectionProvider with ChangeNotifier {
//   late FirebaseFirestore firestore;
//   initiliase() {
//     firestore = FirebaseFirestore.instance;
//   }

//   CollectionReference collectionReference =
//       FirebaseFirestore.instance.collection('collection');

//   CollectionReference collectionReferenceStaff =
//       FirebaseFirestore.instance.collection('staffs');
//   late List<CollectionModel> _collection;

//   Future<void> create(CollectionModel collectionModel, String transId) async {
//     QuerySnapshot querySnapshot;
//     try {
//       await collectionReference.add({
//         'staffId': collectionModel.staffId,
//         'staffname': collectionModel.staffname,
//         'recievedAmount': collectionModel.recievedAmount,
//         'paidAmount': collectionModel.paidAmount,
//         'balance': collectionModel.balance,
//         'date': collectionModel.date,
//         'timestamp': FieldValue.serverTimestamp(),
//         'type': collectionModel.type,
//         'branch': collectionModel.branch,
//         "transactionMode": "Direct",
//         "transactionId": transId
//       });
//     } catch (err) {
//       print(err);
//     }
//   }

//   Future<void> update(
//     String id,
//     CollectionModel collectionModel,
//   ) async {
//     try {
//       QuerySnapshot querySnapshot;
//       await collectionReference.doc(id).update({
//         'recievedAmount': collectionModel.recievedAmount,
//         'paidAmount': collectionModel.paidAmount,
//         'balance': collectionModel.balance,
//         'date': collectionModel.date,
//       });
//     } catch (err) {
//       print(err);
//     }
//   }

//   Future<List?> staffCollectionReport(
//     DateTime fromDate,
//     DateTime toDate,
//     String branchId,
//   ) async {
//     double totalCollectedAmt = 0;
//     double totalpaidAmount = 0;
//     double balanceAmount = 0;

//     // DateTime onlyDateStart =
//     //     DateTime(startDate.year, startDate.month, startDate.day);

//     // DateTime onlyDateEnd = DateTime(endDate.year, endDate.month, endDate.day);

//     QuerySnapshot querySnapshot;
//     QuerySnapshot querySnapshotStaff;
//     List staffcollectionList = [];

//     try {
//       querySnapshotStaff = await collectionReferenceStaff
//           .where("branch", isEqualTo: branchId)
//           .get();

//       if (querySnapshotStaff.docs.isNotEmpty) {
//         for (var docStaff in querySnapshotStaff.docs.toList()) {
//           totalCollectedAmt = 0;
//           totalpaidAmount = 0;
//           balanceAmount = 0;
//           querySnapshot = await collectionReference
//               .where("branch", isEqualTo: branchId)
//               .where("staffId", isEqualTo: docStaff.id)
//               .where("date", isGreaterThanOrEqualTo: fromDate)
//               .where("date", isLessThanOrEqualTo: toDate)
//               .get();

//           if (querySnapshot.docs.isNotEmpty) {
//             for (var doc in querySnapshot.docs.toList()) {
//               totalCollectedAmt = totalCollectedAmt + doc['recievedAmount'];
//               totalpaidAmount = totalpaidAmount + doc['paidAmount'];
//             }
//           }

//           balanceAmount = totalCollectedAmt - totalpaidAmount;
//           Map a = {
//             "id": docStaff.id,
//             "totalCollectedAmt": totalCollectedAmt,
//             "totalPaidAmount": totalpaidAmount,
//             "staffBalance": balanceAmount,
//             "staffName": docStaff['staffName'],
//           };
//           staffcollectionList.add(a);
//         }
//         return staffcollectionList;
//       }
//     } catch (err) {
//       print(err);
//     }
//   }

//   Future<List?> todaycollection(
//     DateTime today,
//     String branchId,
//   ) async {
//     double totalCollectedAmt = 0;
//     double totalpaidAmount = 0;
//     double balanceAmount = 0;
//     QuerySnapshot querySnapshot;
//     QuerySnapshot querySnapshotStaff;
//     List staffcollectionList = [];

//     try {
//       DateTime startOfDay =
//           DateTime(today.year, today.month, today.day, 0, 0, 0);
//       DateTime endOfDay =
//           DateTime(today.year, today.month, today.day, 23, 59, 59, 999);

//       print(today);
//       totalCollectedAmt = 0;
//       totalpaidAmount = 0;
//       balanceAmount = 0;
//       querySnapshot = await collectionReference
//           .where("date", isGreaterThanOrEqualTo: startOfDay)
//           .where("date", isLessThan: endOfDay)
//           // .where("branch", isEqualTo: branchId)
//           // .where("staffId", isEqualTo: docStaff.id)
//           // .where("date", isEqualTo: today)
//           // .where("date", isLessThanOrEqualTo: toDate)
//           .get();
//       print("----------");
//       print(querySnapshot.docs.length);
//       if (querySnapshot.docs.isNotEmpty) {
//         for (var doc in querySnapshot.docs.toList()) {
//           print(doc["date"]);
//           totalCollectedAmt = totalCollectedAmt + doc['recievedAmount'];
//           totalpaidAmount = totalpaidAmount + doc['paidAmount'];
//         }
//       }

//       balanceAmount = totalCollectedAmt - totalpaidAmount;
//       Map a = {
//         "totalCollectedAmt": totalCollectedAmt,
//         "totalPaidAmount": totalpaidAmount,
//         "staffBalance": balanceAmount,
//       };
//       staffcollectionList.add(a);

//       return staffcollectionList;
//     } catch (err) {
//       print(err);
//     }
//   }

//   getStaffBalance(String staffId) async {
//     double sumRecieve = 0;
//     double sumPaid = 0;
//     QuerySnapshot querySnapshot2;
//     querySnapshot2 =
//         await collectionReference.where("staffId", isEqualTo: staffId).get();
//     // print("----- All Amount  -------- -----");
//     // print(querySnapshot2.docs.length);
//     if (querySnapshot2.docs.isNotEmpty) {
//       for (var doc in querySnapshot2.docs.toList()) {
//         // totalCollectedAmt = totalCollectedAmt + doc['recievedAmount'];
//         sumRecieve = sumRecieve + doc['paidAmount'];
//         sumPaid = sumPaid + doc['recievedAmount'];
//       }
//       double balance = sumPaid - sumRecieve;

//       // print(balance);
//       return balance;
//     }
//   }

//   getCollcetionReport(String staffId, DateTime selectedDate) async {
//     final lastDayOfMonth =
//         DateTime(selectedDate.year, selectedDate.month + 1, 0, 23, 59, 59, 999);
//     final firstDayofMonth = DateTime(selectedDate.year, selectedDate.month, 1);

//     // Fetch documents within the desired date range and for the given staffId
//     QuerySnapshot querySnapshot2 = await collectionReference
//         .where("staffId", isEqualTo: staffId)
//         .where("type", isEqualTo: 1)
//         .where("timestamp", isGreaterThanOrEqualTo: firstDayofMonth)
//         .where("timestamp", isLessThanOrEqualTo: lastDayOfMonth)
//         .get();
//     // print("----");
//     // print(querySnapshot2.docs);
//     // Map the results to a simplified structure
//     List data = querySnapshot2.docs.map((doc) {
//       return {
//         "id": doc.id,
//         "paidAmount": doc["paidAmount"],
//         "date": doc["timestamp"],
//       };
//     }).toList();

//     return data;
//   }
// }
