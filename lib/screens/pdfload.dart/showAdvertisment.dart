import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/colo_extension.dart';

class ShowAdvertisements extends StatelessWidget {
  const ShowAdvertisements({super.key});

  // Function to open YouTube link in a web browser
  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Advertisements",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: TColo.primaryColor1,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('advertisements')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No advertisements available."));
          }

          var ads = snapshot.data!.docs;

          return ListView.builder(
            itemCount: ads.length,
            itemBuilder: (context, index) {
              var ad = ads[index];
              String youtubeLink = ad['youtubeLink'];

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading:
                      Icon(Icons.video_library, color: TColo.primaryColor1),
                  title: Text(
                    "Advertisement ${index + 1}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    youtubeLink,
                    style: TextStyle(color: TColo.primaryColor1),
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Icon(Icons.play_circle, color: TColo.primaryColor1),
                  onTap: () => _launchURL(youtubeLink),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
