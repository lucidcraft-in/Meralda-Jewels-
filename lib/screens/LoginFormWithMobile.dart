import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../widgets/login_form.dart';

class MobileLogin extends StatefulWidget {
  const MobileLogin({super.key});

  @override
  State<MobileLogin> createState() => _MobileLoginState();
}

class _MobileLoginState extends State<MobileLogin> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * .05,
            child: Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30),
              child: ElevatedButton(
                  onPressed: () {},
                  // _showMobileLoginSheet,
                  child: Text(
                    'Login with Mobile',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 255, 255, 255),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor))))

                  // style: ElevatedButton.styleFrom(
                  //     backgroundColor: Theme.of(context).primaryColor,
                  //     textStyle: TextStyle(
                  //         fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
