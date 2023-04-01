import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterflow_paginate_firestore/widgets/bottom_loader.dart';
import 'package:flutterflow_paginate_firestore/widgets/empty_display.dart';
import 'package:flutterflow_paginate_firestore/widgets/empty_separator.dart';
import 'package:flutterflow_paginate_firestore/widgets/initial_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../2/Hotel/new/globalrooms.dart';
import '../map/MainExample.dart';
import '../map/mapPicker.dart';
import '../map/SimpleExample.dart';
import 'ProfileOthers.dart';
import 'homeList.dart';
import 'insta.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../2/Hotel/global_rooms.dart';
import '../2/Hotel/hotel_charts.dart';
import '../2/ouedkniss.dart';
import '../2/publicLoggedPage.dart';
import '../Oauth/AuthPage.dart';
import '../services/upload_random.dart';
import 'Profile.dart';
import 'addAnnonce.dart';
import 'itemDetails.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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

// class UserX {
//   final String avatar;
//   final double coins;
//   final Timestamp createdAt;
//   final String displayName;
//   final String email;
//   final String id;
//   final Timestamp lastActive;
//   final String levelUser;
//   final String plan;
//   final String role;
//   final bool state;
//   final String timeline;
//
//   UserX({
//     required this.avatar,
//     required this.coins,
//     required this.createdAt,
//     required this.displayName,
//     required this.email,
//     required this.id,
//     required this.lastActive,
//     required this.levelUser,
//     required this.plan,
//     required this.role,
//     required this.state,
//     required this.timeline,
//   });
//
//   factory UserX.fromSnapshot(DocumentSnapshot snapshot) {
//     return UserX(
//       avatar: snapshot['avatar'],
//       coins: snapshot['coins'] as double,
//       createdAt: snapshot['createdAt'] as Timestamp,
//       displayName: snapshot['displayName'],
//       email: snapshot['email'],
//       id: snapshot['id'],
//       lastActive: snapshot['lastActive'] as Timestamp,
//       levelUser: snapshot['levelUser'] as String,
//       plan: snapshot['plan'] as String,
//       role: snapshot['role'],
//       state: snapshot['state'] as bool,
//       timeline: snapshot['timeline'],
//     );
//   }
// }

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
