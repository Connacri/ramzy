import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';
import 'package:ramzy/f_wallet/home.dart';
import 'package:ramzy/f_wallet/payment.dart';
import 'package:ramzy/f_wallet/qr_scanner.dart';
import 'package:ramzy/f_wallet/usersList.dart';
import 'package:ramzy/food2/MyListLotties.dart';

import 'package:ramzy/food2/paymentPage.dart';

// class UserClass {
//   final String id;
//   final String name;
//   int coins; // Ajoutez un champ pour les pièces (coins)
//
//   UserClass({required this.id, required this.name, required this.coins});
// }

class Transaction {
  final String receiverUserId;
  final String senderUserId;
  final Timestamp timestamp;
  final int amount;

  Transaction(
      {required this.receiverUserId,
      required this.senderUserId,
      required this.timestamp,
      required this.amount});
}

class Gaine {
  final double coins;

  Gaine({required this.coins});
}

class UserDataProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic> _currentUserData = {};
  Map<String, dynamic> get currentUserData => _currentUserData;

  Future<Map<String, dynamic>> fetchCurrentUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final String currentUserId = user.uid;
      final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await _firestore.collection('Users').doc(currentUserId).get();

      if (userSnapshot.exists) {
        _currentUserData = userSnapshot.data()!;
        notifyListeners();
        return _currentUserData;
      }
    }

    return {}; // Renvoie un objet vide si les données ne sont pas trouvées
  }

  Map<String, dynamic> _scannedUserData = {};
  Map<String, dynamic> get scannedUserData => _scannedUserData;

  Future<Map<String, dynamic>> fetchScannedUserData(String scannedUser) async {
    if (scannedUser != null) {
      final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await _firestore.collection('Users').doc(scannedUser).get();

      if (userSnapshot.exists) {
        _scannedUserData = userSnapshot.data()!;

        notifyListeners();
        return _scannedUserData; // Ajoutez cette ligne pour renvoyer les données
      }
    }

    return {}; // Ajoutez cette ligne pour renvoyer un objet vide si les données ne sont pas trouvées
  }

  Stream<List<Gaine>> get gainesStream {
    return FirebaseFirestore.instance
        .collection('gaines')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Gaine(coins: doc['coins']);
      }).toList();
    });
  }
}

class MyWalletApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserDataProvider()),
      ],
      child: MaterialApp(
        locale: const Locale('fr', 'FR'),
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          fontFamily: 'oswald',
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.lightBlue, backgroundColor: Colors.white),
        ),
        home: HomeScreen(),
      ),
    );
  }
}
