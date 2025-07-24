import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BannerProvider with ChangeNotifier {
  late FirebaseFirestore firestore;
  initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('Banner');
  CollectionReference sliderCollectionReference =
      FirebaseFirestore.instance.collection('slide');

  Future getSlide(String type) async {
    List sliderList = [];
    QuerySnapshot querySnapshot =
        await collectionReference.where("imageType", isEqualTo: type).get();
    // print(querySnapshot.docs);
    for (var doc in querySnapshot.docs.toList()) {
      Map a = {
        "id": doc.id,
        "photo": doc['photo'],
        "photoName": doc["photoName"],
        "imageType": doc["imageType"]
      };
      sliderList.add(a);
    }

    return sliderList;
  }

  Future fetchData() async {
    List storeList = [];
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('aboutUs').get();

      for (var doc in querySnapshot.docs.toList()) {
        Map a = {
          "id": doc.id,
          "address": doc['address'],
          "jewelleryName": doc["jewelleryName"],
          "phone": doc["phone"],
          "place": doc["place"],
          "whatsapp": doc["whatsapp"]
        };
        storeList.add(a);
      }
      return storeList;
    } catch (e) {
      print("Error fetching data: $e");
    }
  }
}
