import 'package:flutter/material.dart';
import '../screens/categoryScreen.dart';
import '../Providers/goldrate.dart';
import '../providers/storage_service.dart';
import '../screens/samplepayment.dart';
import './slider_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../screens/payment_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final Storage storage = Storage();
  Goldrate? db;

  List goldrateList = [];

  initialise() {
    db = Goldrate();
    db?.initiliase();
    db?.read().then((value) => {
          setState(() {
            goldrateList = value!;
          })
        });
  }

  @override
  void initState() {
    super.initState();
    initialise();
  }

  _launchFacebookURL() async {
    const url = 'https://www.facebook.com/MalabariGOLD';

    // if (await canLaunch(url)) {
    await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
  }

  _launchInstagramURL() async {
    const url = 'https://www.instagram.com/malabari_jewels?r=nametag';
    // if (await canLaunch(url)) {
    await launch(url);
    // } else {
    //   print('Could not launch $url');
    // }
  }

  static Future<void> _launchWebrURL() async {
    String googleUrl =
        'https://www.facebook.com/Malabari-Jewels-111036664075813/';

    await launch(googleUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey[100],
        child: Column(
          children: [
            Container(
              // width: MediaQuery.of(context).size.width - 20,
              width: double.infinity,
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  kToolbarHeight -
                  kBottomNavigationBarHeight -
                  450,
              padding: EdgeInsets.only(top: 5, bottom: 5),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                color: Colors.grey[50],
                // child: imageSlider(context),
                child: SliderPage(),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                  width: MediaQuery.of(context).size.width,
                  height: 120,
                  child: Card(
                      elevation: 0.4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                        // side: BorderSide(
                        //   color: Colors.purple.withOpacity(0.2),
                        //   width: 1,
                        // ),
                      ),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "TODAY'S GOLD RATE",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54,
                                      fontFamily: 'Lato'),
                                ),
                                SizedBox(height: 10)
                              ],
                            ),
                          ),
                          Container(
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'PER GRAM',
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 12),
                                  ),
                                  Text(
                                    '8 GRAM',
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 12),
                                  ),
                                  Text(
                                    (() {
                                      if (goldrateList.length > 0 &&
                                          goldrateList[0]['down'] == 0) {
                                        return "Up";
                                      } else {
                                        return "Down";
                                      }
                                    }()),
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    '₹ ${goldrateList.length > 0 ? goldrateList[0]['gram'].toString() : '00'}',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    '₹ ${goldrateList.length > 0 ? goldrateList[0]['pavan'].toString() : '00'}',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    (() {
                                      if (goldrateList.length > 0 &&
                                          goldrateList[0]['down'] == 0) {
                                        return '₹ ${goldrateList.length > 0 ? goldrateList[0]['up'].toString() : '00'}';
                                      } else {
                                        return '₹ ${goldrateList.length > 0 ? goldrateList[0]['down'].toString() : '00'}';
                                      }
                                    }()),
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                )
              ],
            ),
            // SizedBox(height: 40,),

            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                  width: MediaQuery.of(context).size.width / 2,
                  height: 130,
                  child: GestureDetector(
                    onTap: () {
                      print("--------");
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => PhonePePayment()));
                      // Navigator.of(context).pushNamed(PaymentScreen.routeName);
                    },
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              radius: 28,
                              child: const FaIcon(
                                FontAwesomeIcons.creditCard,
                                color: Color(0xff12244b),
                                size: 17,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            "Pay Online",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                    // width: double.infinity,

                    height: 130,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CategoryScreen()));
                        // Navigator.of(context)
                        //     .pushNamed(ProductListScreen.routeName);
                      },
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: CircleAvatar(
                                backgroundColor: Colors.grey[300],
                                radius: 28,
                                child: FaIcon(
                                  FontAwesomeIcons.boxOpen,
                                  color: Theme.of(context).primaryColor,
                                  size: 17,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              "Design Jewellery",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),

            Row(
              children: [
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(top: 5, left: 15, right: 15),
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  child: Column(
                    children: [
                      Container(
                        // padding: EdgeInsets.all(5),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,

                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "WE ARE ON SOCIAL",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                  fontFamily: 'Lato',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Center(
                          child: IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      _launchFacebookURL();
                                    },
                                    child: Card(
                                      elevation: 0,
                                      color: Colors.white,
                                      child: Container(
                                        height: 45,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const FaIcon(
                                              FontAwesomeIcons.facebook,
                                              color: Color(0xFF4267B2),
                                              size: 25,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "facebook",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const VerticalDivider(
                                  width: 20,
                                  thickness: 1,
                                  indent: 0,
                                  endIndent: 0,
                                  color: Colors.black12,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      _launchInstagramURL();
                                    },
                                    child: Card(
                                      elevation: 0,
                                      color: Colors.white,
                                      child: Container(
                                        height: 45,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const FaIcon(
                                              FontAwesomeIcons.instagram,
                                              color: Color(0xFF48a3ab9),
                                              size: 25,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "Instagram",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const VerticalDivider(
                                  width: 20,
                                  thickness: 1,
                                  indent: 0,
                                  endIndent: 0,
                                  color: Colors.black12,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      _launchWebrURL();
                                    },
                                    child: Card(
                                      elevation: 0,
                                      color: Colors.white,
                                      child: Container(
                                        height: 45,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const FaIcon(
                                              FontAwesomeIcons.globe,
                                              color: Colors.blue,
                                              size: 25,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "Website",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            // mapppppp

            // =================
          ],
        ));
  }
}
