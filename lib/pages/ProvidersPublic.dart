import 'dart:ui';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../f_wallet/main.dart' as wallet;
import 'package:ramzy/food/MyTabCategories.dart';
import 'package:ramzy/food/home_screen_food.dart';
import 'package:ramzy/food/webScrab.dart';
import 'package:ramzy/food2/MesAchatsPage.dart';
import 'package:ramzy/food2/main.dart';
import 'package:ramzy/food2/paymentPage.dart';
import '../pages/homeList_StateFull.dart';
import '../pages/homeList_StateFull_staggered.dart';
import '../messenger/ChatListScreen.dart';
import '../pages/classes.dart';
import '../services/ad_mob_service.dart';
import 'homeList.dart';
import 'insta.dart';
import '../services/upload_random.dart';
import 'Profile.dart';

class Collection1Data {
  final List<DocumentSnapshot> documents;

  Collection1Data(this.documents);

  Query<Object?> fromListOfDocumentSnapshots(List<DocumentSnapshot> documents) {
    return FirebaseFirestore.instance.collection('Products').where(
        FieldPath.documentId,
        whereIn: documents.map((d) => d.id).toList());
  }
}

class Collection3Data {
  final List<DocumentSnapshot> documents;

  Collection3Data(this.documents);

  Query<Object?> fromListOfDocumentSnapshots(List<DocumentSnapshot> documents) {
    return FirebaseFirestore.instance.collection('Caroussel').where(
        FieldPath.documentId,
        whereIn: documents.map((d) => d.id).toList());
  }
}

class CollectionCarousselInsta {
  final List<DocumentSnapshot> documents;

  CollectionCarousselInsta(this.documents);

  Query<Object?> fromListOfDocumentSnapshots(List<DocumentSnapshot> documents) {
    return FirebaseFirestore.instance.collection('CarousselInsta').where(
        FieldPath.documentId,
        whereIn: documents.map((d) => d.id).toList());
  }
}

class Collection2Data {
  final List<DocumentSnapshot> documents;

  Collection2Data(this.documents);

  Future<UserClass?> getUserById(String userID) async {
    DocumentReference<Map<String, dynamic>> userRef =
        FirebaseFirestore.instance.collection('Users').doc(userID);
    DocumentSnapshot<Map<String, dynamic>> userDoc = await userRef.get();
    if (userDoc.exists) {
      return UserClass.fromJson(userDoc.data()!);
    } else {
      return null;
    }
  }

  Stream<List<UserClass>> get users {
    final firestore = FirebaseFirestore.instance;
    final usersRef = firestore.collection('Users');
    return usersRef.snapshots().map((snapshot) {
      return snapshot.docs.map((document) {
        return UserClass.fromJson(document.data());
        // return UserClass.fromSnapshot(document);
      }).toList();
    });
  }
}

class CollectionAlertData {
  final List<DocumentSnapshot> documents;

  CollectionAlertData(this.documents);

  Query<Object?> fromListOfDocumentSnapshots(List<DocumentSnapshot> documents) {
    return FirebaseFirestore.instance.collection('Alert').where(
        FieldPath.documentId,
        whereIn: documents.map((d) => d.id).toList());
  }
}

class CollectionAlertArabcData {
  final List<DocumentSnapshot> documents;

  CollectionAlertArabcData(this.documents);

  Query<Object?> fromListOfDocumentSnapshots(List<DocumentSnapshot> documents) {
    return FirebaseFirestore.instance.collection('AlertArabic').where(
        FieldPath.documentId,
        whereIn: documents.map((d) => d.id).toList());
  }
}

class CollectionPubArea {
  final List<DocumentSnapshot> documents;

  CollectionPubArea(this.documents);

  Query<Object?> fromListOfDocumentSnapshots(List<DocumentSnapshot> documents) {
    return FirebaseFirestore.instance.collection('PubArea').where(
        FieldPath.documentId,
        whereIn: documents.map((d) => d.id).toList());
  }
}

class MyApp extends StatelessWidget {
  MyApp({Key? key, required this.userDoc}) : super(key: key);
  var userDoc;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<Collection1Data>(
          create: (_) => FirebaseFirestore.instance
              .collection("Products")
              .snapshots()
              .map((querySnapshot) => Collection1Data(querySnapshot.docs)),
          initialData: Collection1Data([]),
        ),
        StreamProvider<Collection2Data>(
          create: (_) => FirebaseFirestore.instance
              .collection("Users")
              .snapshots()
              .map((querySnapshot) => Collection2Data(querySnapshot.docs)),
          initialData: Collection2Data([]),
        ),
        StreamProvider<Collection3Data>(
          create: (_) => FirebaseFirestore.instance
              .collection("Caroussel")
              .snapshots()
              .map((querySnapshot) => Collection3Data(querySnapshot.docs)),
          initialData: Collection3Data([]),
        ),
        StreamProvider<CollectionAlertData>(
          create: (_) => FirebaseFirestore.instance
              .collection("Alert")
              .snapshots()
              .map((querySnapshot) => CollectionAlertData(querySnapshot.docs)),
          initialData: CollectionAlertData([]),
        ),
        StreamProvider<CollectionAlertArabcData>(
          create: (_) => FirebaseFirestore.instance
              .collection("AlertArabic")
              .snapshots()
              .map((querySnapshot) =>
                  CollectionAlertArabcData(querySnapshot.docs)),
          initialData: CollectionAlertArabcData([]),
        ),
        StreamProvider<CollectionPubArea>(
          create: (_) => FirebaseFirestore.instance
              .collection("PubArea")
              .snapshots()
              .map((querySnapshot) => CollectionPubArea(querySnapshot.docs)),
          initialData: CollectionPubArea([]),
        ),
        StreamProvider<CollectionCarousselInsta>(
          create: (_) => FirebaseFirestore.instance
              .collection("CarousselInsta")
              .snapshots()
              .map((querySnapshot) =>
                  CollectionCarousselInsta(querySnapshot.docs)),
          initialData: CollectionCarousselInsta([]),
        ),
      ],
      child: bottomNavigation(
        userDoc: userDoc,
      ),
    );
  }
}

