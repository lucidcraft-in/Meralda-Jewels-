import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meralda_gold_user/screens/newHomeScreen.dart';
import '../common/colo_extension.dart';
import 'dashBoard.dart';
import 'transaction_screen.dart';
import 'uploadPaymentImage/paymentOpt.dart';

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({super.key});

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation>
    with TickerProviderStateMixin {
  int selectedNavBarIndex = 0;

  final List<Widget> screens = [
    HomePage(),
    PaymentOptionsPage(),
    TransactionScreen(),
    // ProfileScreen(),
  ];

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: IndexedStack(
  //       index: selectedNavBarIndex,
  //       children: screens,
  //     ),
  //     extendBody: true,
  //     bottomNavigationBar: BottomNavigationBar(
  //       backgroundColor: Colors.white,
  //       showSelectedLabels: true,
  //       selectedItemColor: TColo.primaryColor1,
  //       unselectedItemColor: const Color.fromARGB(255, 189, 189, 189),
  //       selectedLabelStyle: const TextStyle(
  //         fontSize: 12,
  //         fontFamily: 'Poppins',
  //         fontWeight: FontWeight.w600,
  //       ),
  //       unselectedLabelStyle: const TextStyle(
  //         fontSize: 12,
  //         fontFamily: 'Poppins',
  //         fontWeight: FontWeight.w400,
  //       ),
  //       currentIndex: selectedNavBarIndex,
  //       onTap: (index) {
  //         setState(() {
  //           selectedNavBarIndex = index;
  //         });
  //       },
  //       items: [
  //         BottomNavigationBarItem(
  //           icon: SvgPicture.asset(
  //             "assets/images/home.svg",
  //             color: const Color.fromARGB(255, 189, 189, 189),
  //           ),
  //           activeIcon: SvgPicture.asset(
  //             "assets/images/home.3 1.svg",
  //             color: TColo.primaryColor1,
  //           ),
  //           label: "Home",
  //         ),
  //         BottomNavigationBarItem(
  //           icon: const Icon(
  //             Icons.add_outlined,
  //             color: Color.fromARGB(255, 189, 189, 189),
  //           ),
  //           activeIcon: Icon(
  //             Icons.add,
  //             color: TColo.primaryColor1,
  //           ),
  //           label: "Payment",
  //         ),
  //         BottomNavigationBarItem(
  //           icon: const Icon(
  //             Icons.receipt_long_outlined,
  //             color: Color.fromARGB(255, 189, 189, 189),
  //           ),
  //           activeIcon: Icon(
  //             Icons.receipt_long,
  //             color: TColo.primaryColor1,
  //           ),
  //           label: "Transaction",
  //         ),
  //         // Uncomment below if ProfileScreen is ready
  //         // BottomNavigationBarItem(
  //         //   icon: const Icon(
  //         //     Icons.person_outline,
  //         //     color: Color.fromARGB(255, 189, 189, 189),
  //         //   ),
  //         //   activeIcon: Icon(
  //         //     Icons.person,
  //         //     color: TColo.primaryColor1,
  //         //   ),
  //         //   label: "Profile",
  //         // ),
  //       ],
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedNavBarIndex], // Only loads one screen at a time
      extendBody: true,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        showSelectedLabels: true,
        selectedItemColor: TColo.primaryColor1,
        unselectedItemColor: const Color.fromARGB(255, 189, 189, 189),
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
        currentIndex: selectedNavBarIndex,
        onTap: (index) {
          setState(() {
            selectedNavBarIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/images/home.svg",
              color: const Color.fromARGB(255, 189, 189, 189),
            ),
            activeIcon: SvgPicture.asset(
              "assets/images/home.3 1.svg",
              color: TColo.primaryColor1,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.add_outlined,
              color: Color.fromARGB(255, 189, 189, 189),
            ),
            activeIcon: Icon(
              Icons.add,
              color: TColo.primaryColor1,
            ),
            label: "Payment",
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.receipt_long_outlined,
              color: Color.fromARGB(255, 189, 189, 189),
            ),
            activeIcon: Icon(
              Icons.receipt_long,
              color: TColo.primaryColor1,
            ),
            label: "Transaction",
          ),
        ],
      ),
    );
  }
}
