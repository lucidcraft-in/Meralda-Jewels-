import 'package:flutter/material.dart';

import '../../common/colo_extension.dart';
import '../profile.dart';
import '../transaction_screen.dart';
import 'homeScreen1.dart';

class Homescreen2 extends StatefulWidget {
  static const String routeName = '/home-screen';

  const Homescreen2({super.key});

  @override
  State<Homescreen2> createState() => _Homescreen2State();
}

class _Homescreen2State extends State<Homescreen2> {
  int _selectedIndex = 0;

  List<Widget> pages = [
    Homescreen1(),
    TransactionScreen(),
    // Ensure this page is correctly imported
    ProfileScreen(), // Ensure this page is correctly imported
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Add an AppBar for clarity
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: TColo.primaryColor2,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.swap_horiz), label: 'Transaction'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white, // Replace with a valid color
        unselectedItemColor: Colors.grey,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: pages[_selectedIndex],
    );
  }
}
