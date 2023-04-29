import 'dart:ui';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ramzy/pages/classes.dart';
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
  @override
  void initState() {
    super.initState();
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
      bottomNavigationBar: NavigationBar(
        height: 60,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            icon: Icon(FontAwesomeIcons.home),
            label: 'Home',
          ),
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
      ),
      body: <Widget>[
        homeList(
          userDoc: widget.userDoc,
        ),
        insta(
          userDoc: widget.userDoc,
        ),
        //HotelAvailability(),
        //HotelAvailabilityScreen(),
        Profile(),
      ][currentPageIndex],
    );
  }
}
