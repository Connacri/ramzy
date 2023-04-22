import 'package:firebase_messaging/firebase_messaging.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
            primarySwatch: Colors.blue,
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
