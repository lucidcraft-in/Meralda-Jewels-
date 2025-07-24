import 'package:flutter/material.dart';

import '../model/custom_field.dart';
import '../widgets/contactUs.dart';

class Contact extends StatelessWidget {
  const Contact({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Contact Us',
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 100),
          ContactUs(
            cardColor: Colors.red,
            textColor: const Color.fromARGB(255, 0, 0, 0),
            logo: AssetImage(
              'assets/images/WhatsApp_Image_2024-06-29_at_11.09.35_AM-removebg-preview.png',
            ),

            email: 'prakashjewellerypba@gmail.com',
            dividerColor: const Color.fromARGB(255, 0, 0, 0),
            companyName: 'PRAKASH JEWELLERY',

            companyColor: const Color.fromARGB(255, 0, 0, 0),
            dividerThickness: 3,

            phoneNumber: '9020941941',
            website: 'https://www.prakashjewellery.in',
            // githubUserName: 'omerkdrr',
            // linkedinURL: 'linkedin.com/in/omerkdrr/',

            taglineColor: const Color.fromARGB(255, 0, 0, 0),
            // twitterHandle: 'ARGE KULÜBÜ',
            // instagram: 'nu.arge',
            customSocials: [
              CustomSocialField(
                icon: const Icon(Icons.mark_chat_unread_rounded,
                    color: Colors.white),
                name: "Whatsapp",
                url:
                    "https://wa.me/9020941941?text=${Uri.encodeComponent(message)}",
              ),
            ],
          ),
        ],
      ),
    );
  }

  final String message = 'Hello,';
}
