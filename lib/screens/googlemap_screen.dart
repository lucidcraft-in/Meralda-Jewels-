// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';

// class GoogleMapScreen extends StatefulWidget {
//   GoogleMapScreen({required this.place});
//   late String place;
//   @override
//   _GoogleMapScreenState createState() => _GoogleMapScreenState();
// }

// class _GoogleMapScreenState extends State<GoogleMapScreen> {
//   Completer<GoogleMapController> _controller = Completer();
//   static const LatLng _center =
//       const LatLng(10.64848518371582, 76.53709411621094);
//   void _onMapCreated(GoogleMapController controller) {
//     _controller.complete(controller);
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // print("===========");
//     // print(widget.place);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text('Maps Sample App'),
//       //   backgroundColor: Colors.green[700],
//       // ),
//       body: GoogleMap(
//         onMapCreated: _onMapCreated,
//         mapType: MapType.normal,
//         initialCameraPosition: CameraPosition(
//           target: _center,
//           zoom: 15.0,
//         ),
//       ),

//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           if (widget.place == "Kakkodi") {
//             MapUtils.openMap(10.64848518371582, 76.53709411621094);
//           }
//         },
//         backgroundColor: Theme.of(context).primaryColor,
//         child: const Icon(Icons.navigation),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
//     );
//   }
// }

// class MapUtils {
//   MapUtils._();

//   static Future<void> openMap(double latitude, double longitude) async {
//     String googleUrl =
//         'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
//     // if (await canLaunch(googleUrl)) {
//     await launch(googleUrl);
//     // } else {
//     //   throw 'Could not open the map.';
//     // }
//   }
// }
