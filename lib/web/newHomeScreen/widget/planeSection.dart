import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../schemeDiologs/WishlistInfoDialog.dart';
import '../../schemeDiologs/aspireDialog.dart';
import '../../webHome.dart';
import '../../webPayScreen.dart';
import '../../webProfile.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Widget buildPlansSection(BuildContext context, bool isMobile) {
  final screenWidth = MediaQuery.of(context).size.width;
  final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
  final bool isDesktop = screenWidth >= 1024;

  // Adjust padding and font sizes based on screen size
  final horizontalPadding = isMobile
      ? 20.0
      : isTablet
          ? 60.0
          : 100.0;
  final verticalPadding = isMobile
      ? 60.0
      : isTablet
          ? 80.0
          : 100.0;
  final titleFontSize = isMobile
      ? 28.0
      : isTablet
          ? 28.0
          : 38.0;

  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: horizontalPadding,
      vertical: verticalPadding,
    ),
    color: const Color(0xFFFAFAFA),
    child: Column(
      children: [
        Text(
          'Choose Your Perfect Plan',
          style: TextStyle(
            fontFamily: "playfair",
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A4D3E),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Two exceptional ways to own your dream jewellery. Select the plan that matches your savings goals.',
          style: TextStyle(
            fontSize: isMobile ? 16 : 18,
            color: const Color(0xFF666666),
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 60),

        // Responsive layout
        if (isMobile)
          Column(
            children: [
              PlanCardWidget(
                title: 'Wishlist',
                subtitle: 'Turn Desires into Reality',
                description:
                    'With the WishList Jewellery Buying Plan, we love to turn your desires into reality. Now, you can open an account with a minimum amount of 2000. You will be qualified for a bonus of up to 100% of your initial instalment if you make fixed monthly payments for 11 months continuously.',
                features: [
                  'Get up to 100% of the first instalment as a bonus.',
                  'Easy Monthly Instalments',
                  // 'Up to 100% bonus',
                  // '11 continuous payments',
                  // 'No hidden charges',
                ],
                isMobile: isMobile,
                isPopular: true,
                cardColor: const Color(0xFFD4A574),
              ),
              const SizedBox(height: 30),
              PlanCardWidget(
                title: 'Aspire',
                subtitle: 'Gateway to Luxury',
                description:
                    'The Meralda Aspire Jewellery Buying Plan is a gateway to owning coveted pieces by paying fixed instalments starting from only ₹2000 for 11 months. Each payment reserves a portion of gold weight equivalent to the amount paid, and, at the time of redemption, you can get your jewellery equivalent to the accumulated weight without paying any making charges up to 16%.',
                features: [
                  'Get Advantage of Average Gold Rate',
                  'Easy Monthly Instalments',
                ],
                isMobile: isMobile,
              ),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: PlanCardWidget(
                  title: 'Wishlist',
                  subtitle: 'Turn Desires into Reality',
                  description:
                      'With the WishList Jewellery Buying Plan, we love to turn your desires into reality. Now, you can open an account with a minimum amount of 2000. You will be qualified for a bonus of up to 100% of your initial instalment if you make fixed monthly payments for 11 months continuously.',
                  features: [
                    'Get up to 100% of the first instalment as a bonus.',
                    'Easy Monthly Instalments',
                  ],
                  isMobile: isMobile,
                  isPopular: false,
                  cardColor: const Color(0xFFD4A574),
                ),
              ),
              SizedBox(width: isTablet ? 20 : 40),
              Expanded(
                child: PlanCardWidget(
                  title: 'Aspire',
                  subtitle: 'Gateway to Luxury',
                  description:
                      'The Meralda Aspire Jewellery Buying Plan is a gateway to owning coveted pieces by paying fixed instalments starting from only ₹2000 for 11 months. Each payment reserves a portion of gold weight equivalent to the amount paid, and, at the time of redemption, you can get your jewellery equivalent to the accumulated weight without paying any making charges up to 16%.',
                  features: [
                    'Get Advantage of Average Gold Rate',
                    'Easy Monthly Instalments',
                  ],
                  isMobile: isMobile,
                  isPopular: true,
                ),
              ),
            ],
          ),
      ],
    ),
  );
}

class PlanCardWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final String description;
  final List<String> features;
  final bool isMobile;
  final bool isPopular;
  final Color? cardColor;

  const PlanCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.features,
    required this.isMobile,
    this.isPopular = false,
    this.cardColor,
  });

  @override
  State<PlanCardWidget> createState() => _PlanCardWidgetState();
}

class _PlanCardWidgetState extends State<PlanCardWidget> {
  bool _hovering = false;
  bool _hoverPrimary = false;
  bool _hoverSecondary = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserLocally();
  }

  var user;
  Future loadUserLocally() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (pref.containsKey("user")) {
      var userData = pref.getString("user");

      if (userData != null) {
        user = json.decode(userData);

        // setState(() {
        //   _userName = user['id'] ?? '';
        // });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.cardColor ?? Colors.white;
    final textColor = widget.cardColor != null
        ? const Color(0xFF1A4D3E)
        : const Color(0xFF333333);
    print(widget.title);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: _hovering ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.all(widget.isMobile ? 24 : 40),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontFamily: "playfair",
                      fontSize: widget.isMobile ? 22 : 30,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      fontSize: widget.isMobile ? 12 : 14,
                      color: widget.cardColor != null
                          ? const Color(0xFF1A4D3E)
                          : const Color(0xFFD4A574),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.description,
                    style: TextStyle(
                      fontSize: widget.isMobile ? 12 : 13,
                      color: textColor.withOpacity(0.8),
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ✅ Features List
                  ...widget.features.map(
                    (feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: widget.cardColor != null
                                ? Color.fromARGB(63, 27, 87, 31)
                                : Color.fromARGB(61, 212, 166, 116),
                            radius: 9,
                            child: Center(
                              child: Icon(
                                Icons.check,
                                color: widget.cardColor != null
                                    ? const Color(0xFF1A4D3E)
                                    : Color.fromARGB(244, 212, 166, 116),
                                size: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              feature,
                              style: TextStyle(
                                fontSize: widget.isMobile ? 12 : 13,
                                color: textColor,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // 🔘 Primary Button ("Enroll Now")
                  MouseRegion(
                    onEnter: (_) => setState(() => _hoverPrimary = true),
                    onExit: (_) => setState(() => _hoverPrimary = false),
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        print(user);
                        if (user != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WebPayAmountScreen(
                                custName: user['id'],
                                userid: user["id"],
                                user: user,
                              ),
                            ),
                          );
                        } else {
                          // showLeadDialog(context, widget.title);
                          showEnrollDialog(context, widget.title);
                          // showLoginDialog(context);
                        }
                        // showWishlistInfoDialog(context, "", "");
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: _hoverPrimary
                              ? const Color(0xFF246956) // lighter on hover
                              : const Color(0xFF1A4D3E),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Enroll Now',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin:
                                  EdgeInsets.only(left: _hoverPrimary ? 8 : 4),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: _hoverPrimary ? 22 : 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ⚪ Secondary Button ("Learn More")
                  MouseRegion(
                    onEnter: (_) => setState(() => _hoverSecondary = true),
                    onExit: (_) => setState(() => _hoverSecondary = false),
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        widget.title != "Aspire"
                            ? showWishlistInfoDialog(context, "", "")
                            : showAspireInfoDialog(
                                // context, widget.username, widget.user);
                                context,
                                "",
                                {});
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: _hoverSecondary
                              ? Color.fromARGB(255, 244, 245,
                                  239) // slightly dark background on hover
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          // border: Border.all(
                          //   color: const Color(0xFF1A4D3E),
                          //   width: 1.4,
                          // ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Learn More',
                              style: TextStyle(
                                fontSize: 13,
                                color: widget.title == "Aspire"
                                    ? const Color(0xFFD4A574)
                                    : const Color(0xFF1A4D3E),
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: EdgeInsets.only(
                                  left: _hoverSecondary ? 8 : 4),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                color: widget.title == "Aspire"
                                    ? const Color(0xFFD4A574)
                                    : const Color(0xFF1A4D3E),
                                size: _hoverSecondary ? 22 : 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 🔖 Popular Tag
            if (widget.isPopular)
              Positioned(
                top: -12,
                right: 30,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A4D3E),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Popular Choice',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void showEnrollDialog(BuildContext context, String schemeName) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final cityCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final msgCtrl = TextEditingController();
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return AlertDialog(
    //       title: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           const Text("Are you interested...!"),
    //           const SizedBox(height: 4),
    //           Text(
    //             schemeName,
    //             style: const TextStyle(fontSize: 14, color: Colors.grey),
    //           ),
    //         ],
    //       ),
    //       content: SizedBox(
    //         width: 420, // ✅ FIXED WIDTH FOR WEB
    //         child: SingleChildScrollView(
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               TextField(
    //                   controller: nameCtrl,
    //                   decoration: InputDecoration(labelText: "Name")),
    //               TextField(
    //                   controller: phoneCtrl,
    //                   decoration: InputDecoration(labelText: "Phone")),
    //               TextField(
    //                   controller: msgCtrl,
    //                   decoration: InputDecoration(labelText: "Message")),
    //               TextField(
    //                   controller: emailCtrl,
    //                   decoration: InputDecoration(labelText: "Email")),
    //               TextField(
    //                   controller: cityCtrl,
    //                   decoration: InputDecoration(labelText: "City")),
    //             ],
    //           ),
    //         ),
    //       ),
    //       actions: [
    //         TextButton(
    //           onPressed: () => Navigator.pop(context),
    //           child: const Text("Cancel"),
    //         ),
    //         ElevatedButton(
    //           child: const Text("Submit"),
    //           onPressed: () async {
    //             if (nameCtrl.text.isEmpty || phoneCtrl.text.isEmpty) {
    //               ScaffoldMessenger.of(context).showSnackBar(
    //                 const SnackBar(
    //                     content: Text("Please enter name and phone")),
    //               );
    //               return;
    //             }

    //             await sendLeadToApi(
    //               schemeName,
    //               nameCtrl.text,
    //               phoneCtrl.text,
    //               msgCtrl.text,
    //               emailCtrl.text,
    //               cityCtrl.text,
    //             );

    //             Navigator.pop(context);

    //             showSuccessSnackBar(context); // ✅ custom snackbar
    //           },
    //         ),
    //       ],
    //     );
    //   },
    // );
    showDialog(
      context: context,
      builder: (context) {
        bool isSubmitting = false; // ✅ loader state

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Are you interested...!"),
                  const SizedBox(height: 4),
                  Text(
                    schemeName,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              content: SizedBox(
                width: 420,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                          controller: nameCtrl,
                          decoration: const InputDecoration(labelText: "Name")),
                      TextField(
                          controller: phoneCtrl,
                          decoration:
                              const InputDecoration(labelText: "Phone")),
                      TextField(
                          controller: msgCtrl,
                          decoration:
                              const InputDecoration(labelText: "Message")),
                      TextField(
                          controller: emailCtrl,
                          decoration:
                              const InputDecoration(labelText: "Email")),
                      TextField(
                          controller: cityCtrl,
                          decoration: const InputDecoration(labelText: "City")),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting ? null : () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          if (nameCtrl.text.isEmpty || phoneCtrl.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Please enter name and phone")),
                            );
                            return;
                          }

                          setState(
                              () => isSubmitting = true); // 🔄 start loader

                          await sendLeadToApi(
                            schemeName,
                            nameCtrl.text,
                            phoneCtrl.text,
                            msgCtrl.text,
                            emailCtrl.text,
                            cityCtrl.text,
                          );

                          Navigator.pop(context);

                          showSuccessSnackBar(context);
                        },
                  child: isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text("Submit"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showSuccessSnackBar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final snackbarWidth = 420.0;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SizedBox(
          width: snackbarWidth,
          child: Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 22,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Request Submitted Successfully',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Our staff will contact you soon.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          left: screenWidth - snackbarWidth - 24,
          bottom: 16,
          right: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> sendLeadToApi(
    String schemeName,
    String name,
    String phone,
    String message,
    String email,
    String city,
  ) async {
    final url = Uri.parse(
      "https://us-central1-meralda-uae.cloudfunctions.net/api/add-lead",
    );

    final now = DateTime.now();

    final body = {
      "slno": DateTime.now().millisecondsSinceEpoch,
      "date": "${now.year}-${now.month}-${now.day}",
      "time": "${now.hour}:${now.minute}",
      "name": name,
      "phone": phone,
      "message": "Interested in: $schemeName",
      "email": email,
      "city": city,
    };

    await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
  }
}
