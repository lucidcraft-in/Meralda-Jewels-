import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String? name;
  final String? custId;
  final String? phoneNo;
  final String? address;
  final String? place;
  final double? balance;
  final String? token;
  final double? totalGram;

  final DateTime? dateofBirth;
  final String? nominee;
  final String? nomineePhone;
  final String? nomineeRelation;
  final String? adharCard;
  final String? panCard;
  final String? pinCode;

  UserModel({
    this.id,
    this.name,
    this.custId,
    this.phoneNo,
    this.address,
    this.place,
    this.balance,
    this.token,
    this.totalGram,
    this.dateofBirth,
    this.nominee,
    this.nomineePhone,
    this.nomineeRelation,
    this.adharCard,
    this.panCard,
    this.pinCode,
  });

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'],
      name: data['name'],
      custId: data['custId'],
      phoneNo: data['phoneNo'],
      address: data['address'],
      place: data['place'],
      balance: (data['balance'] as num?)?.toDouble(),
      token: data['token'],
      totalGram: (data['totalGram'] as num?)?.toDouble(),
      dateofBirth: data['dateofBirth'] != null
          ? DateTime.parse(data['dateofBirth'])
          : null,
      nominee: data['nominee'],
      nomineePhone: data['nomineePhone'],
      nomineeRelation: data['nomineeRelation'],
      adharCard: data['adharCard'],
      panCard: data['panCard'],
      pinCode: data['pinCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'custId': custId,
      'phoneNo': phoneNo,
      'address': address,
      'place': place,
      'balance': balance,
      'token': token,
      'totalGram': totalGram,
      'dateofBirth': dateofBirth?.toIso8601String(),
      'nominee': nominee,
      'nomineePhone': nomineePhone,
      'nomineeRelation': nomineeRelation,
      'adharCard': adharCard,
      'panCard': panCard,
      'pinCode': pinCode,
    };
  }
}

DateTime? _toDate(dynamic value) {
  if (value == null) return null;
  if (value is Timestamp) return value.toDate();
  return value as DateTime?;
}

class User with ChangeNotifier {
  late FirebaseFirestore firestore;
  initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('user');
  // Map<String, UserModel> _user = {};
  late List<UserModel> _user;
  late List<UserModel> user;

  // Future loginData(String custId, String password) async {
  //   QuerySnapshot querySnapshot =
  //       await collectionReference.where("custId", isEqualTo: custId).get();
  //   print(querySnapshot.docs.length);
  // }

  set listStaff(List<UserModel> val) {
    _user = val;
    notifyListeners();
  }

  List<UserModel> get listUsers => _user;
  // Map<String, UserModel> get users {
  //   return {..._user};
  // }

  int get userCount {
    return _user.length;
  }

  // Future<void> create(UserModel userModel) async {
  //   try {
  //     print("inside create ");
  //     print(userModel.name);
  //     await collectionReference.add({
  //       'name': userModel.name,
  //       'custId': userModel.custId,
  //       'phone_no': userModel.phoneNo,
  //       'address': userModel.address,
  //       'place': userModel.place,
  //       'balance': userModel.balance,
  //       'timestamp': FieldValue.serverTimestamp()
  //     });
  //     notifyListeners();
  //     final newUser = UserModel(
  //       id: userModel.id,
  //       name: userModel.name,
  //       custId: userModel.custId,
  //       phoneNo: userModel.phoneNo,
  //       address: userModel.address,
  //       place: userModel.place,
  //     );

