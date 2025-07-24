// import 'dart:typed_data';

// import 'package:flutter/material.dart';

// import 'package:path_provider/path_provider.dart';
// import 'dart:io';

// class Privacypolicy extends StatefulWidget {
//   @override
//   _PrivacypolicyState createState() => _PrivacypolicyState();
// }

// class _PrivacypolicyState extends State<Privacypolicy> {
//   String? filePath;

//   @override
//   void initState() {
//     super.initState();
//     loadPdf();
//   }

//   Future<void> loadPdf() async {
//     final ByteData bytes = await DefaultAssetBundle.of(context)
//         .load('assets/pdf/privacy policy (1).pdf');
//     final String dir = (await getApplicationDocumentsDirectory()).path;
//     final String path = '$dir/refund_policy.pdf';
//     final File file = File(path);
//     await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
//     setState(() {
//       filePath = path;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).primaryColor,
//         title: const Text(
//           'Privacy Policy',
//         ),
//       ),
//       body: filePath != null
//           ? PDFView(
//               filePath: filePath!,
//             )
//           : Center(child: CircularProgressIndicator()),
//     );
//   }
// }
