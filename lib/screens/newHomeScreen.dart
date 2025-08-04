import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:meralda_gold_user/widgets/circularBadges.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/banner.dart';
import '../providers/category.dart';
import '../providers/goldrate.dart';
import '../providers/product.dart';
import '../providers/transaction.dart';
import '../providers/user.dart';
import '../utils/setCategoryIcon.dart';
import 'categoryScreen.dart';
import 'pdfload.dart/aboutUs.dart';
import 'productView.dart';
import 'profile.dart';
import 'transaction_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Mock data for the UI
  Map<String, Map<String, double>> goldPrices = {
    "22k": {
      '1g': 0.00,
      '8g': 0.00,
    },
    "18k": {
      '1g': 0.00,
      '8g': 0.00,
    },
  };

  List categories = [];

  final List<Map<String, dynamic>> quickLinks = [
    {
      'name': 'View Transaction',
      'icon': Icons.receipt,
      'color': Color(0xFF81C784)
    },
  ];

  List stores = [];

  List products = [];

  List banner = [];
  getSlider() {
    Provider.of<BannerProvider>(context, listen: false)
        .getSlide('Banner')
        .then((onvalue) {
      setState(() {
        banner = onvalue;
      });
    });
    Provider.of<BannerProvider>(context, listen: false).fetchData().then((val) {
      setState(() {
        stores = val;
      });
    });
  }

  String _userName = "";
  getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.containsKey("user")) {
      String? userData = pref.getString("user");
      if (userData != null) {
        Map<String, dynamic> user = json.decode(userData);
        setState(() {
          _userName = user['name'] ?? '';
        });
      }
    } else {
      setState(() {
        _userName = '';
      });
    }
  }

  List offerImageUrls = [];
  getOfferData() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('offers');

    try {
      print("---------0--------");

      QuerySnapshot querySnapshot = await collectionReference.get();
      print(querySnapshot.docs.length);
      setState(() {
        offerImageUrls = querySnapshot.docs.map((doc) {
          return {
            "id": doc.id,
            "url": doc['name'],
          };
        }).toList();
      });
      print("---------1--------");
      print(offerImageUrls);
    } catch (e) {
      print('Error: $e');
    }
  }

  List goldrateList = [];
  String formattedDate = "";
  getGoldrate() {
    Provider.of<Goldrate>(context, listen: false).read().then((value) {
      if (value != null) {
        setState(() {
          goldrateList = value;
          print("---------");
          print(goldrateList);
          goldPrices = {
            "22k": {
              '1g': goldrateList[0]["gram"],
              '8g': goldrateList[0]["pavan"],
            },
            "18k": {
              '1g': goldrateList[0]["18gram"],
              '8g': goldrateList[0]["18gram"] * 8,
            },
          };
          Timestamp firestoreTimestamp = goldrateList[0]["timestamp"];
          DateTime dateTime = firestoreTimestamp.toDate();

// Format it
          formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
        });
      }
    });
  }

  void getCategory() {
    Provider.of<CategoryProvider>(context, listen: false)
        .getCategory()
        .then((onValue) {
      setState(() {
        // final List<Map<String, dynamic>> cleanedList =
        //     onValue.map<Map<String, dynamic>>((item) {
        //   return Map<String, dynamic>.from(item);
        // }).toList();

        // categories = convertCategories(cleanedList);
        categories = onValue;
        print("Converted categories: $categories");
      });
    });
  }

  getProduct() {
    Provider.of<Product>(context, listen: false).getProduct().then((onValue) {
      setState(() {
        products = onValue ?? [];
      });
      print(products[0]);
    }).catchError((error) {
      print('Error fetching products: $error');
      setState(() {
        products = []; // Fallback to empty list on error
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    getSlider();
    getOfferData();
    getGoldrate();
    getCategory();
    getProduct();
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

  void _launchWhatsApp() async {
    print(aboutUsData);
    String phone = "91${aboutUsData["phone"]}";
    print(phone);
    // Compose a meaningful WhatsApp message with product details
    String message = '''
Hello, I am interested in joining your gold scheme.
Kindly share the details. Thank you!
''';
    ;

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0), // Increase AppBar height
        child: AppBar(
          centerTitle: true,
          title: Container(
            height: 220,
            // Set specific height for image
            child: Image(
              image: AssetImage("assets/images/92777838281.png"),
              fit: BoxFit.contain,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.person_outline),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Stack(
            children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_userName != "")
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text("Welcome Back, ${_userName.toUpperCase()}"),
                      ),
                    // Section 1: Banner
                    _buildBannerSection(),

                    // Section 2: Gold Price Section
                    _buildGoldPriceSection(goldPrices),

                    // Section 3: User Balance
                    // _buildUserBalanceSection(userBalance),

                    // Section 4: Product Categories
                    _buildCategoriesSection(categories),

                    // if (offerImageUrls.isNotEmpty)
                    //   OfferFlyerWidget(
                    //     imageUrl: offerImageUrls[0]["url"],
                    //     heroTag: 'main_offer',
                    //     onTap: () =>
                    //         _onOfferTapped(offerImageUrls[0], 'main_offer'),
                    //   ),

                    // Multiple smaller offer flyers
                    if (offerImageUrls.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'More Offers',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                    // Grid of smaller offers
                    if (offerImageUrls.isNotEmpty)
                      SizedBox(
                        height: 200, // Adjust height as needed
                        child: PageView.builder(
                          itemCount: offerImageUrls.length,
                          controller: PageController(viewportFraction: 0.85),
                          padEnds: false,
                          itemBuilder: (context, index) {
                            final imageUrl = offerImageUrls[index]["url"];
                            print(imageUrl);
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: OfferFlyerWidget(
                                imageUrl: imageUrl,
                                margin: EdgeInsets.zero,
                                heroTag: 'offer_$index',
                                onTap: () =>
                                    _onOfferTapped(imageUrl, 'offer_$index'),
                              ),
                            );
                          },
                        ),
                      ),
                    SizedBox(height: 10),
                    // Section 5: Quick Links
                    _buildQuickLinksSection(quickLinks),

                    // Section 6: Store Locations
                    _buildStoreLocationsSection(stores),

                    // Section 7: Product Listing
                    _buildProductsSection(products),

                    // Extra padding at the bottom for floating button
                    SizedBox(height: 70),
                  ],
                ),
              ),
              Positioned(
                right: 30,
                bottom: 70,
                child: FloatingActionButton(
                  backgroundColor: Color(0xFF4CAF50),
                  child: FaIcon(FontAwesomeIcons.whatsapp),
                  onPressed: _launchWhatsApp,
                ),
              ),
            ],
          ),

          // WhatsApp floating button
          // Positioned(
          //   right: 20,
          //   bottom: 20,
          //   child:
          // ),
        ],
      ),
    );
  }

  Widget _buildBannerSection() {
    return banner.isNotEmpty
        ? Container(
            width: double.infinity,
            child: CarouselSlider.builder(
              itemCount: banner.length,
              itemBuilder: (context, index, realIndex) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: banner[index]['photo'],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: const Color.fromARGB(255, 250, 241, 241),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fadeInDuration: Duration(milliseconds: 300),
                  ),
                );
              },
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: false,
                viewportFraction: 1.0,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 2500),
              ),
            ),
          )
        : Container();
  }

  Widget _buildGoldPriceSection(Map<String, Map<String, double>> prices) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Today\'s Gold Rate',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 16),

          // 22K Row
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '22K',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D5A5A),
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Circularbadges(
                      gram: '1g',
                      amount: prices['22k']?['1g'] ?? 0.0,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Circularbadges(
                      gram: '8g',
                      amount: prices['22k']?['8g'] ?? 0.0,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 16),

          // 18K Row
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '18K',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D5A5A),
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Circularbadges(
                      gram: '1g',
                      amount: prices['18k']?['1g'] ?? 0.0,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Circularbadges(
                      gram: '8g',
                      amount: prices['18k']?['8g'] ?? 0.0,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 16),
          Center(
            child: Text(
              "Update Date : ${formattedDate}",
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection(List categories) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          categories.isNotEmpty
              ? Container(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          print(categories[index]);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SwapableProductView(
                                category: (categories[index]['name']),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 80,
                          margin: EdgeInsets.only(right: 16),
                          child: Column(
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    color: Color(0xFFEEF7EE),
                                    shape: BoxShape.circle,
                                    border:
                                        Border.all(color: Color(0xFFE0E0E0)),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            categories[index]["image"]))),
                              ),
                              SizedBox(height: 8),
                              Text(
                                categories[index]['name'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Center(
                  child: Text(
                    "Categories not yet...",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildQuickLinksSection(List<Map<String, dynamic>> links) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Access',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2.5,
            ),
            itemCount: links.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  if (_userName != "") {
                    // if (links[index]['name'] == "Pay Now") {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => SendPaymentRec()));
                    // } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TransactionScreen()));
                    // }
                  } else {
                    final snackBar = SnackBar(
                        content:
                            const Text("Your not loggin...! Please Login"));

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: links[index]['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          links[index]['icon'],
                          color: links[index]['color'],
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          links[index]['name'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStoreLocationsSection(List stores) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Stores',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          stores.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: stores.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AboutUsPage()),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 12),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Color(0xFFEEF7EE),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.store,
                                color: Color(0xFFb58763),
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    stores[index]['jewelleryName'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    stores[index]['address'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color(0xFFEEF7EE),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.shop,
                                    color: Color(0xFFFFB74D),
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    "addrres not yet...",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildProductsSection(List products) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Products',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CategoryScreen()));
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: Color(0xFFb58763),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          products.isNotEmpty
              ? GridView.builder(
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
                  itemCount: products.length > 4 ? 4 : products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
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
                )
              : Center(
                  child: Text(
                    "Products not yet...",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  void _onOfferTapped(String imageUrl, String heroTag) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OfferDetailPage(
          imageUrl: imageUrl,
          heroTag: heroTag,
        ),
      ),
    );
  }
}

class OfferFlyerWidget extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final bool showShadow;
  final String? heroTag;

  const OfferFlyerWidget({
    Key? key,
    required this.imageUrl,
    this.onTap,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.borderRadius,
    this.showShadow = true,
    this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final defaultWidth = screenWidth * 0.9; // 90% of screen width
    final defaultHeight = defaultWidth * 1.4; // Maintain flyer aspect ratio

    Widget flyerImage = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width ?? defaultWidth,
      height: height ?? defaultHeight,
      fit: BoxFit.cover,
      placeholder: (context, url) => _buildLoadingPlaceholder(),
      errorWidget: (context, url, error) => _buildErrorWidget(),
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 100),
    );

    // Wrap with Hero if heroTag is provided
    if (heroTag != null) {
      flyerImage = Hero(
        tag: heroTag!,
        child: flyerImage,
      );
    }

    return Container(
      margin: margin ?? const EdgeInsets.all(16.0),
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(16.0),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(16.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: borderRadius ?? BorderRadius.circular(16.0),
            child: flyerImage,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: borderRadius ?? BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading offer...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: borderRadius ?? BorderRadius.circular(16.0),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load offer',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap to retry',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class OfferDetailPage extends StatelessWidget {
  final String imageUrl;
  final String heroTag;

  const OfferDetailPage({
    Key? key,
    required this.imageUrl,
    required this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.share),
        //     onPressed: () => _shareOffer(),
        //   ),
        //   IconButton(
        //     icon: const Icon(Icons.download),
        //     onPressed: () => _downloadOffer(),
        //   ),
        // ],
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: Hero(
          tag: heroTag,
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 3.0,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              placeholder: (context, url) => const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              errorWidget: (context, url, error) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Failed to load offer',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
