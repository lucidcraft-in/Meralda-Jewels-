// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import '../widgets/terms.dart';
// import './login_screen.dart';
// import '../widgets/home_view.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../service/local_push_notification.dart';
// import '../screens/transaction_screen.dart';
// import 'googlemap_screen.dart';
// import '../screens/gold_rate_screen.dart';
// import '../screens/permission_message.dart';
// import '../providers/goldrate.dart';

// class HomeScreen extends StatefulWidget {
//   static const routeName = '/home-screen';
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   DateTime timeBackPress = DateTime.now();
//   int _selectedIndex = 0;
//   bool? _checkValue;
//   AndroidNotificationChannel? channel;
//   var buttonSize = const Size(50.0, 50.0);
//   var buttonSize2 = const Size(30.0, 30.0);
//   FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
//   String appBarName = "Malabari Jewellery";
//   void _onItemTapped(int index) {
//     if (index == 0) {
//       setState(() {
//         appBarName = "Malabari Jewellery";
//       });
//     }
//     if (index == 1) {
//       setState(() {
//         appBarName = "Maps";
//         // print("appBar");
//       });
//     }

//     if (index != 3) {
//       setState(() {
//         _selectedIndex = index;
//       });
//     }
//   }

//   void loadFCM() async {
//     if (!kIsWeb) {
//       channel = const AndroidNotificationChannel(
//         'high_importance_channel', // id
//         'High Importance Notifications', // title
//         // 'This channel is used for important notifications.', // description
//         importance: Importance.high,
//         enableVibration: true,
//       );

//       flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//       /// Create an Android Notification Channel.
//       ///
//       /// We use this channel in the `AndroidManifest.xml` file to override the
//       /// default FCM channel to enable heads up notifications.
//       await flutterLocalNotificationsPlugin!
//           .resolvePlatformSpecificImplementation<
//               AndroidFlutterLocalNotificationsPlugin>()
//           ?.createNotificationChannel(channel!);

//       /// Update the iOS foreground notification presentation options to allow
//       /// heads up notifications.
//       await FirebaseMessaging.instance
//           .setForegroundNotificationPresentationOptions(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//     }
//   }

//   Goldrate? db;

//   initialise() {
//     db = Goldrate();

//     db!.initiliase();

//     db!.checkPermission().then((value) => {
//           if (value == false)
//             {
//               Navigator.pushReplacementNamed(
//                 context,
//                 PermissionMessage.routeName,
//               ),
//             }
//         });
//   }

//   @override
//   void initState() {
//     initialise();
//     super.initState();
//     FirebaseMessaging.instance.getInitialMessage();
//     FirebaseMessaging.onMessage.listen((event) {
//       LocalNotificationService.display(event);
//     });

//     requestPermission();
//     loadFCM();
//     listenFCM();
//     // getToken();
//   }

//   void getToken() async {
//     await FirebaseMessaging.instance.getToken().then((token) => print(token));
//   }

//   void listenFCM() async {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification notification = message.notification!;
//       AndroidNotification? android = message.notification?.android;
//       if (android != null && !kIsWeb) {
//         flutterLocalNotificationsPlugin!.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               channel!.id,
//               channel!.name,
//               // channel.description,
//               // TODO add a proper drawable resource to android, for now using
//               //      one that already exists in example app.
//               icon: 'launch_background',
//             ),
//           ),
//         );
//       }
//     });
//   }

//   void requestPermission() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;

//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       // print("user granted permission");
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       // print("user granted provisional permission");
//     } else {
//       // print('user declained or has not accepted permission');
//     }
//   }

//   @override
//   void didChangeDependencies() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     _checkValue = prefs.containsKey('user');
//   }

//   Widget? pageCaller(int index) {
//     switch (index) {
//       case 0:
//         {
//           return HomeView();
//         }
//       case 1:
//       // {
//       //   return GoogleMapScreen();
//       // }

//       case 2:
//         {
//           return GoldRateScreen();
//         }
//     }
//     return null;
//   }

//   redirectLoginPage() {
//     if (_checkValue == true) {
//       Navigator.of(context).pushNamed(TransactionScreen.routeName);
//     } else {
//       Navigator.of(context).pushNamed(LoginScreen.routeName);
//     }
//   }

//   showCompanyTermsModel() {
//     showModalBottomSheet<void>(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//       // context and builder are
//       // required properties in this widget
//       context: context,
//       builder: (BuildContext context) {
//         // we set up a container inside which
//         // we create center column and display text

//         // Returning SizedBox instead of a Container
//         return Image(
//             image: AssetImage("assets/images/Scheme Notice Page 02.jpeg"));
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         final diff = DateTime.now().difference(timeBackPress);
//         final isExitWarning = diff >= Duration(seconds: 2);
//         timeBackPress = DateTime.now();
//         if (isExitWarning) {
//           final snackBar =
//               SnackBar(content: const Text("Press back again to exit"));

