import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

import '../../common/colo_extension.dart';

class BrochureScreen extends StatefulWidget {
  @override
  _BrochureScreenState createState() => _BrochureScreenState();
}

class _BrochureScreenState extends State<BrochureScreen> {
  String? pdfUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBrochure();
  }

  Future<void> fetchBrochure() async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('brochure')
          .limit(1)
          .get()
          .then((snapshot) => snapshot.docs.first);

      if (docSnapshot.exists && docSnapshot.data() != null) {
        setState(() {
          pdfUrl = docSnapshot['name']; // Fetch URL
          isLoading = false;
        });
      } else {
        setState(() {
          pdfUrl = null;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching brochure: $e");
      setState(() {
        pdfUrl = null;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: TColo.primaryColor1,
          title: const Text(
            'Company Brochure',
            style: TextStyle(color: Colors.white),
          )),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : pdfUrl != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.picture_as_pdf, size: 60, color: Colors.red),
                      SizedBox(height: 10),
                      Text('View Our Latest Brochure',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: TColo.primaryColor2),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PdfViewerScreen(pdfUrl: pdfUrl!),
                            ),
                          );
                        },
                        child: Text(
                          "Open Brochure",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                : Text('No brochure available'),
      ),
    );
  }
}

// PDF Viewer Screen
class PdfViewerScreen extends StatelessWidget {
  final String pdfUrl;

  const PdfViewerScreen({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: TColo.primaryColor1,
          title: Text(
            "PDF Viewer",
            style: TextStyle(color: Colors.white),
          )),
      body: const PDF().cachedFromUrl(
        pdfUrl,
        placeholder: (progress) =>
            Center(child: CircularProgressIndicator(value: progress / 100)),
        errorWidget: (error) => Center(
            child: Text("Failed to load PDF",
                style: TextStyle(color: Colors.red))),
      ),
    );
  }
}
