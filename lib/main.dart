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
import 'providers/banner.dart';
import 'providers/paymentBill.dart';
// import 'providers/paymentConfi.dart';
import 'providers/paymentConfi.dart';
import 'providers/phonePe_payment.dart';
import 'providers/staff.dart';
import 'screens/d.dart';
import 'screens/homeNavigation.dart';
import 'zample.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
// }

void main() async {
  TargetPlatform isIOS = TargetPlatform.iOS;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // LocalNotificationService.initialize();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // HttpOverrides.global = MyHttpOverrides();
  runApp(
    GoldJewelryApp(),
    // MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => User(),
        ),
        ChangeNotifierProvider(
          create: (_) => Transaction(),
        ),
        ChangeNotifierProvider(
          create: (_) => Goldrate(),
        ),
        ChangeNotifierProvider(
          create: (_) => Product(),
        ),
        ChangeNotifierProvider(
          create: (_) => Payment(),
        ),
        ChangeNotifierProvider(
          create: (_) => Staff(),
        ),
        ChangeNotifierProvider(
          create: (_) => BannerProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => phonePe_Payment(),
        ),
        ChangeNotifierProvider(
          create: (_) => PaymentBillProvider(),
        ),
        ChangeNotifierProvider(create: (_) => PaymentDetails())
      ],
      child: MaterialApp(
          title: 'Nambiyath Gold & Diamonds Gold',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            // primarySwatch: buildMaterialColor(Color(0xFFc0a950)),
            primaryColor: TColo.primaryColor1,
            fontFamily: "Poppins",
            colorScheme:
                ColorScheme.fromSwatch().copyWith(secondary: Color(0xFFfacc88)),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Colors.white, // Ensure this is set in the theme
            ),
            appBarTheme: AppBarTheme(
              color: Colors.blue, // Set the AppBar background color
              titleTextStyle: TextStyle(
                color: Colors.white, // Set the AppBar title text color
                fontSize: 20, // Customize the font size if needed
              ),
              iconTheme: IconThemeData(
                color: Colors.white, // Set the AppBar icon color
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    Colors.blue, // Set the text color for TextButton
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.blue, // Set the background color for ElevatedButton
                foregroundColor:
                    Colors.white, // Set the text color for ElevatedButton
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                foregroundColor:
                    Colors.blue, // Set the text color for OutlinedButton
                side: BorderSide(
                    color:
                        Colors.blue), // Set the border color for OutlinedButton
              ),
            ),
            dialogTheme: DialogTheme(
              backgroundColor:
                  Colors.white, // Set the background color of dialogs
              titleTextStyle: TextStyle(
                color: Colors.black, // Set the title text color in dialogs
                fontSize: 20, // Customize the title font size if needed
              ),
              contentTextStyle: TextStyle(
                color: Colors.black, // Set the content text color in dialogs
              ),
            ),
          ),
          debugShowCheckedModeBanner: false,
          // home: VideoScreen(),
          home: AnimatedSplashScreen(
            splash: Image.asset('assets/images/92777838281.png'),
            splashIconSize: 150,
            nextScreen: HomeNavigation(),
            splashTransition: SplashTransition.scaleTransition,
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            duration: 2500,
          ),
          routes: {
            TransactionScreen.routeName: (ctx) => TransactionScreen(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
            // GoogleMapScreen.routeName: (ctx) => GoogleMapScreen(),
            GoldRateScreen.routeName: (ctx) => GoldRateScreen(),
            PaymentScreen.routeName: (ctx) => PaymentScreen(),
            ProductListScreen.routeName: (ctx) => ProductListScreen(),
            // GooglemapRmntkrScreen.routeName: (ctx) => GooglemapRmntkrScreen(),
            PermissionMessage.routeName: (ctx) => PermissionMessage(),
          }),
    );
  }
}
