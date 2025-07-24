import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StaffModel {
  final String id;
  final String staffName;
  final String location;
  final String address;
  final String phoneNo;
  final String password;
  final String token;
  final double commission;
  final int type; // type =1 admin ,type=0 staff ,type=2 superAdmin
  final int branch;
  StaffModel({
    required this.id,
    required this.staffName,
    required this.location,
    required this.address,
    required this.phoneNo,
    required this.password,
    required this.type,
    required this.token,
    required this.commission,
    required this.branch,
  });
}

class Staff with ChangeNotifier {
  late FirebaseFirestore firestore;
  initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('staffs');

  Future<List?> read() async {
    QuerySnapshot querySnapshot;
    List userlist = [];
    try {
      // .where("branch",isEqualTo: 0)
      querySnapshot = await collectionReference

          // .orderBy('timestamp')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "staffName": doc['staffName'],
            "location": doc["location"],
            "address": doc["address"],
            "phoneNo": doc["phoneNo"],
            "password": doc["password"],
            "type": doc["type"],
            "token": doc['token'],
            "commission": doc['commission'],
            "branch": doc['branch'],
          };
          userlist.add(a);
        }

        return userlist;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
