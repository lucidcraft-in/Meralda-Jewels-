import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meralda_gold_user/Providers/transaction.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../widgets/transaction_list.dart';

import '../providers/user.dart';
import 'homeNavigation.dart';
import 'profile.dart';

class TransactionScreen extends StatefulWidget {
  static const routeName = "/transaction-screen";

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  var user;
  bool? _checkValue;
  TransactionProvider? db;
  User? dbUser;
  List transactionList = [];
  List userList = [];
  DateTime lastUpdate = DateTime.now();
  double customerBalance = 0;
  double totalGram = 0;
  List alllist = [];

  initialise() {
    db = TransactionProvider();
    dbUser = User();
    db!.initiliase();

    db!.read(user['id']).then((value) {
      setState(() {
        alllist = value!;
        transactionList = alllist[0];
        customerBalance = alllist[1];
        totalGram = alllist[2];
      });
    });
  }

  List userData = [];
  checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _checkValue = prefs.containsKey('user');
    // print(_checkValue);
    if (_checkValue == true) {
      setState(() {
        user = jsonDecode(prefs.getString('user')!);
      });
      Provider.of<User>(context, listen: false)
          .readById(user["id"])
          .then((val) {
        setState(() {
          userData = val!;
        });
        print("==========");
        print(userData);
      });

      await initialise();
    }

    // user = prefs.containsKey('user');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
    checkUser();
  }

  bool checkValue = false;
  checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    checkValue = prefs.containsKey('user');
    // if (_checkValue == true) {
    //   Navigator.of(context).pushNamed(TransactionScreen.routeName);
    // } else {
    //   Navigator.of(context).pushNamed(LoginScreen.routeName);
    // }
  }

  @override
  Widget build(BuildContext context) {
    if (transactionList.length > 0) {
      lastUpdate = transactionList[0]['date'].toDate();
    }

    // if (userList != null) {
    //   customerBalance = userList[0]['balance'].toDouble();
    //   totalGram = userList[0]["totalGram"].toDouble();
    // }

    // Clear shared preferance
    logout() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.getKeys();
      for (String key in preferences.getKeys()) {
        preferences.remove(key);
      }
      setState(() {});
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeNavigation()),
          (Route route) => false);
      // Navigator.pushReplacement(context,
      //     new MaterialPageRoute(builder: (context) => new HomeNavigation()));

      // Navigate Page
      // Navigator.of(context).pushNamed(HomeScreen.routeName);
    }

    return checkValue == true
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 2,
              backgroundColor: Theme.of(context).primaryColor,
              centerTitle: true,
              title: Text(
                "TRANSACTIONS",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'latto',
                    fontWeight: FontWeight.bold),
              ),
              iconTheme: IconThemeData(color: Colors.white),
            ),
            body: SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height,
                // padding: EdgeInsets.only(top: 35),
                color: Colors.white,
                child: Column(
                  children: [
                    titleCard(),
                    Container(
                      padding: EdgeInsets.only(left: 10, top: 10),
                      child: Row(
                        children: [
                          Text(
                            "Transaction List",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(child: TransactionList()),
                  ],
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              elevation: 2,
              backgroundColor: Theme.of(context).primaryColor,
              centerTitle: true,
              title: Text(
                "TRANSACTIONS",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'latto',
                    fontWeight: FontWeight.bold),
              ),
              iconTheme: IconThemeData(color: Colors.white),
            ),
            body: Container(
              height: MediaQuery.of(context).size.height * .7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                      image:
                          AssetImage("assets/images/Mobile login-amico.png")),
                  Text("Your Not Log in",
                      style: TextStyle(
                          fontSize: 18, color: Color.fromARGB(255, 0, 0, 0))),
                  SizedBox(height: 18),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Goto SignIn",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color.fromARGB(255, 0, 0, 0))),
                        Icon(
                          Icons.arrow_forward,
                          size: 18,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );

    // Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Text('Welcome! Please log in.'),
    //         SizedBox(height: 20),
    //         ElevatedButton(
    //           onPressed: () {
    //             Navigator.push(
    //               context,
    //               MaterialPageRoute(builder: (context) => LoginScreen()),
    //             );
    //           },
    //           child: Text('Go to Login Page'),
    //         ),
    //       ],
    //     ),
    //   );
  }

  Widget titleCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .22,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg2.png"),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(15.0), // Border radius
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Shadow color
              spreadRadius: 2, // Spread radius
              blurRadius: 5, // Blur radius
              offset: Offset(3, 3), // Offset of the shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image(
                  color: Color.fromARGB(255, 205, 168, 65),
                  width: 40,
                  image: AssetImage("assets/images/gold-ingot.png")),
              SizedBox(height: 10),
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Gold In locker",
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Center(
                        child: Text(
                          "${userData[0]["totalGram"].toStringAsFixed(3)} gms",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "Cash As Saving",
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.indianRupeeSign,
                            size: 20,
                          ),
                          Text(
                            "${userData[0]["balance"].toStringAsFixed(2)}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Last updated at",
                    style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'latto',
                        color: Colors.grey[400]),
                  ),
                  SizedBox(width: 5),
                  Text(
                    DateFormat.yMMMd()
                        // .add_jm()
                        .format(lastUpdate)
                        .toString(),
                    style: TextStyle(
                        fontFamily: 'latto', fontSize: 11, color: Colors.grey),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
