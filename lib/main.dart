import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ramzy/pages/booking.dart';
import 'package:ramzy/pages/booking2.dart';

import 'services/upload_random.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart' as splash;
import 'package:provider/provider.dart';
import 'Oauth/Ogoogle/googleSignInProvider.dart';
import 'Oauth/verifi_auth.dart';
import 'pages/ProvidersPublic.dart';
import 'pages/adminLoggedPage.dart';
import 'pages/unloggerPublicPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart'; // Importez cette ligne
import 'dart:async';
import 'dart:convert';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting(
      'fr_FR', null); // Initialisez la localisation française
  MobileAds.instance.initialize(); ////////////////////////////////ads
  await Firebase.initializeApp(
      //options: DefaultFirebaseOptions.currentPlatform,
      );

  // splash.FlutterNativeSplash.removeAfter(initialization);
  //WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //splash.FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge, //.immersiveSticky,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  runApp(MyApp());
}

//FlutterNativeSplash.remove();

Future initialization(BuildContext? context) async {
  Future.delayed(Duration(seconds: 5));
}

final navigatorKey = GlobalKey<NavigatorState>();

/// This is the main application widget.
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  static const String _title = 'Oran ';
  final GoogleUser2 = FirebaseAuth.instance.currentUser;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseInAppMessaging fiam = FirebaseInAppMessaging.instance;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ChangeNotifierProvider(
        create: (context) => googleSignInProvider(),
        //lazy: true,
        child: MaterialApp(
          locale: const Locale('fr', 'CA'),

          //scaffoldMessengerKey: Utils.messengerKey,
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: _title,
          themeMode: ThemeMode.dark,
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: "Oswald",
            colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.lightBlue, backgroundColor: Colors.white),
            appBarTheme: AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
              ),
            ),
          ),
          home: // upload_random(),
              //gantt_chart(),

              verifi_auth(),
        ));
  }
}
