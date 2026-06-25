import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:meralda_gold_user/common/colo_extension.dart';
import 'package:meralda_gold_user/web/newHomeScreen/widget/footerSection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meralda_gold_user/web/webPayScreen.dart';
import 'package:meralda_gold_user/web/webHome.dart';
import 'package:meralda_gold_user/web/newHomeScreen/newwebhome.dart';

class WebPoliciesScreen extends StatefulWidget {
  final String initialPolicy;

  const WebPoliciesScreen({Key? key, this.initialPolicy = 'Refund Policy'})
      : super(key: key);

  @override
  State<WebPoliciesScreen> createState() => _WebPoliciesScreenState();
}

class _WebPoliciesScreenState extends State<WebPoliciesScreen> {
  late String _selectedPolicy;

  final List<String> _policies = [
    'Refund Policy',
    'Buyback Policy',
    'Sales Return Policy',
    'Shipping Policy',
    'Cancellation Policy',
    'Privacy Policy',
    'Terms & Condition'
  ];

  var user;
  String _userName = "";

  @override
  void initState() {
    super.initState();
    _selectedPolicy = widget.initialPolicy;
    if (!_policies.contains(_selectedPolicy)) {
      _selectedPolicy = _policies.first;
    }
    loadUserLocally();
  }

  Future loadUserLocally() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.containsKey("user")) {
      var userData = pref.getString("user");
      if (userData != null) {
        setState(() {
          user = json.decode(userData);
          _userName = user['id'] ?? '';
        });
      }
    }
  }

  Widget _getPolicyContent(String policy) {
    switch (policy) {
      case 'Refund Policy':
        return _buildPolicyText(
            "At Meralda Jewels, we are committed to ensuring your complete satisfaction with every purchase. Our refund policy is designed to be fair, transparent, and straightforward.\n\n"
            "Eligibility for Refunds\n"
            "• Refunds are applicable for purchases made within 7 days from the original date of purchase.\n"
            "• Products must be returned in their original, unworn condition, along with all original packaging, certificates, the invoice, and an unboxing video.\n"
            "• Custom-made or personalized jewellery is not eligible for a refund unless the item is found to be defective.\n"
            "• Items purchased during special promotions or sale events may be subject to modified refund terms, as specified at the time of purchase.\n\n"
            "Refund Process\n"
            "• Refunds will be processed within 7-10 business days after the returned item has been received and inspected.\n"
            "• Refunds will be credited to the original mode of payment or issued via cheque in the name of the account holder.\n"
            "• Cash refunds will not be provided under any circumstances.\n"
            "• To comply with legal and regulatory requirements under applicable Indian laws.");
      case 'Buyback Policy':
        return _buildPolicyText(
            "Meralda Jewels offers a transparent and customer-friendly buyback policy on all jewellery purchases. We believe in building long-term relationships with our customers and assure fair market value at all times.\n\n"
            "Buyback Eligibility\n"
            "• All gold, silver, and diamond jewellery purchased from Meralda Jewels is eligible for buyback.\n"
            "• The buyback value will be determined based on the prevailing market rate on the date of the transaction.\n"
            "• A valid original purchase invoice is mandatory for all buyback transactions.\n"
            "• The jewellery must be in wearable condition. Damaged or heavily altered pieces will be assessed separately.\n\n"
            "Buyback Value Calculation\n"
            "• Gold buyback value is calculated based on the prevailing market rate, after deducting applicable making charges and GST.\n"
            "• Diamond buyback value is determined based on the quality, cut, and current market demand of the stone.\n"
            "• The original certificate issued at the time of purchase must be presented to avail of buyback benefits.\n"
            "• Hallmarked jewellery is eligible for preferential buyback rates compared to non-hallmarked jewellery.");
      case 'Sales Return Policy':
        return _buildPolicyText(
            "We understand that your tastes and preferences may evolve over time. Our sales return policy is designed to ensure that you can always find the perfect piece that reflects your style and sentiment.\n\n"
            "Sales Return Conditions\n"
            "• Sales return requests must be initiated within 15 days from the original date of purchase.\n"
            "• Items eligible for sales return must be returned in their original, unworn, and undamaged condition, along with the original invoice.\n"
            "• The sales return value will be calculated based on the weight and purity of the metal at the prevailing market rate on the date of sales return.\n"
            "• Making charges from the original purchase are non-refundable; however, they may be adjusted against the value of the new purchase.\n"
            "• If the new item is of higher value, the customer must pay the difference. If the new item is of lower value, the balance amount will be issued as store credit.\n\n"
            "Non - Returnable Items\n"
            "Custom-engraved or heavily personalized jewellery is not eligible for sales return. Jewellery purchased from other jewellers is not covered under our sales return policy.");
      case 'Shipping Policy':
        return _buildPolicyText(
            "We ensure that every order is carefully packaged and delivered safely to your doorstep. All jewellery shipments are fully insured and can be tracked throughout the delivery process.\n\n"
            "Delivery Timelines\n"
            "• Standard Delivery: Orders are typically delivered within 5-7 business days across India.\n"
            "• Express Delivery: Orders are delivered within 2-3 business days in select cities, with additional charges applicable.\n"
            "• Same-Day Delivery: Available in our branch locations and nearby areas for orders placed before 12 PM.\n\n"
            "Custom-made and made-to-order jewellery may require an additional 10-15 business days for processing prior to shipment.\n\n"
            "Shipping Charges\n"
            "• Free shipping is available on all orders above ₹50,000.\n"
            "• Orders below ₹50,000 will incur a shipping charge of ₹500, although charges may vary depending on the order specifications and delivery location.\n"
            "• Express delivery charges are calculated based on the package weight and destination to ensure safe and timely delivery.\n"
            "• International shipping is available on request; rates and timelines vary by country.\n\n"
            "Packaging & Security\n"
            "• All jewellery is shipped in tamper-proof, branded packaging with protective foam padding.\n"
            "• Each shipment includes an insurance certificate covering the full purchase value.\n"
            "• A tracking number is provided via SMS and email once the order is dispatched.");
      case 'Cancellation Policy':
        return _buildPolicyText(
            "We understand that circumstances may change. Our cancellation policy is designed to be flexible while ensuring fairness to both our customers and our craftsmen.\n\n"
            "Order Cancellation\n"
            "• Orders may be cancelled within 24 hours of placement for a full refund without any cancellation charges.\n"
            "• Once an order has been dispatched, it cannot be cancelled, and the Return and Refund Policy will apply instead.\n"
            "• Custom-made or personalized orders cannot be cancelled once the manufacturing process has begun.");
      case 'Privacy Policy':
        return _buildPolicyText(
            "At Meralda Jewels, protecting your personal information is a top priority. This Privacy Policy outlines how we collect, use, and safeguard your data when you interact with us through our store & website.\n\n"
            "Information We Collect\n"
            "• Personal Details: Name, address, date of birth, and government-issued ID for KYC compliance.\n"
            "• Contact Information: Phone number and email address for communication and OTP verification.\n"
            "• Financial Data: Bank account details and PAN card information for refund processing and scheme enrolment.\n"
            "• Usage Data: App usage patterns, device information, and browsing behaviour across our platforms.\n\n"
            "How We Use Your Information\n"
            "• To process orders, refunds, and scheme enrolments efficiently.\n"
            "• To verify your identity through OTP/SMS as required by regulations.\n"
            "• To send updates about your orders, scheme status, and promotional offers (with your consent).\n"
            "• To comply with legal and regulatory requirements under applicable Indian laws.\n\n"
            "Data Protection\n"
            "• All personal data is encrypted and stored on secure servers.\n"
            "• We do not sell, rent, or share your personal information with third parties without your explicit consent, except as required by law.\n"
            "• You have the right to request access to, correction of, or deletion of your personal data at any time.\n"
            "• Our platforms are regularly audited for security vulnerabilities to ensure your data remains safe.\n\n"
            "Cookies & Tracking\n"
            "• Our website uses cookies to enhance your browsing experience and provide personalized content.\n"
            "• You may disable cookies in your browser settings; however, this may affect certain features of our website.\n\n"
            "For any privacy-related concerns or to exercise your data rights, please contact us at info@meraldajewels.com or visit us at our our store.");
      case 'Terms & Condition':
        return _buildPolicyText("REFUND POLICY\n"
            "Refunds under the scheme, if any, shall be made only by cheque in the name of the account holder or through online transfer to the registered bank account, as specified in the Enrollment Form. No cash refunds shall be permitted.\n\n"
            "TERMS AND CONDITIONS\n"
            "The terms \"We\", \"Us\", \"Our\", and \"Company\" individually and collectively refer to Meralda Jewels, while the terms \"Visitor\" and \"User\" refer to the users.\n\n"
            "As a visitor to the Site or Customer, you are advised to read these Terms and Conditions and the Privacy Policy carefully. If you do not agree with the Terms and Conditions stated herein, we request you to discontinue the use of this App.\n\n"
            "By accessing the services provided through the Site, you agree to the collection and use of your data in the manner described in our Privacy Policy.\n\n"
            "GENERAL INFORMATION\n"
            "• Only individuals are eligible to enroll in the Plan. Enrollment is not permitted for entities such as companies, partnership firms, proprietorship concerns, trusts, Hindu Undivided Families (HUFs), or NRI customers. Minors may enroll only through their natural guardians.\n"
            "• Customers are required to provide copies of valid photo-identity and address-proof documents, such as Driving Licence, Voter ID, Passport, Ration Card, PAN Card, or any other government-issued document, along with bank account details at the time of enrollment.\n"
            "• Meralda Jewels, reserves the right to verify the identity of customers through SMS and/or OTP verification or by any other means at any time, including during enrollment and at the time of purchase or delivery of jewellery.\n"
            "• Meralda Jewels also reserves the right to verify the authenticity of the documents submitted by customers.\n"
            "• Payments can be made in cash at the Meralda Jewels store or through the Meralda Jewels App.\n"
            "• Accumulated advances can be redeemed only against gold jewellery, silver jewellery, or diamond jewellery.\n"
            "• All rights are reserved by Meralda Jewels.\n"
            "• Premature withdrawal from the Plan before completion of the tenure shall not entitle the customer to any benefits under the Plan.\n\n"
            "USE OF CONTENT\n"
            "All logos, brands, marks, headings, labels, names, signatures, numerals, shapes, or combinations thereof appearing on this Site, except where otherwise noted, are properties either owned by or licensed to the business and/or its associate entities featured on this Website.\n\n"
            "The use of these properties or any other content on this Site, except as permitted under these Terms and Conditions or within the Site content, is strictly prohibited.\n\n"
            "ACCEPTABLE APP USE\n"
            "Security Rules\n"
            "Visitors are prohibited from violating or attempting to violate the security of the App, including but not limited to:\n"
            "(1) Accessing data not intended for such users or logging into servers or accounts that they are not authorized to access.\n"
            "(2) Attempting to probe, scan, or test the vulnerability of a system or network, or attempting to breach security or authentication measures without proper authorization.\n"
            "(3) Attempting to interfere with services provided to any user, host, or network, including through the submission of viruses, Trojan horses, overloading, flooding, mail bombing, or crashing.\n"
            "(4) Sending unsolicited electronic communications, including promotional or advertising materials relating to products or services.\n"
            "Violations of system or network security may result in civil or criminal liability. The business and/or its associate entities reserve the right to investigate suspected violations and cooperate with law enforcement authorities in prosecuting users involved in such activities.\n\n"
            "INDEMNITY\n"
            "The User agrees to indemnify and hold harmless the Company, its officers, directors, employees, and agents from and against any claims, actions, demands, liabilities, losses, or damages arising out of or resulting from the User's use of the Meralda Jewels App or breach of these Terms and Conditions.\n\n"
            "LIABILITY\n"
            "The User agrees that neither the Company nor its group companies, directors, officers, or employees shall be liable for any direct, indirect, incidental, special, consequential, or exemplary damages arising from:\n"
            "(1) The use or inability to use the services;\n"
            "(2) The cost of procurement of substitute goods or services;\n"
            "(3) Unauthorized access to or alteration of user data or transmissions;\n"
            "(4) Transactions entered into through the service; or\n"
            "(5) Any other matter relating to the services.\n\n"
            "This includes, but is not limited to, damages for loss of profits, use, data, or other intangible losses, even if the Company has been advised of the possibility of such damages.\n\n"
            "The User further agrees that the Company shall not be liable for damages arising from interruption, suspension, or termination of services, whether justified, negligent, intentional, inadvertent, or otherwise.\n"
            "The User also agrees that the Company shall not be responsible for the statements or conduct of any third party using the services.\n"
            "In no event shall the Company's total liability exceed the amount, if any, paid by the User to the Company relating to the cause of action.\n\n"
            "DISCLAIMER OF CONSEQUENTIAL DAMAGES\n"
            "In no event shall the Company, or any parties, organizations, or entities associated with the corporate brand, be liable for any damages whatsoever, including without limitation incidental or consequential damages, loss of profits, damage to computer hardware, loss of data, information loss, or business interruption arising from:\n"
            "(1) The use or inability to use the App;\n"
            "(2) Reliance on App materials; or\n"
            "(3) Any interruption or malfunction of services.\n\n"
            "This applies whether the claim is based on warranty, contract, tort, or any other legal theory, and whether or not such entities were advised of the possibility of such damages.");
      default:
        return _buildPolicyText("Policy content not found.");
    }
  }

  Widget _buildPolicyText(String text) {
    final lines = text.split('\n');
    final children = <Widget>[];

    for (var line in lines) {
      if (line.trim().isEmpty) {
        children.add(const SizedBox(height: 10));
        continue;
      }

      bool isSubHeading = !line.startsWith('•') && 
                          !line.startsWith('(') && 
                          !line.endsWith('.') && 
                          !line.endsWith(':') &&
                          line.length < 60;

      if (line.toUpperCase() == line && line.length > 5 && !line.startsWith('•') && !line.startsWith('(')) {
        isSubHeading = true;
      }

      if (isSubHeading) {
        children.add(Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 5),
          child: Text(
            line,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ));
      } else {
        children.add(Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            line,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.grey[800],
            ),
          ),
        ));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _buildContent(String policy) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            )
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            policy,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: TColo.primaryColor1,
            ),
          ),
          SizedBox(height: 20),
          _getPolicyContent(policy),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 800;

    return Scaffold(
      drawer: _buildDrawer(context),
      backgroundColor: const Color(0xFFF5F5F0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAppBar(context, isMobile),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 60,
                vertical: 40,
              ),
              child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
            ),
            const FooterSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sidebar
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _policies.map((policy) {
                final isSelected = policy == _selectedPolicy;
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedPolicy = policy;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    margin: EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? TColo.primaryColor1.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      policy,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color:
                            isSelected ? TColo.primaryColor1 : Colors.black87,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(width: 40),
        // Main Content
        Expanded(
          flex: 3,
          child: _buildContent(_selectedPolicy),
        )
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Dropdown for mobile
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedPolicy,
              isExpanded: true,
              items: _policies.map((policy) {
                return DropdownMenuItem(
                  value: policy,
                  child: Text(policy),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedPolicy = val;
                  });
                }
              },
            ),
          ),
        ),
        SizedBox(height: 20),
        _buildContent(_selectedPolicy),
      ],
    );
  }

  void _navigateHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(builder: (context) => const Newwebhome()), 
      (route) => false,
    );
  }

  Widget _buildAppBar(BuildContext context, bool isMobile) {
    double logoHeight = !isMobile
        ? MediaQuery.of(context).size.height * .09
        : MediaQuery.of(context).size.height * .12;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: GestureDetector(
                  onTap: () {
                    _navigateHome(context);
                  },
                  child: Center(
                    child: Image.asset(
                      "assets/images/appbarLogo.png",
                      height: logoHeight,
                      width: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),

          if (!isMobile)
            Row(
              children: [
                _buildNavItem('Our Plans', () => _navigateHome(context)),
                _buildNavItem('How It Works', () => _navigateHome(context)),
                _buildNavItem('Our Showroom', () => _navigateHome(context)),
                _buildNavItem('Benefits', () => _navigateHome(context)),
                _buildNavItem('FAQ', () => _navigateHome(context)),
                _buildNavItem('Contact', () => _navigateHome(context)),
                const SizedBox(width: 20),
                const Icon(Icons.phone, size: 18, color: Color(0xFF1A4D3E)),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    html.window.open("tel:+919605789000", "_self");
                  },
                  child: const Text(
                    '91 9605789000',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1A4D3E),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
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
                      showLoginDialog(context);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: TColo.primaryColor1,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      user != null ? "Dashboard" : 'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Color(0xFF1A4D3E)),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF1A4D3E),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 40),
        children: [
          const ListTile(
            title: Text(
              'MERALDA',
              style: TextStyle(
                color: Color(0xFF1A4D3E),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const Divider(),
          _buildDrawerItem('Our Plans', () => _navigateHome(context)),
          _buildDrawerItem('How It Works', () => _navigateHome(context)),
          _buildDrawerItem('Benefits', () => _navigateHome(context)),
          _buildDrawerItem('FAQ', () => _navigateHome(context)),
          _buildDrawerItem('Contact', () => _navigateHome(context)),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF1A4D3E),
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