  //     notifyListeners();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<List?> read() async {
    QuerySnapshot querySnapshot;
    List userlist = [];
    try {
      querySnapshot = await collectionReference.orderBy('timestamp').get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "name": doc['name'],
            "custId": doc["custId"],
            "phoneNo": doc["phone_no"],
            "address": doc["address"],
            // "scheme": doc["scheme"],
            "place": doc["place"],
            "balance": doc['balance'],
            "totalGram": doc["total_gram"],
            "branch": doc['branch'],
            "schemeType": doc["schemeType"],
            // "dateofBirth": doc['dateofBirth'].toDate(),
            "nominee": doc['nominee'],
            "nomineePhone": doc['nomineePhone'],
            "nomineeRelation": doc['nomineeRelation'],
            "adharCard": doc['adharCard'],
            "panCard": doc['panCard'],
            "pinCode": doc['pinCode'],
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

  Future<List?> readById(String userId) async {
    QuerySnapshot querySnapshot;
    List userlist = [];
    try {
      querySnapshot = await collectionReference.orderBy('timestamp').get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          if (userId == doc.id) {
            Map a = {
              "id": doc.id,
              "name": doc['name'],
              "custId": doc["custId"],
              "phoneNo": doc["phone_no"],
              "address": doc["address"],
              "scheme": doc["scheme"],
              "schemeType": doc["schemeType"],

              "place": doc["place"],
              "balance": doc['balance'],
              "totalGram": doc["total_gram"],
              "branch": doc["branch"],
              //  "dateofBirth": doc['dateofBirth'].toDate(),
              "nominee": doc['nominee'],
              "nomineePhone": doc['nomineePhone'],
              "nomineeRelation": doc['nomineeRelation'],
              "adharCard": doc['adharCard'],
              "panCard": doc['panCard'],
              "pinCode": doc['pinCode'],
              "token": doc["token"],
            };
            userlist.add(a);
          }
        }
        // print(userlist);
        return userlist;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  void removeItem(String productId) {
    _user.remove(productId);
    notifyListeners();
  }

  void clear() {
    _user = [];
    notifyListeners();
  }

  Future getUserById(String custId) async {
    QuerySnapshot querySnapshot =
        await collectionReference.where("custId", isEqualTo: custId).get();
    if (querySnapshot.docs.length > 0) {
      return false;
    } else {
      return true;
    }
  }

  Future checkUserByPhone(String phoneNo) async {
    List userlist = [];
    QuerySnapshot querySnapshot =
        await collectionReference.where("phone_no", isEqualTo: phoneNo).get();
    if (querySnapshot.docs.length > 0) {
      for (var doc in querySnapshot.docs.toList()) {
        Map a = {
          "id": doc.id,
          "name": doc['name'],
          "custId": doc["custId"],
          "phoneNo": doc["phone_no"],
        };
        userlist.add(a);
      }
      return [true, userlist];
    } else {
      return [false, []];
    }
  }

  Future assignOtp(double otp, String userId) async {
    try {
      collectionReference.doc(userId).update({
        "otp": otp,
        "otpExp": FieldValue.serverTimestamp(),
        "otpGen": FieldValue.serverTimestamp()
      });
      return true;
    } catch (e) {
      return e;
    }
  }

  getUserOtpByUser(String userId) async {
    try {
      DocumentSnapshot userDoc = await collectionReference.doc(userId).get();
      if (userDoc.exists) {
        // print(userDoc['otp']);
        return [userDoc['otp'], userDoc['otpGen']];
      } else {
        // print('User not found');
      }
      return true;
    } catch (e) {
      return e;
    }
  }

  Future loginUser(String custId, String phoneNo) async {
    print("----------");
    List userlist = [];
    QuerySnapshot querySnapshot;

    try {
      querySnapshot = await collectionReference
          .where("custId", isEqualTo: custId)
          .where("phone_no", isEqualTo: phoneNo)
          .get();
      print(querySnapshot.docs.length);
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "name": doc['name'],
            "custId": doc["custId"],
            "phoneNo": doc["phone_no"],
            "address": doc["address"],
            // "scheme": doc["scheme"],
            "place": doc["place"],
            "balance": doc['balance'],
            "totalGram": doc["total_gram"],
            "branch": doc['branch'],
            "schemeType": doc["schemeType"],
            // "dateofBirth": doc['dateofBirth'].toDate(),
            "nominee": doc['nominee'],
            "nomineePhone": doc['nomineePhone'],
            "nomineeRelation": doc['nomineeRelation'],
            "adharCard": doc['adharCard'],
            "panCard": doc['panCard'],
            "pinCode": doc['pinCode'],
          };
          userlist.add(a);
        }
        print(userlist);
        return userlist;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
    }

    // try {
    //   QuerySnapshot querySnapshot =
    //       await collectionReference.where("custId", isEqualTo: custId).get();

    //   if (querySnapshot.docs.isNotEmpty) {
    //     final doc = querySnapshot.docs.first;
    //     final userData = doc.data() as Map<String, dynamic>;

    //     // Optionally store the user data locally if needed
    //     final user = UserModel.fromJson({
    //       ...userData,
    //       'id': doc.id,
    //     });

    //     _user = [user]; // store single user
    //     saveUserLocally(user);
    //     notifyListeners();

    //     return {
    //       'success': true,
    //       'user': user,
    //     };
    //   } else {
    //     return {
    //       'success': false,
    //       'message': 'No user found with this ID',
    //     };
    //   }
    // } catch (e) {
    //   print(e);
    //   return {
    //     'success': false,
    //     'message': 'Error occurred: $e',
    //   };
    // }
  }

  Future<void> saveUserLocally(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString('user_data', userJson);
  }
}
