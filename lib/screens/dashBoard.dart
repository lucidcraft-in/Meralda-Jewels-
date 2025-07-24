import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Providers/goldrate.dart';
import '../providers/banner.dart';
import '../providers/category.dart';
import '../providers/product.dart';
import 'categoryScreen.dart';
import 'makePayment.dart';
import 'profile.dart';
import 'transaction_screen.dart';
import 'uploadPaymentImage/sendPaymentRecipt.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final List<String> items = List.generate(10, (index) => 'Item $index');
  List image = [];
  var categoryDb = Category();
  var categoryList = [];
  Future loadCategoary() async {
    categoryDb.initiliase();
    categoryDb.getCategorywithImg().then((value) {
      setState(() {
        categoryList = value;
      });
    });
    categoryDb.getScheme().then((value) {
      setState(() {
        scheme = value;
      });
    });
  }

  List scheme = [];
  Goldrate? db;
  List goldrateList = [];
  double pavanrate = 0;
  String golddate = "";
  String goldTime = "";
  initialise() {
    db = Goldrate();
    db?.initiliase();
    db?.read().then((value) => {
          setState(() {
            goldrateList = value!;
            pavanrate = goldrateList[0]["pavan"];
            goldTime = goldrateList[0]["updateTime"];
            golddate = goldrateList[0]["updateDate"];
          }),
          print(goldrateList),
        });
    // getProduct();
  }

  getSlider() {
    Provider.of<BannerProvider>(context, listen: false)
        .getSlide("Banner")
        .then((value) {
      // print("============");
      // print(value);
      setState(() {
        imgList = value;
      });
    });
  }

  getProduct() async {
    Provider.of<Product>(context, listen: false).getProduct().then((val) {
      setState(() {
        image = val;
      });
    });
  }

  bool _checkValue = false;
  checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _checkValue = prefs.containsKey('user');
    // print(_checkValue);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // loadCategoary();
    // getSlider();
    checkLogin();
    initialise();
  }

  @override
  Widget build(BuildContext context) {
    final Ksize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title:
            Image(width: 100, image: AssetImage("assets/images/app_icon.png")),
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundColor: Color.fromARGB(255, 248, 223, 244),
              child: Image(image: AssetImage("assets/images/face1.png")),
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Stack(
              //   children: [
              //     // Parent Container with a background image
              //     Container(
              //       width: double.infinity,
              //       child: Positioned(
              //         right: 0, // Align to the right
              //         top: 0, // Align to the top
              //         bottom:
              //             0, // Align to the bottom to make it vertically centered
              //         child: Container(
              //           width: double.infinity, // Adjust the width as needed
              //           height:
              //               100, // Adjust the height to match the parent container's height
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(15),
              //             color: Color(0xFFF5F1F1),
              //             image: DecorationImage(
              //               image: AssetImage(
              //                   "assets/icons/statrs.png"), // Replace with your image path
              //               fit: BoxFit
              //                   .contain, // Make the image cover the container area
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),

              //     // Content container
              //     Container(
              //       width: double.infinity,
              //       height: 100, // Match the height of the parent container
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(15),
              //       ),
              //       child: Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 20),
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text("Gold Rate | 22K"),
              //             Row(
              //               children: [
              //                 Text(
              //                   pavanrate.toStringAsFixed(2),
              //                   style: TextStyle(
              //                       fontWeight: FontWeight.bold,
              //                       fontSize: 17,
              //                       color: Color.fromARGB(255, 152, 38, 30)),
              //                 ),
              //                 Text(" (8 gram)"),
              //               ],
              //             ),
              //             Text(
              //               "Updated at ${goldTime} on ${golddate}",
              //               style: TextStyle(
              //                   fontSize: 12,
              //                   fontWeight: FontWeight.w500,
              //                   color: Color.fromARGB(255, 142, 139, 139)),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              Container(
                height: MediaQuery.of(context).size.height * .11,
                child: Stack(
                  children: [
                    // Parent Container with a background image
                    Positioned.fill(
                      // Ensures the child covers the entire Stack
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xFFF5F1F1),
                          image: DecorationImage(
                            image: AssetImage(
                                "assets/icons/statrs.png"), // Your image path
                            fit: BoxFit.contain, // Adjust image to container
                          ),
                        ),
                      ),
                    ),

                    // Content container
                    Positioned(
                      // Make sure it also fills the parent Stack
                      child: Container(
                        height: MediaQuery.of(context).size.height * .11,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors
                              .transparent, // Transparent to show the background image
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
                                    pavanrate.toStringAsFixed(2),
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
              SizedBox(height: 10),
              Text(
                "Manage Your Money",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color.fromARGB(255, 53, 10, 10)),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TransactionScreen()));
                },
                child: Container(
                  height: 80,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 110, 21, 21),
                        Color.fromARGB(255, 210, 49, 49)
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      stops: [.3, 1],
                      tileMode: TileMode.repeated,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.restore_outlined,
                                size: 30,
                                color: Colors.white,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "See Transaction History",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * .2,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.arrow_forward,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(150),
                ),
                child: Stack(
                  children: [
                    // Parent Container with a background image
                    Container(
                      width: double.infinity,
                      height: 160, // Adjust the height as per your needs
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/images/Jewellery-blog-cover.jpg'), // Replace with your image path
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Overlay Container with gradient
                    Container(
                      width: double.infinity,
                      height:
                          160, // Adjust to match the parent container's height
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black
                                .withOpacity(0.7), // Black at the bottom
                            Colors.transparent, // Transparent at the top
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 70,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Now you Can Pay Online",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255)),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (_checkValue) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SendPaymentRec()));
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Your not login '),
                                                content: Text(
                                                    'Upload Payment Details after Login...!'),
                                                actions: [
                                                  ElevatedButton(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty.all<
                                                                Color>(Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('OK')),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Center(
                                          child: Text(
                                            "Pay Now",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Color.fromARGB(
                                                    255, 53, 10, 10)),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Explore New Collcetion",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color.fromARGB(255, 53, 10, 10)),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CategoryScreen()));
                },
                child: Container(
                  child: Stack(
                    children: [
                      // Parent Container with a background image
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(3.1416),
                        child: Container(
                          width: double.infinity,
                          height: 200, // Adjust the height as per your needs
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/ring image.jpg'), // Replace with your image path
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      // Overlay Container with gradient
                      Container(
                        width: double.infinity,
                        height:
                            200, // Adjust to match the parent container's height
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black
                                  .withOpacity(0.7), // Black at the bottom
                              Colors.transparent, // Transparent at the top
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 50,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Dainty and Romantic, Explore Ring Collcetion",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _currentIndex = 0;

  List imgList = [];

  List iconImg = [
    "1.png",
    "2.png",
    "3.png",
    "4.png",
    "5.png",
    "6.png",
    "7.png",
    "8.png",
    "9.png",
    "10.png",
  ];
  List galleryItems = [
    "https://kinclimg3.bluestone.com/f_jpg,c_scale,w_1024,q_80,b_rgb:f0f0f0/giproduct/BIDG0319R180_YAA18DIG6XXXXXXXX_ABCD00-PICS-00001-1024-66194.png",
    "https://cdn.caratlane.com/media/catalog/product/K/U/KU01498-2Y0000_1_lar.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR2_sWZyY68tCDbxnRbOQ-h8utd6GdEzEYJUQ&s"
  ];
}
