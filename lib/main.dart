import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import './providers/payment.dart';
import 'package:provider/provider.dart';
import './providers/goldrate.dart';
import './providers/transaction.dart';
import './providers/user.dart';
import './providers/product.dart';
import './service/local_push_notification.dart';
import './screens/transaction_screen.dart';
import './screens/login_screen.dart';
import './screens/gold_rate_screen.dart';
import './screens/product_list_screen.dart';
import './screens/payment_screen.dart';
import './screens/googlemap_rmntkr_screen.dart';
import './screens/permission_message.dart';
import 'common/colo_extension.dart';
import 'firebase_options.dart';
import 'providers/banner.dart';
import 'providers/paymentBill.dart';
// import 'providers/paymentConfi.dart';
import 'providers/paymentConfi.dart';
import 'providers/phonePe_payment.dart';
import 'providers/staff.dart';
import 'screens/d.dart';
import 'screens/homeNavigation.dart';
import 'web/webHome.dart';
import 'zample.dart';

void main() async {
  TargetPlatform isIOS = TargetPlatform.iOS;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // LocalNotificationService.initialize();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // HttpOverrides.global = MyHttpOverrides();
  runApp(
    GoldJewelryApp(),
    // MyApp()
  );
}




// void main() {
//   runApp(MunawaraGoldApp());
// }

// class MunawaraGoldApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Meralda Jewels',
//       theme: ThemeData(
//         primaryColor: Color(0xFF003a34), // Dark green from your image
//         colorScheme: ColorScheme.light(
//           primary: Color(0xFF003a34), // Dark green
//           secondary: Color(0xFFFFD700), // Gold color
//         ),
//         fontFamily: 'Roboto',
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       initialRoute: '/',
//       routes: {
//         '/': (context) => HomePage(),
//         '/login': (context) => LoginPage(),
//       },
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }