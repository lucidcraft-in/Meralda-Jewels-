// import 'package:flutter/material.dart';
// import 'package:prakash_jewellery/screens/dashBoard.dart';
// import 'package:prakash_jewellery/screens/homeNavigation.dart';
// import 'package:video_player/video_player.dart';
// import 'dart:async';

// class VideoScreen extends StatefulWidget {
//   @override
//   _VideoScreenState createState() => _VideoScreenState();
// }

// class _VideoScreenState extends State<VideoScreen> {
//   late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;

//   @override
//   void initState() {
//     super.initState();
//     _controller =
//         VideoPlayerController.asset("assets/images/prakash_jewellery.mp4")
//           ..initialize().then((_) {
//             setState(() {});
//             _controller.play();
//           })
//           ..setLooping(false);
//     _controller.addListener(() {
//       if (_controller.value.position == _controller.value.duration) {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (context) => HomeNavigation()),
//         );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFededed),
//       body: Center(
//         child: _controller.value.isInitialized
//             ? AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 child: VideoPlayer(_controller),
//               )
//             : CircularProgressIndicator(),
//       ),
//     );
//   }
// }
