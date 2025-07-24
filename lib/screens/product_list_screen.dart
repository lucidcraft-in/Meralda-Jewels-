import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../screens/productView.dart';
import '../providers/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductListScreen extends StatefulWidget {
  static const routeName = '/product-screen';
  ProductListScreen({Key? key, this.category}) : super(key: key);
  String? category;

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool isSelect = true;
  var selectItem = [];
  Stream? products;
  String branchName = "";
  Product? db;
  List userList = [];
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('product');

  Stream? _queryDb() {
    products = FirebaseFirestore.instance
        .collection('product')
        .where("category", isEqualTo: CategoryName)
        .snapshots()
        .map(
          (list) => list.docs.map((doc) => doc.data()),
        );
    return null;
  }

  String capitalizeAllWord(String value) {
    var result = value[0].toUpperCase();
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " ") {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
      }
    }
    return result;
  }

  String? CategoryName;
  initialise() {
    setState(() {
      CategoryName = widget.category;
    });

    db = Product();
    db!.initiliase();
    db!.read(CategoryName!).then((value) => {
          setState(() {
            userList = value != null ? value : userList;
          }),
          // print("---------------------"),
        });
  }

  @override
  void initState() {
    _queryDb();
    super.initState();
    initialise();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = size.width / 2;
    return Scaffold(
        appBar: AppBar(
          iconTheme:
              IconThemeData(color: const Color.fromARGB(255, 255, 255, 255)),
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text(
            'Products',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: userList.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: userList.length,
                  itemBuilder: (context, index) {
                    final product = userList[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SwapableProductView(
                                category: product['category']),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image Section
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                              child: Container(
                                height: 140,
                                width: double.infinity,
                                color: const Color(0xFFF5F5F5),
                                child: product['photo'] != ""
                                    ? Image.network(
                                        product['photo'],
                                        fit: BoxFit.cover,
                                      )
                                    : Center(
                                        child: Icon(
                                          FontAwesomeIcons.gem,
                                          size: 36,
                                          color: const Color(0xFFb58763)
                                              .withOpacity(0.7),
                                        ),
                                      ),
                              ),
                            ),

                            // Details Section
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['productName'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '#${product['productCode']}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    product['category'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFFb58763),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${product['gram']} gm',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ))
            : Center(
                child: Text("No data found it this category...."),
              ));
  }
}
