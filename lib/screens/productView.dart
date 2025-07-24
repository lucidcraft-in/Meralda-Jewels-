import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/product.dart';

class SwapableProductView extends StatefulWidget {
  SwapableProductView({Key? key, this.category}) : super(key: key);
  final String? category;

  @override
  State<SwapableProductView> createState() => _SwapableProductViewState();
}

class _SwapableProductViewState extends State<SwapableProductView> {
  late String categoryName;
  List productList = [];
  String branchName = "";

  Future<void> getCategory() async {
    setState(() {
      categoryName = widget.category ?? '';
    });

    var db = Product();
    db.initiliase();
    db.read(categoryName).then((value) {
      setState(() {
        productList = value ?? [];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCategory();
    fetchData();
  }

  Map<String, dynamic> aboutUsData = {};
  Future<void> fetchData() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('aboutUs').limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          aboutUsData = data;
        });

        print(aboutUsData["whatsapp"]);
      } else {}
    } catch (e) {}
  }

  void _launchWhatsApp(var product) async {
    String phone = "91${aboutUsData["phone"]}";

    // Compose a meaningful WhatsApp message with product details
    String message = '''
Hello, I am interested in the following product:

🛍 *Product Name*: ${product['productName']}
🆔 *Product Code*: ${product['productCode']}
💎 *Gram*: ${product['gram']}g
📂 *Category*: ${product['category']}


Please provide more details. Thank you!
''';

    // Encode message for URL
    String whatsappUrl =
        "https://wa.me/$phone/?text=${Uri.encodeComponent(message)}";

    try {
      final Uri url = Uri.parse(whatsappUrl);
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("Error launching WhatsApp: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // iconTheme: IconThemeData(color: Colors.black),
        // backgroundColor: Theme.of(context).primaryColor,
        title: Text(categoryName.toUpperCase()),
      ),
      body: productList.isEmpty
          ? const Center(child: Text("No Product Found"))
          : PageView.builder(
              itemCount: productList.length,
              itemBuilder: (context, index) {
                final product = productList[index];

                return Stack(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                product["photo"] ??
                                    'https://via.placeholder.com/150',
                                fit: BoxFit.contain,
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Product Details Section
                            Text(
                              product["productName"] ?? 'No Name',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),

                            buildDetailRow("Code", product["productCode"]),
                            buildDetailRow(
                                "Description", product["description"]),
                            buildDetailRow("Weight", product["gram"]),

                            const SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF1A3B32)),
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'Back',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 20,
                      bottom: 20,
                      child: FloatingActionButton(
                        backgroundColor: Color(0xFFb58763),
                        child: FaIcon(FontAwesomeIcons.whatsapp),
                        onPressed: () {
                          _launchWhatsApp(product);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  Widget buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
