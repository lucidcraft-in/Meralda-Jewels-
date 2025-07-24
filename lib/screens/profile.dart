import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_pinput/new_pinput.dart';
import 'package:meralda_gold_user/screens/homeNavigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/login_form.dart';
import '../widgets/profileMoreInfo.dart';
import '../widgets/profileNameTag.dart';
import 'contactUs.dart';
import 'newHomeScreen.dart';
import 'pdfload.dart/aboutUs.dart';
import 'pdfload.dart/refundPolicy.dart';
import 'pdfload.dart/terms.dart';
import 'uploadPaymentImage/getAllSubmitRec.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool checkValue = false;
  bool _isLoad = false;
  var user;
  checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    checkValue = prefs.containsKey('user');

    print(checkValue);
    if (checkValue == true) {
      setState(() {
        var data = prefs.getString("user");
        print(data);
        setState(() {
          user = jsonDecode(data!);
        });

        print("------- --------");
        print(user);
      });
    }
  }

  Future<bool> _loadProfileData() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate a network call
    return true; // Simulate data load success
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return checkValue == false
        ? Scaffold(
            appBar: AppBar(
              // elevation: 2,
              // iconTheme: IconThemeData(color: Colors.black),
              // backgroundColor: Theme.of(context).primaryColor,
              centerTitle: true,
              title: Text(
                "Profile",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'latto',
                    fontWeight: FontWeight.bold),
              ),
            ),
            body: Container(
              height: MediaQuery.of(context).size.height * .8,
              width: double.infinity,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Color.fromARGB(255, 241, 230, 230),
                    backgroundImage: AssetImage("assets/images/face1.png"),
                  ),
                  LoginForm(),
                  // Container(
                  //   width: double.infinity,
                  //   height: MediaQuery.of(context).size.height * .05,
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(left: 30.0, right: 30),
                  //     child: ElevatedButton(
                  //         onPressed: _showMobileLoginSheet,
                  //         child: Text(
                  //           'Login with Mobile',
                  //           style: TextStyle(
                  //               color: Theme.of(context).primaryColor),
                  //         ),
                  //         style: ButtonStyle(
                  //             backgroundColor: MaterialStateProperty.all<Color>(
                  //               Color.fromARGB(255, 255, 255, 255),
                  //             ),
                  //             shape: MaterialStateProperty.all<
                  //                     RoundedRectangleBorder>(
                  //                 RoundedRectangleBorder(
                  //                     borderRadius: BorderRadius.circular(12.0),
                  //                     side: BorderSide(
                  //                         color:
                  //                             Theme.of(context).primaryColor))))

                  //         // style: ElevatedButton.styleFrom(
                  //         //     backgroundColor: Theme.of(context).primaryColor,
                  //         //     textStyle: TextStyle(
                  //         //         fontSize: 14, fontWeight: FontWeight.bold)),
                  //         ),
                  //   ),
                  // ),
                ],
              ),
            ),
          )
        : !isProfile
            ? pageLogin()
            : profileSec();
  }

  Widget pageLogin() {
    final sizeH = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 230, 230),
      appBar: AppBar(
        // iconTheme: IconThemeData(color: Colors.black),
        // backgroundColor: Theme.of(context).primaryColor,
        // elevation: 2,
        // centerTitle: true,
        title: Text(
          "Profile",
        ),
      ),
      body: Container(
        width: double.infinity,
        height: sizeH,
        child: Column(
          children: [
            Container(
              height: sizeH * .02,
            ),
            Container(
              height: sizeH * .25,
              width: double.infinity,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Container(
                  width: double.infinity,
                  // height: MediaQuery.of(context).size.height * .1,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/bg.jpeg"),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Color.fromARGB(255, 241, 230, 230),
                          backgroundImage:
                              AssetImage("assets/images/face1.png"),
                        ),
                        SizedBox(
                          height: sizeH * .01,
                        ),
                        Text(
                          "${user["name"]}".toUpperCase(),
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            textStyle: TextStyle(
                                color: Colors.black, letterSpacing: .5),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
            Container(
              color: Color.fromARGB(255, 255, 255, 255),
              height: sizeH * .5,
              child: Column(
                children: [
                  ProfileNameTag(
                    size: sizeH * .07,
                    icon: FontAwesomeIcons.user,
                    label: "Customer ID",
                    name: user["custId"],
                  ),
                  Container(
                    height: sizeH * .02,
                  ),
                  ProfileNameTag(
                    size: sizeH * .07,
                    icon: Icons.call,
                    label: "Phone Number",
                    name: user["phoneNo"],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => submittedRec(
                                    userId: user["id"],
                                  )));
                    },
                    child: ProfileMoreInfo(
                        label: "Payment ", icon: Icons.currency_exchange),
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (context) => Contact()));
                  //   },
                  //   child: ProfileMoreInfo(
                  //       label: "Contact Us", icon: Icons.contact_emergency),
                  // ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TermsAndCondition()),
                      );
                    },
                    child: ProfileMoreInfo(
                        label: "Terms and Condition", icon: Icons.menu_book),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RefundPolicyPage()),
                        );
                      },
                      child: ProfileMoreInfo(
                          label: "Refund Policy", icon: Icons.restore)),
                  // GestureDetector(
                  //     onTap: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => Privacypolicy()),
                  //       );
                  //     },
                  //     child: ProfileMoreInfo(
                  //         label: "Privacy Policy", icon: Icons.policy)),

                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AboutUsPage()),
                        );
                      },
                      child: ProfileMoreInfo(
                          label: "About Us", icon: Icons.policy)),

                  Divider(
                    thickness: 0,
                  ),
                  ListTile(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text('! Log out '),
                          // content: Text('Log out of Angadi'),
                          actions: <Widget>[
                            OutlinedButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                            ),
                            OutlinedButton(
                              child: Text('Log Out'),
                              onPressed: () {
                                logout();
                              },
                            )
                          ],
                        ),
                      );
                    },
                    leading: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..scale(-1.0, 1.0),
                      child: Icon(
                        FontAwesomeIcons.signOut,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      "Log Out",
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        textStyle:
                            TextStyle(color: Colors.black, letterSpacing: .5),
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isProfile = false;
  Widget profileSec() {
    final sizeH = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 230, 230),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            setState(() {
              isProfile = false;
            });
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        elevation: 2,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(
          "My Profile",
          style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'latto',
              fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: sizeH * .02,
            ),
            Container(
              height: sizeH * .2,
              width: double.infinity,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Color.fromARGB(255, 241, 230, 230),
                    backgroundImage: AssetImage("assets/images/face1.png"),
                  ),
                ],
              ),
            ),
            ProfileNameTag(
              size: sizeH * .09,
              icon: FontAwesomeIcons.user,
              label: "Name",
              name: user[0]["name"],
            ),
            Container(
              height: .2,
              width: double.infinity,
              color: Colors.grey,
            ),
            // ProfileNameTag(
            //     size: sizeH * .09,
            //     icon: Icons.mail_rounded,
            //     label: "Email",
            //     name: user["mail"]),
            Container(
              height: .2,
              width: double.infinity,
              color: Colors.grey,
            ),
            ProfileNameTag(
              size: sizeH * .09,
              icon: Icons.call,
              label: "Phone Number",
              name: user[0]["phoneNo"],
            ),
          ],
        ),
      ),
    );
  }

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

  void _showMobileLoginSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * .3,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter Mobile Number',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(10.0), // Set border radius here
                      border: Border.all(
                          color: Colors.grey), // Optionally, set border color
                    ),
                    child: TextFormField(
                      controller: _mobileController,
                      decoration: InputDecoration(
                        labelText: 'Mobile Number',
                        labelStyle: TextStyle(color: Colors.red),
                        border: InputBorder.none, // Remove default border
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.0), // Adjust padding
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => submittedRec(
                                    userId: user["id"],
                                  )));
                    },
                    child: ProfileMoreInfo(
                        label: "Payment ", icon: Icons.currency_exchange),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Contact()));
                    },
                    child: ProfileMoreInfo(
                        label: "Contact Us", icon: Icons.contact_emergency),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TermsAndCondition()),
                      );
                    },
                    child: ProfileMoreInfo(
                        label: "Terms and Condition", icon: Icons.menu_book),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RefundPolicyPage()),
                        );
                      },
                      child: ProfileMoreInfo(
                          label: "Refund Policy", icon: Icons.restore)),
                  // GestureDetector(
                  //     onTap: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => Privacypolicy()),
                  //       );
                  //     },
                  //     child: ProfileMoreInfo(
                  //         label: "Privacy Policy", icon: Icons.policy)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  final _otpController = TextEditingController();
  final _mobileController = TextEditingController();
  final pinController = TextEditingController();
  void _sendOtp(String userId) {
    // Navigator.pop(context); // Close the mobile number bottom sheet

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          setState(() {
            _secondsRemaining--;
          });

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * .3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Enter OTP',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    // Text('$_secondsRemaining seconds left'),
                    Text('OTP Valid 2 Minute'),
                    !_showResendButton
                        ? Pinput(
                            androidSmsAutofillMethod:
                                AndroidSmsAutofillMethod.none,
                            controller: pinController,
                          )
                        : ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Color.fromARGB(255, 60, 21, 28),
                                ),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ))),
                            onPressed: () {
                              // _verifyOtp();
                              setState(() {
                                _showResendButton = false;
                                _secondsRemaining = 60;
                                _startTimer();
                              });
                            },
                            child: Text('Resend OTP'),
                          ),
                    // TextFormField(
                    //   controller: _otpController,
                    //   decoration: InputDecoration(
                    //     labelText: 'OTP',
                    //   ),
                    //   keyboardType: TextInputType.number,
                    // ),

                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 60, 21, 28),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ))),
                      onPressed: () {
                        // if (pinController.text.length < 4) {
                        //   SnackBar(
                        //     content: Text('Mobile number not registered'),
                        //   );
                        // } else {
                        //   _verifyOtp(userId, double.parse(pinController.text));
                        // }
                        // _verifyOtp(userId, double.parse(pinController.text));
                      },
                      child: Text('Verify OTP'),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        // Check if the state is mounted before updating
        setState(() {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
          } else {
            _timer.cancel();
            _showResendButton = true;
          }
        });
      }
    });
  }

  bool _showResendButton = false;
  late Timer _timer;
  int _secondsRemaining = 60;

  @override
  void dispose() {
    // Dispose of the timers
    if (_timer.isActive) {
      _timer.cancel();
    }
    // Dispose of the controllers
    _otpController.dispose();
    _mobileController.dispose();
    pinController.dispose();
    super.dispose();
  }

  // _verifyOtp(String userId, double otpInput) async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   String? token = await FirebaseMessaging.instance.getToken();
  //   final otp = _otpController.text;
  //   var databaseOtp;
  //   List userList = [];
  //   // print(userId);
  //   // print(otpInput.toStringAsFixed(0));
  //   // print("--");
  //   Provider.of<User>(context, listen: false)
  //       .getUserOtpByUser(userId)
  //       .then((val) {
  //     setState(() {
  //       databaseOtp = val[0];
  //       // print(databaseOtp.toString());
  //       // print("----------");
  //       // print(val[1].toDate());
  //       // print(DateTime.now());
  //       Duration difference = DateTime.now().difference(val[1].toDate());
  //       print(difference);
  //       if (difference.inMinutes <= 2) {
  //         print('The time difference exceeds 2 minutes.');
  //         if (databaseOtp == otpInput) {
  //           Provider.of<User>(context, listen: false)
  //               .readById(userId)
  //               .then((value) {
  //             setState(() {
  //               userList = value!;
  //             });
  //             print(userList);

  //             sharedPreferences.setString("user", json.encode(userList[0]));

  //             Navigator.of(context).pushAndRemoveUntil(
  //                 // MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
  //                 MaterialPageRoute(
  //                     builder: (BuildContext context) => HomeScreen()),
  //                 (Route<dynamic> route) => false);
  //           });
  //           print("====");
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //               content: Text('OTP Verified'),
  //             ),
  //           );
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //               content: Text('Log In Success...'),
  //             ),
  //           );
  //         } else {
  //           print("----");
  //           Navigator.pop(context);
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //               content: Text('OTP Verification Failed'),
  //             ),
  //           );
  //         }
  //       } else {
  //         print('The time difference does not exceed 2 minutes.');
  //         Navigator.pop(context);
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text('OTP Verification Time exceeds 2 minutes'),
  //           ),
  //         );
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text('OTP Verification Failed'),
  //           ),
  //         );
  //       }
  //     });
  //   });
  //   // Simulate OTP verification delay
  //   // Future.delayed(Duration(seconds: 2), () {
  //   //   // Display success or failure message
  //   //   if (otp == '2222') {
  //   //     ScaffoldMessenger.of(context).showSnackBar(
  //   //       SnackBar(
  //   //         content: Text('OTP Verified'),
  //   //       ),
  //   //     );
  //   //   } else {
  //   //     ScaffoldMessenger.of(context).showSnackBar(
  //   //       SnackBar(
  //   //         content: Text('OTP Verification Failed'),
  //   //       ),
  //   //     );
  //   //   }
  //   // });

  //   // Close the OTP bottom sheet
  //   // Navigator.pop(context);

  //   // Start a timer
  //   // _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
  //   //   setState(() {
  //   //     if (_secondsRemaining > 0) {
  //   //       _secondsRemaining--;
  //   //     } else {
  //   //       _timer.cancel(); // Cancel the timer when the countdown reaches zero
  //   //       _showResendButton = true; // Show the "Resend OTP" button
  //   //     }
  //   //   });
  //   // });

  //   // Show Snackbar indicating OTP verification
  //   // ScaffoldMessenger.of(context).showSnackBar(
  //   //   SnackBar(
  //   //     content: Text('Verifying OTP...'),
  //   //   ),
  //   // );`
  // }

  // sendOtpToMobile(BuildContext context, String mobileNumber, int randomNumber,
  //     String userId) async {
  //   print("====");

  //   String url =
  //       'https://sapteleservices.in/SMS_API/sendsms.php?username=prakashjewellery&password=prakashpba610506&mobile=${mobileNumber.toString()}&message=${randomNumber}%20is%20the%20OTP%20for%20completing%20your%20login.%20Never%20share%20this%20OTP%20with%20anyone-Prakash%20Jewellery&sendername=PRAKJW&routetype=1&tid=1607100000000312467';
  //   print(url);
  //   var response = await http.get(Uri.parse(url));
  //   print(response.statusCode);
  //   if (response.statusCode == 200) {
  //     print("suc---");
  //     print(response.body);
  //     Provider.of<User>(context, listen: false)
  //         .assignOtp(randomNumber.toDouble(), userId)
  //         .then((value) {
  //       print("-- ------");
  //       print(value);
  //       if (value == true) {
  //         Navigator.pop(context); //
  //         // ScaffoldMessenger.of(context).showSnackBar(
  //         //   SnackBar(
  //         //     content: Text('Otp send....'),
  //         //   ),
  //         // );
  //         Future.delayed(Duration(seconds: 1), () {
  //           _sendOtp(userId);
  //         });
  //       }
  //     });
  //   } else {
  //     print("error---");
  //     print(response.body);
  //   }
  // }
}
