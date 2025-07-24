import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/banner.dart';

class Terms extends StatefulWidget {
  const Terms({super.key});

  @override
  State<Terms> createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  final List<String> imageAssets = [
    "assets/images/Scheme Notice Page 02.jpeg",
    "assets/images/Thr_scm.png",
  ];
  int _currentPage = 0;
  final PageController controller = PageController();
  int _page = 0;
  Stream? slides;
  List slideList = [];
  _queryDb(String type) {
    Provider.of<BannerProvider>(context, listen: false)
        .getSlide(type)
        .then((value) {
      print(value);
      setState(() {
        value != null ? slideList = value : slideList;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _queryDb("T % C");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  FontAwesomeIcons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
            child: slideList.isNotEmpty
                ? Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * .8,
                          child: PageView.builder(
                            controller: controller,
                            onPageChanged: (int page) {
                              setState(() {
                                _currentPage = page;
                              });
                            },
                            // onPageChanged: (int page) {
                            //   print(page);
                            //   setState(() {
                            //     _page = page;
                            //   });
                            // },
                            itemCount: slideList.length,
                            itemBuilder: (context, index) {
                              return Image(
                                image: NetworkImage(
                                  slideList[index]['photo'],
                                ),
                                width: 100,
                                height: 200,
                                fit: BoxFit.contain,
                              );
                              // _buildStoryPage(slideList[index]);
                            },
                          ),
                        ),
                        buildPageIndicator(),
                      ],
                    ),
                    //  Image(
                    //     image: AssetImage("assets/images/Scheme Notice Page 02.jpeg")),
                  )
                : Container(
                    height: 200,
                    width: double.infinity,
                    child: Center(child: Text("No Data Found")),
                  ))
        // SafeArea(

        //     child: Container(
        //   width: double.infinity,
        //   height: double.infinity,
        //   child: Column(
        //     children: [
        //       Container(
        //         height: MediaQuery.of(context).size.height * .8,
        //         child: PageView.builder(
        //           onPageChanged: (int page) {
        //             print(page);
        //             setState(() {
        //               _page = page;
        //             });
        //           },
        //           itemCount: imageAssets.length,
        //           itemBuilder: (context, index) {
        //             return Image.asset(
        //               imageAssets[index],
        //             );
        //           },
        //         ),
        //       ),
        //       AnimatedContainer(
        //         duration: Duration(microseconds: 02),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             _page == 0 ? dotContainer() : flatContainer(),
        //             _page == 0 ? flatContainer() : dotContainer()
        //           ],
        //         ),
        //       )
        //     ],
        //   ),
        //   //  Image(
        //   //     image: AssetImage("assets/images/Scheme Notice Page 02.jpeg")),
        // )),
        );
  }

  _buildStoryPage(var data) {
    // print("-------------");
    // print(data);
    return Image(
      image: NetworkImage(
        data['photo'],
      ),
      width: 100,
      height: 200,
    );
  }

  Widget dotContainer() {
    return Container(
      width: 30,
      height: 10,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: Theme.of(context).primaryColor),
      child: Align(
        alignment: Alignment.topCenter,
      ),
    );
  }

  Widget flatContainer() {
    return Container(
      width: 30,
      height: 10,
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 172, 172, 172),
          borderRadius: BorderRadius.circular(10)),
      child: Align(
        alignment: Alignment.topCenter,
      ),
    );
  }

  Widget buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        slideList.length, // Replace with the number of pages in your PageView
        (index) => buildIndicator(index),
      ),
    );
  }

  Widget buildIndicator(int index) {
    return Container(
      width: 8.0,
      height: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index
            ? Theme.of(context).primaryColor
            : Colors.grey,
      ),
    );
  }
}