class bottomNavigation extends StatefulWidget {
  bottomNavigation({Key? key, required this.userDoc}) : super(key: key);
  final userDoc;

  @override
  _bottomNavigationState createState() {
    return _bottomNavigationState();
  }
}

class _bottomNavigationState extends State<bottomNavigation> {
  BannerAd? _banner;
  User? currentUser = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    super.initState();
    _createBannerAd();

    // FirebaseFirestore.instance
    //     .collection('Users')
    //     .doc(currentUser!.uid)
    //     .snapshots()
    //     .listen((DocumentSnapshot snapshot) {
    //   if (snapshot.exists) {
    //     var monAttribut = snapshot['coins'];
    //     bool dialogShown = snapshot['dialogShown'];
    //     if (!dialogShown) {
    //       // Affichez une boîte de dialogue lorsque l'attribut change
    //       showDialog(
    //         context: context,
    //         barrierDismissible: false,
    //         builder: (BuildContext context) {
    //           return WillPopScope(
    //             onWillPop: () async {
    //               // Empêche la fermeture en utilisant le bouton de retour arrière
    //               return false;
    //             },
    //             child: CongratulationsDialog(
    //               animationAsset: 'assets/lotties/animation_lmqwfkzg.json',
    //               coins: monAttribut,
    //             ),
    //           );
    //         },
    //       );
    //     }
    //   }
    // });
  }

  void _createBannerAd() {
    _banner = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitId!,
      listener: AdMobService.bannerListener,
      request: const AdRequest(),
    )..load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final uusers = Provider.of<Collection2Data>(context);

    return Scaffold(
      bottomNavigationBar: // _banner == null
          // ?
          NavigationBar(
        height: 60,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            icon: Icon(FontAwesomeIcons.wallet),
            label: 'Wallet',
          ),
          NavigationDestination(
            icon: Icon(FontAwesomeIcons.bowlFood),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(FontAwesomeIcons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(FontAwesomeIcons.facebookMessenger),
            label: 'Messenges',
          ),
          // NavigationDestination(
          //   icon: Icon(FontAwesomeIcons.airbnb),
          //   label: 'Staggered',
          // ),
          NavigationDestination(
            icon: Icon(FontAwesomeIcons.list),
            label: 'Lives',
          ),
          NavigationDestination(
            icon: ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  imageUrl: widget.userDoc['avatar'],
                  fit: BoxFit.cover,
                  height: 30,
                  width: 30,
                )),
            label: widget.userDoc['displayName'].toString().capitalize(),
          ),
        ],
      )
      // : Container(
      //     height: 260,
      //     child: AdWidget(ad: _banner!),
      //   ),
      ,
      body: <Widget>[
        wallet.MyWalletApp(),
        FoodHome(),
        //MyAppmainWeb(),
        // MyTabCategory(
        //   userDoc: widget.userDoc,
        // ),

        //MyFirestoreListView(),
        //YourPageWithCategoryFilter(),
        // HomeScreen_food(
        //   userDoc: widget.userDoc,
        // ),
        homeList_StateFull(userDoc: widget.userDoc),
        ChatListScreen(),
        // homelist_staggered(userDoc: widget.userDoc),

        // homeList(
        //   userDoc: widget.userDoc,
        //   ad: _banner,
        //   //showInterstitialAd: _showInterstitialAd,
        // ),
        insta(
          userDoc: widget.userDoc,
          //showInterstitialAd: _showInterstitialAd,
        ),
        //HotelAvailability(),
        //HotelAvailabilityScreen(),
        Profile(),
      ][currentPageIndex],
    );
  }
}

class CongratulationsDialog extends StatelessWidget {
  final String animationAsset; // Chemin de l'animation Lottie
  final double coins;

  CongratulationsDialog({required this.animationAsset, required this.coins});

  get currentUser => FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent, // Fond transparent
      elevation: 0, // Pas d'ombre
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              animationAsset, // Utilisez le chemin de l'animation Lottie fourni
              width: 100,
              height: 100,
            ),
            SizedBox(height: 16.0),
            Text(
              'Félicitations !',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Votre Avez Reçu.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            PriceWidget(
              price: coins,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('Users')
                    .doc(currentUser!)
                    .set({'dialogShown': true}, SetOptions(merge: true)).then(
                  (value) => Navigator.of(context).pop(),
                );
                // Fermez la boîte de dialogue
              },
              child: Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}