//           ScaffoldMessenger.of(context).showSnackBar(snackBar);
//           // final message = ;
//           // Fluttertoast.showToast(msg: message, fontSize: 18);
//           return false;
//         } else {
//           // Fluttertoast.cancel();
//           return true;
//         }
//       },
//       child: SafeArea(
//         child: Scaffold(
//           backgroundColor: Theme.of(context).primaryColor,
//           appBar: AppBar(
//             automaticallyImplyLeading: false,
//             elevation: 0,
//             actions: <Widget>[
//               Container(
//                 height: double.infinity,
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 10),
//                   child: GestureDetector(
//                       onTap: () {
//                         Navigator.push(context,
//                             MaterialPageRoute(builder: (context) => Terms()));
//                       },
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Row(
//                             children: [
//                               Icon(
//                                 Icons.info_outline,
//                                 size: 16,
//                               ),
//                               SizedBox(
//                                 width: 4,
//                               ),
//                               Text(
//                                 "Scheme",
//                                 style: TextStyle(
//                                     fontSize: 11,
//                                     fontWeight: FontWeight.bold,
//                                     color: Color.fromARGB(255, 237, 237, 237)),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               Text(
//                                 "Info",
//                                 style: TextStyle(
//                                     fontSize: 11,
//                                     fontWeight: FontWeight.bold,
//                                     color: Color.fromARGB(255, 237, 237, 237)),
//                               ),
//                               // Icon(
//                               //   Icons.info_outline,
//                               //   size: 16,
//                               // )
//                             ],
//                           ),
//                         ],
//                       )),
//                 ),
//               ),
//             ], // centerTitle: true,
//             backgroundColor: Theme.of(context).primaryColor,
//             centerTitle: true,
//             title: Container(
//               child: Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 8.0, bottom: 8),
//                   child: Image.asset(
//                     'assets/images/splashs.png',
//                     fit: BoxFit.contain,
//                     color: Colors.white,
//                     height: 50,
//                   ),
//                 ),
//               ),
//             ),
//             // centerTitle: true,
//           ),
//           body: pageCaller(_selectedIndex),
//           floatingActionButton: _selectedIndex != 1
//               ? SpeedDial(
//                   icon: Icons.contact_page,
//                   buttonSize: buttonSize,
//                   backgroundColor: Colors.grey[200],
//                   foregroundColor: Theme.of(context).primaryColor,
//                   children: [
//                       SpeedDialChild(
//                         child: const FaIcon(
//                           FontAwesomeIcons.phone,
//                           color: Colors.white,
//                           size: 15,
//                         ),
//                         // label: 'Call',
//                         backgroundColor: Color(0xFF3DDC84),
//                         onTap: () async {
//                           // _phoneNumberDialog(context);
//                           // await launch("tel://+91 7356916261");
//                           await launch("tel://+91 90723 63916");
//                         },
//                       ),
//                       SpeedDialChild(
//                         child: const FaIcon(
//                           FontAwesomeIcons.whatsapp,
//                           color: Colors.white,
//                           size: 26,
//                         ),
//                         // label: 'Whatsapp',
//                         backgroundColor: Color(0xFF25D366),
//                         onTap: () async {
//                           await launch(
//                               "https://wa.me/+91 9207728932?text=Hello...");
//                           // _whatsappDialog(context);
//                         },
//                       ),
//                     ])
//               : null,
//           floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
//           bottomNavigationBar: BottomAppBar(
//             //bottom navigation bar on scaffold
//             color: Colors.white,
//             shape: CircularNotchedRectangle(), //shape of notch
//             notchMargin:
//                 5, //notche margin between floating button and bottom appbar
//             child: Row(
//               //children inside bottom appbar
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 IconButton(
//                   icon: FaIcon(FontAwesomeIcons.home,
//                       size: 23,
//                       color: _selectedIndex == 0
//                           ? Theme.of(context).primaryColor
//                           : Colors.black54),
//                   onPressed: () {
//                     _onItemTapped(0);
//                   },
//                 ),
//                 SizedBox(
//                   width: 25,
//                 ),
//                 SpeedDial(
//                     icon: FontAwesomeIcons.mapMarkerAlt,
//                     buttonSize: buttonSize2,
//                     backgroundColor: Theme.of(context).primaryColor,
//                     children: [
//                       SpeedDialChild(
//                         label: "Kakkodi",
//                         child: const FaIcon(
//                           FontAwesomeIcons.mapLocationDot,
//                           color: Colors.white,
//                           size: 25,
//                         ),
//                         // label: 'Call',
//                         backgroundColor: Theme.of(context).primaryColor,
//                         onTap: () {
//                           Navigator.of(context).push(MaterialPageRoute(
//                               builder: (context) =>
//                                   GoogleMapScreen(place: "Kakkodi")));

//                           // GoogleMapScreen();
//                         },
//                       ),
//                       // SpeedDialChild(
//                       //   label: "Chittur",
//                       //   child: const FaIcon(
//                       //     FontAwesomeIcons.mapLocationDot,
//                       //     color: Colors.white,
//                       //     size: 25,
//                       //   ),
//                       //   // label: 'Whatsapp',
//                       //   backgroundColor: Theme.of(context).primaryColor,
//                       //   onTap: () {
//                       //     Navigator.of(context).push(MaterialPageRoute(
//                       //         builder: (context) =>
//                       //             GoogleMapScreen(place: "Chittur")));
//                       //   },
//                       // ),
//                       // SpeedDialChild(
//                       //   label: "Vadakkencherri",
//                       //   child: const FaIcon(
//                       //     FontAwesomeIcons.mapLocationDot,
//                       //     color: Colors.white,
//                       //     size: 25,
//                       //   ),
//                       //   // label: 'Whatsapp',
//                       //   backgroundColor: Theme.of(context).primaryColor,
//                       //   onTap: () {
//                       //     Navigator.of(context).push(MaterialPageRoute(
//                       //         builder: (context) =>
//                       //             GoogleMapScreen(place: "Vadakkencherri")));
//                       //   },
//                       // ),
//                     ]),
//                 // IconButton(
//                 //   icon: FaIcon(FontAwesomeIcons.mapMarkerAlt,
//                 //       size: 26,
//                 //       color: _selectedIndex == 1
//                 //           ? Theme.of(context).primaryColor
//                 //           : Colors.black54),
//                 //   onPressed: () {
//                 //     _onItemTapped(1);
//                 //   },
//                 // ),
//                 SizedBox(
//                   width: 25,
//                 ),
//                 IconButton(
//                   icon: FaIcon(FontAwesomeIcons.userCircle,
//                       size: 25,
//                       color: _selectedIndex == 2
//                           ? Theme.of(context).primaryColor
//                           : Colors.black54),
//                   onPressed: () {
//                     _onItemTapped(3);
//                     redirectLoginPage();
//                     // Navigator.of(context).pushNamed(LoginScreen.routeName);
//                   },
//                 ),
//                 //  SizedBox(width: 20,),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _phoneNumberDialog(BuildContext context) {
//     return showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: Container(
//             height: 350,
//             width: double.infinity,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Phone Number",
//                       style: TextStyle(fontWeight: FontWeight.w700),
//                     ),
//                     GestureDetector(
//                         onTap: () {
//                           Navigator.of(context).pop();
//                         },
//                         child: Icon(
//                           Icons.close,
//                           size: 18,
//                           color: Colors.red,
//                         )),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Divider(
//                   height: 1,
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   "Alathur",
//                   style: TextStyle(fontWeight: FontWeight.w400),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ElevatedButton.icon(
//                         icon: Icon(Icons.phone),
//                         onPressed: () async {
//                           await launch("tel://+91 92077 28932");
//                         },
//                         label: Text("+91 92077 28932")),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//   // whats app dialoge

//   Future<void> _whatsappDialog(BuildContext context) {
//     return showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: Container(
//             height: 350,
//             width: double.infinity,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Whatsapp Number",
//                       style: TextStyle(fontWeight: FontWeight.w700),
//                     ),
//                     GestureDetector(
//                         onTap: () {
//                           Navigator.of(context).pop();
//                         },
//                         child: Icon(
//                           Icons.close,
//                           size: 18,
//                           color: Colors.red,
//                         )),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Divider(
//                   height: 1,
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   "Alathur",
//                   style: TextStyle(fontWeight: FontWeight.w400),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ElevatedButton.icon(
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green),
//                         icon: Icon(FontAwesomeIcons.whatsapp),
//                         onPressed: () async {
//                           await launch(
//                               "https://wa.me/+91 9207728932?text=Hello...");
//                         },
//                         label: Text("+91 92077 28932")),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Divider(
//                   height: 2,
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   "Chittur",
//                   style: TextStyle(fontWeight: FontWeight.w400),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ElevatedButton.icon(
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green),
//                         icon: Icon(FontAwesomeIcons.whatsapp),
//                         onPressed: () async {
//                           await launch(
//                               "https://wa.me/+91 9207728933?text=Hello...");
//                         },
//                         label: Text("+91 92077 28933")),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Divider(
//                   height: 2,
//                 ),
//                 Text(
//                   "Vadakkencherri",
//                   style: TextStyle(fontWeight: FontWeight.w400),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ElevatedButton.icon(
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green),
//                         icon: Icon(FontAwesomeIcons.whatsapp),
//                         onPressed: () async {
//                           await launch(
//                               "https://wa.me/+91 9207728931?text=Hello...");
//                         },
//                         label: Text("+91 92077 28931")),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
