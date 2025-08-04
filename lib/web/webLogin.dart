import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meralda_gold_user/common/colo_extension.dart';
import 'package:meralda_gold_user/web/webHome.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/user.dart';
import 'webRegistration.dart';

class WebLoginpage extends StatefulWidget {
  @override
  _WebLoginpageState createState() => _WebLoginpageState();
}

class _WebLoginpageState extends State<WebLoginpage> {
  final _formKey = GlobalKey<FormState>();
  final _custIdController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      login();
      await Future.delayed(Duration(seconds: 1));

      setState(() {
        _isLoading = false;
      });

      // Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: isWeb ? 0 : 15),
              constraints: BoxConstraints(
                maxWidth: isWeb ? 450 : double.infinity,
              ),
              child: Stack(
                children: [
                  Card(
                    elevation: 20,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(isWeb ? 40 : 30),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Logo and Title
                            _buildHeader(),

                            // Email Field
                            _buildCustIdField(),
                            SizedBox(height: 20),

                            // Password Field
                            _buildPasswordField(),
                            SizedBox(height: 30),

                            // Login Button
                            _buildLoginButton(),
                            SizedBox(height: 20),

                            // Forgot Password
                            _buildForgotPassword(),
                            TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      UserRegistrationDialog(),
                                );
                              },
                              child: Text("New user? Register here"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
            width: 200,
            height: 200,
            child:
                Image(image: AssetImage("assets/images/merladlog_white.png"))),
      ],
    );
  }

  Widget _buildCustIdField() {
    return TextFormField(
      controller: _custIdController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Customer Id',
        hintText: 'Enter your customer id',
        prefixIcon: Icon(Icons.email_outlined, color: TColo.primaryColor1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: TColo.primaryColor1, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your customer id';
        }

        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        prefixIcon: Icon(Icons.lock_outline, color: TColo.primaryColor1),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Color(0xFF1B5E20),
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: TColo.primaryColor1, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: TColo.primaryColor1,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
        ),
        child: _isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'Login',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildForgotPassword() {
    return TextButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Forgot password feature coming soon!'),
            backgroundColor: Color(0xFF1B5E20),
          ),
        );
      },
      child: Text(
        'Forgot Password?',
        style: TextStyle(
          color: Color(0xFF1B5E20),
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _custIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  login() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final custId = _custIdController.text.trim();

    if (custId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Customer ID is required")),
      );
      return;
    }

    final userProvider = Provider.of<User>(context, listen: false);
    userProvider.loginUser(custId, _passwordController.text).then((val) {
      print("-------- ------- -----------");
      print(val);
      if (val.isNotEmpty) {
        sharedPreferences.setString("user", json.encode(val[0]));
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => WebHomeScreen(),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            "Invalied user Id or password..",
            style: TextStyle(color: Colors.white),
          )),
        );
      }
    });

    // if (result['success']) {
    //   final user = result['user'] as UserModel;
    //   // Navigate to Home or Dashboard
    //   Navigator.pop(context);
    // } else {
    //   Navigator.pop(context);
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //         content: Text(
    //       result['message'],
    //       style: TextStyle(color: Colors.white),
    //     )),
    //   );
    // }
  }
}
