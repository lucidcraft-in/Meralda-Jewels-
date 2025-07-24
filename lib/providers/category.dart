import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SliderModel {
  final String? name;

  SliderModel({this.name});
}

class Category with ChangeNotifier {
  late FirebaseFirestore firestore;
  initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("Category");
  CollectionReference schemeCollectionReference =
      FirebaseFirestore.instance.collection("scheme");
  Future getCategory() async {
    var categories = [];
    try {
      QuerySnapshot querySnapshot = await collectionReference.get();

      for (var doc in querySnapshot.docs.toList()) {
        Map a = {
          "id": doc.id,
          "name": doc["name"],
          "image": doc["image"] != null ? doc["image"] : ""
        };
        categories.add(a);
      }
      return categories;
    } catch (e) {}
  }

  Future getCategorywithImg() async {
    var categories = [];
    try {
      QuerySnapshot querySnapshot = await collectionReference.get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Map<String, dynamic> a = {
          "id": doc.id,
          "name": data["name"],
          "image": data.containsKey("image") ? data["image"] : ""
        };
        categories.add(a);
      }
      return categories;
    } catch (e) {
      // Handle error here if needed
      return categories; // Return empty list in case of an error
    }
  }

  Future<List?> read(String category) async {
    QuerySnapshot querySnapshot;
    List userlist = [];
    try {
      querySnapshot = await collectionReference
          .where("category", isEqualTo: category)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "photoName": doc['photoName'],
            "photo": doc["photo"],
            "productName": doc["productName"],
            "productCode": doc["productCode"],
            "description": doc["description"],
            "gram": doc["gram"],
            "category": doc["category"]
          };
          userlist.add(a);
        }

        return userlist;
      }
    } catch (e) {
      // print(e);
    }
    return null;
  }

  Future getScheme() async {
    var categories = [];
    try {
      QuerySnapshot querySnapshot = await schemeCollectionReference.get();

      for (var doc in querySnapshot.docs.toList()) {
        Map a = {"id": doc.id, "name": doc["name"]};
        categories.add(a);
      }
      return categories;
    } catch (e) {}
  }
}
