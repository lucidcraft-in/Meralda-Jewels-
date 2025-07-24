import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '../providers/banner.dart';

class SliderPage extends StatefulWidget {
  const SliderPage({Key? key}) : super(key: key);

  @override
  _SliderPageState createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  int _currentPage = 0;
  final PageController controller = PageController();
  Stream? slides;
  List slideList = [];
  _queryDb(String type) {
    Provider.of<BannerProvider>(context, listen: false)
        .getSlide(type)
        .then((value) {
      // print(value);
      setState(() {
        value != null ? slideList = value : slideList;
      });
    });
    // FirebaseFirestore.instance
    //     .collection('Banner')
    //     .where("imageType", isEqualTo: type)
    //     .snapshots()
    //     .map(
    //       (list) => list.docs.map((doc) => doc.data()),
    //     );
  }

  @override
  void initState() {
    _queryDb("Banner");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            PageView.builder(
                controller: controller,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemCount: slideList.length,
                itemBuilder: (context, int index) {
                  return _buildStoryPage(slideList[index]);
                }),
            Positioned(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildPageIndicator(),
                    ))),
          ],
        ));
  }

  // _buildStoryPage(Map data) {
  //   return ClipRRect(
  //                     borderRadius: BorderRadius.circular(15),
  //                     child: Image.network(
  //                        data['photo'],
  //                      fit: BoxFit.cover,
  //                     ));
  // }

  _buildStoryPage(var data) {
    // print("-------------");
    // print(data);
    return data != null
        ? Container(
            child: CachedNetworkImage(
            imageUrl: data['photo'],
            placeholder: (context, url) => Image.asset(
              'assets/images/loadimage.gif',
              fit: BoxFit.cover,
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ))
        : Container(
            child: Image.asset(
              'assets/images/loadimage.gif',
              fit: BoxFit.cover,
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
      width: 20.0,
      height: 4.0,
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: _currentPage == index
            ? Theme.of(context).primaryColor
            : Colors.grey,
      ),
    );
  }
}
