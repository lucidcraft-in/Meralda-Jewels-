import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meralda_gold_user/screens/homeNavigation.dart';
import '../Providers/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/newHomeScreen.dart';

class LoginForm extends StatefulWidget {
  // static const routeName = "/login-screen-form";
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  User? db;

  List userList = [];
  List filterList = [];

  var index;

  TextEditingController _customerIdController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final _form = GlobalKey<FormState>();
  TextStyle style = TextStyle(
    fontFamily: 'latto',
    fontSize: 20.0,
    color: Colors.white,
  );

  login() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    filterList = userList
        .where((element) => (element['custId']
            .toLowerCase()
            .contains(_customerIdController.text.toLowerCase())))
        .toList();

    if (filterList.isNotEmpty &&
        filterList[0]['custId'] == _customerIdController.text) {
      if (filterList[0]['phoneNo'] == _passwordController.text) {
        sharedPreferences.setString("user", json.encode(filterList[0]));

        final snackBar = SnackBar(
          content: const Text('Loggin Success.....'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => HomeNavigation()),
            (Route<dynamic> route) => false);

        String? token = await FirebaseMessaging.instance.getToken();

        if (filterList[0]['token'] == "" || filterList[0]['token'] == null) {
          FirebaseFirestore.instance
              .collection('user')
              .doc(filterList[0]['id'])
              .set({'token': token}, SetOptions(merge: true));
        }
      } else {
        final snackBar = SnackBar(
          content: const Text('Wrong password!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      final snackBar = SnackBar(
        content: const Text('Customer id is invalid!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _form,
        child: Container(
          padding: EdgeInsets.only(left: 25, right: 25),
          child: Column(children: <Widget>[
            TextFormField(
              controller: _customerIdController,
              textAlign: TextAlign.left,
              // controller: _emailController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please provide Valid customer id.';
                }
                return null;
              },
              obscureText: false,
              style: TextStyle(
                  color: Color.fromARGB(255, 73, 73, 73), fontSize: 18),
              decoration: InputDecoration(
                hintText: "Customer Id",
                hintStyle: TextStyle(color: Color.fromARGB(255, 61, 61, 61)),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 52, 52, 52)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _passwordController,
              textAlign: TextAlign.left,
              // controller: _emailController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please provide a value.';
                }
                return null;
              },
              obscureText: false,
              style: TextStyle(
                  color: Color.fromARGB(255, 47, 47, 47), fontSize: 18),
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: TextStyle(color: Color.fromARGB(255, 61, 61, 61)),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 52, 52, 52)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Material(
              elevation: 1.0,
              borderRadius: BorderRadius.circular(12.0),
              color: Theme.of(context).primaryColor,
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                onPressed: () {
                  login();
                },
                child: Text("Login",
                    textAlign: TextAlign.center,
                    style: style.copyWith(
                        color: Color.fromARGB(255, 252, 252, 252),
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
