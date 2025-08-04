import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/banner.dart';
import '../../providers/category.dart';
import '../../providers/goldrate.dart';
import '../../providers/product.dart';
import '../../widgets/productItem.dart';
import '../productView.dart';
import '../product_list_screen.dart';

class Homescreen1 extends StatefulWidget {
  static const String routeName = '/home-screen1';
  const Homescreen1({super.key});

  @override
  State<Homescreen1> createState() => _Homescreen1State();
}

class _Homescreen1State extends State<Homescreen1> {
  bool _checkValue = false;

  Goldrate? db;
  List goldrateList = [];
  double pavanrate = 0;
  String golddate = "";
  String goldTime = "";
  String _userName = "";
  List categoryList = [];
  List productList = [];
  List banner = [];

  @override
  void initState() {
    super.initState();
    getUser();
    getCategory();
    getGoldrate();
    getProduct();
    getSlider();
  }

  getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (pref.containsKey("user")) {
      String? userData = pref.getString("user");

      if (userData != null) {
        Map<String, dynamic> user = json.decode(userData);
        setState(() {
          _userName = user['name'] ?? 'Maria';
        });
      }
    } else {
      setState(() {
        _userName = '';
      });
    }
  }

  getCategory() {
    Provider.of<CategoryProvider>(context, listen: false)
        .getCategory()
        .then((onValue) {
      setState(() {
        categoryList = onValue;
      });
    });
  }

  getGoldrate() {
    Provider.of<Goldrate>(context, listen: false).read().then((value) {
      print("-----------");
      print(value);
      setState(() {
        goldrateList = value!;
        pavanrate = goldrateList[0]['pavan'];
        goldTime = goldrateList[0]['updateTime'];
        golddate = goldrateList[0]['updateDate'];
      });
    });
  }

  getProduct() {
    Provider.of<Product>(context, listen: false).getProduct().then((onValue) {
      setState(() {
        productList = onValue ?? [];
      });
    }).catchError((error) {
      print('Error fetching products: $error');
      setState(() {
        productList = []; // Fallback to empty list on error
      });
    });
  }

  getSlider() {
    Provider.of<BannerProvider>(context, listen: false)
        .getSlide('Banner')
        .then((onvalue) {
      print(onvalue);
      setState(() {
        banner = onvalue;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFF1A3B32),
      appBar: AppBar(
        title: Text(
          'Nambiyath Gold & Daimonds',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.notifications_none),
          //   onPressed: () {},
          // ),
          IconButton(
            icon: Icon(Icons.person_outline),
            onPressed: () {},
          ),
        ],
      ),
      // appBar: AppBar(
      //   backgroundColor: TColo.primaryColor2,
      //   elevation: 0,
      //   title: Row(
      //     children: [
      //       SizedBox(width: 10),
      //       Text(_userName, style: TextStyle(color: Colors.white)),
      //     ],
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_userName != "") Text("Welcome Back, ${_userName}"),
              banner.isNotEmpty
                  ? Container(
                      height: 180,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFb58763), Color(0xFF81C784)],
                        ),
                      ),
                      child: CarouselSlider.builder(
                        itemCount: banner.length, // Number of banners
                        itemBuilder: (context, index, realIndex) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            // decoration: BoxDecoration(
                            //   image: DecorationImage(
                            //     image: NetworkImage(banner[index]['photo']),
                            //     fit: BoxFit.cover,
                            //   ),
                            // ),
                            child: Image(
                                image: NetworkImage(banner[index]['photo'])),
                          );
                        },
                        options: CarouselOptions(
                          height: 180, // Fixed height
                          autoPlay: true, // Auto-slide banners
                          enlargeCenterPage: true, // Zoom effect
                          viewportFraction: 0.9, // Adjust banner size
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 180,
                      child: Image.asset(
                        'assets/images/placeholder.jpg', // Placeholder image
                        fit: BoxFit.cover,
                      ),
                    ),
              // Container(
              //   margin: EdgeInsets.all(16),
              //   height: 180,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(16),
              //     gradient: LinearGradient(
              //       begin: Alignment.topLeft,
              //       end: Alignment.bottomRight,
              //       colors: [Color(0xFF9f0005), Color(0xFF81C784)],
              //     ),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.black12,
              //         blurRadius: 8,
              //         offset: Offset(0, 3),
              //       ),
              //     ],
              //   ),
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.circular(16),
              //     child: Stack(
              //       children: [
              //         Positioned(
              //           right: -30,
              //           bottom: -20,
              //           child: Opacity(
              //             opacity: 0.2,
              //             child: Icon(
              //               FontAwesomeIcons.gem,
              //               size: 150,
              //               color: Colors.white,
              //             ),
              //           ),
              //         ),
              //         Padding(
              //           padding: EdgeInsets.all(20),
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               Text(
              //                 'New Collection',
              //                 style: TextStyle(
              //                   color: Colors.white,
              //                   fontSize: 24,
              //                   fontWeight: FontWeight.bold,
              //                 ),
              //               ),
              //               SizedBox(height: 10),
              //               Text(
              //                 'Get 25% off on first purchase',
              //                 style: TextStyle(
              //                   color: Colors.white,
              //                   fontSize: 16,
              //                 ),
              //               ),
              //               SizedBox(height: 20),
              //               ElevatedButton(
              //                 onPressed: () {},
              //                 style: ElevatedButton.styleFrom(
              //                   backgroundColor: Colors.white,
              //                   foregroundColor: Color(0xFF9f0005),
              //                   padding: EdgeInsets.symmetric(
              //                       horizontal: 20, vertical: 12),
              //                   shape: RoundedRectangleBorder(
              //                     borderRadius: BorderRadius.circular(30),
              //                   ),
              //                 ),
              //                 child: Text(
              //                   'Shop Now',
              //                   style: TextStyle(fontWeight: FontWeight.bold),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Text(
                'Category',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              // Categories
              categoryList.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: categoryList.map((category) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductListScreen(
                                            category: category['name'],
                                          )));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 40,
                                    backgroundImage: category['image']
                                            .isNotEmpty
                                        ? NetworkImage(category[
                                            'image']) // ✅ Firestore Image URL
                                        : AssetImage(
                                                'assets/images/necklace.png')
                                            as ImageProvider,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    category['name'],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  : Center(
                      child: Text(
                        "No categories available",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

              SizedBox(height: 20),

              Text(
                'Exclusive offers for you',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  banner.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CarouselSlider.builder(
                            itemCount: banner.length, // Number of banners
                            itemBuilder: (context, index, realIndex) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: NetworkImage(banner[index]['photo']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                            options: CarouselOptions(
                              height: 180, // Fixed height
                              autoPlay: true, // Auto-slide banners
                              enlargeCenterPage: true, // Zoom effect
                              viewportFraction: 0.9, // Adjust banner size
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 180,
                          child: Image.asset(
                            'assets/images/placeholder.jpg', // Placeholder image
                            fit: BoxFit.cover,
                          ),
                        ),
                ],
              ),

              SizedBox(height: 20),
              // Top Picks
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Top pick for you',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  Text('See All', style: TextStyle(color: Colors.white)),
                ],
              ),
              productList.isNotEmpty
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: productList.length,
                              itemBuilder: (context, index) {
                                final product = productList[index];

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SwapableProductView(
                                          category: product['category'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: ProductItem(
                                    productName:
                                        product['productName'] ?? 'No Name',
                                    productCode:
                                        product['productCode'] ?? 'No Code',
                                    photo: product['photo'] ??
                                        'assets/images/default.jpg',
                                    category:
                                        product['category'] ?? 'Uncategorized',
                                    gram: product['gram'] ?? '0',
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(child: Text('No products available')),

              SizedBox(height: 20),

              Container(
                height: MediaQuery.of(context).size.height * .11,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xFFF5F1F1),
                          image: DecorationImage(
                            image: AssetImage("assets/icons/statrs.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      child: Container(
                        height: MediaQuery.of(context).size.height * .11,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.transparent,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Gold Rate | 22K"),
                              Row(
                                children: [
                                  Text(
                                    pavanrate.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Color.fromARGB(255, 152, 38, 30),
                                    ),
                                  ),
                                  Text(" (8 gram)"),
                                ],
                              ),
                              Text(
                                "Updated at ${goldTime} on ${golddate}",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 142, 139, 139),
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
            ],
          ),
        ),
      ),
    );
  }
}
