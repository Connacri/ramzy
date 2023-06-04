import 'dart:math';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_marquee/infinite_marquee.dart';
import 'package:marquee/marquee.dart';
import 'package:ramzy/pages/addPost_Insta.dart';
import '../Oauth/getFCM.dart';
import '../pages/NearbyPlacesPage.dart';
import '../pages/SearchPage.dart';
import '../pages/booking2.dart';

import '../pages/booking.dart';
import '../pages/plans.dart';
import '../pages/unloggerPublicPage.dart';

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
import 'package:intl/intl.dart' as intl;
import '../2/Hotel/new/globalrooms.dart';
import 'ProfileOthers.dart';
import 'ProvidersPublic.dart';
import 'insta.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../Oauth/AuthPage.dart';
import 'addAnnonce.dart';
import 'itemDetails.dart';

class homeList extends StatelessWidget {
  homeList({Key? key, required this.userDoc}) : super(key: key);
  final userDoc;

// Assuming you have a reference to your Firestore instance
  final CollectionReference locationsRef =
      FirebaseFirestore.instance.collection('Products');

  get query => locationsRef.orderBy('createdAt', descending: true);

  bool isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    final uusers = Provider.of<Collection2Data>(context);

    final iitem = Provider.of<Collection1Data>(context);

    final carouss = Provider.of<Collection3Data>(context);

    final alertItems = Provider.of<CollectionAlertData>(context);

    final alertItemsArabic = Provider.of<CollectionAlertArabcData>(context);

    final PubArea = Provider.of<CollectionPubArea>(context);

    var premiumUsers = uusers.documents
        .where((element) => element['plan'] == 'premium')
        .toList();
    var itmCarous = carouss.documents
        // .where((element) => element['levelItem'] == 'carou')
        .toList();
    var itm = iitem.documents
        .where((element) => element['levelItem'] == 'black')
        .toList();
    var itmm = iitem.documents
        .where((element) => element['levelItem'] == 'gold')
        .toList();
    var itmPubArea = PubArea.documents.toList();

    var InfoAlert = alertItems.documents.toList();
    List<String> fieldValues =
        InfoAlert.map((map) => map['text'].toString() + '.').toList();
    String marqueesList = fieldValues.join('     ');

    var InfoAlertArabic = alertItemsArabic.documents.toList();
    List<String> fieldValuesArabic =
        InfoAlertArabic.map((map) => map['text'].toString() + '.').toList();
    String marqueesListArabic = fieldValuesArabic.join('     ');

    return Scaffold(
      // appBar: AppBar(
      //   title: GestureDetector(
      //     onTap: () => Navigator.of(context)
      //         .push(MaterialPageRoute(builder: (context) => Search())),
      //     child: Text(
      //       'Search...',
      //     ),
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.transparent,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return userDoc == null
                ? unloggedPublicPage()
                : userDoc['userItemsNbr'] == null
                    ? Scaffold(
                        body: Center(child: Text('userItemsNbr n\'exist pas')),
                      )
                    : userDoc['plan'] == 'premium'
                        ? stepper_widget(
                            userDoc: userDoc,
                            ccollection: 'Products',
                          )
                        : userDoc['userItemsNbr'] >= 5
                            ?
                            // MyHom(
                            //                     title: '',
                            //                   )
                            plans()
                            : stepper_widget(
                                userDoc: userDoc,
                                ccollection: 'Products',
                              );
          }));
        },
        child: const Icon(
          FontAwesomeIcons.add,
          color: Colors.black54,
        ),
      ),
      body: PaginateFirestore(
        header: SliverToBoxAdapter(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              itmCarous.length == 0
                  ? Container()
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      child: CarouselSlider.builder(
                        itemCount: itmCarous.length,
                        itemBuilder: (BuildContext context, int index,
                            int pageViewIndex) {
                          var data = itmCarous[index].data() as Map;
                          return InkWell(
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SilverdetailItem(
                                data: data,
                                idDoc: itmCarous[index].id,
                                isLiked: data['usersLike']
                                    .toString()
                                    .contains(user!.uid),
                              ),
                            )),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                ShaderMask(
                                  shaderCallback: (rect) {
                                    return const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black
                                      ],
                                    ).createShader(Rect.fromLTRB(
                                        0, 0, rect.width, rect.height));
                                  },
                                  blendMode: BlendMode.darken,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                          itmCarous[index]['themb'],
                                        ),
                                        fit: BoxFit.cover,
                                        alignment: Alignment.topCenter,
                                      ),
                                    ),
                                  ),
                                ),
                                // Container(
                                //   height: 250,
                                //   width: 100,
                                //   child: ClipRRect(
                                //     child: BackdropFilter(
                                //       filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                //       child: Container(
                                //         padding: EdgeInsets.all(15),
                                //         alignment: Alignment.center,
                                //         color: Colors.grey.withOpacity(0.1),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 32.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      UnsplashAvatarProvider(
                                        userID: itmCarous[index]['userID'],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          itmCarous[index]['item']
                                              .toString()
                                              .toUpperCase(),
                                          overflow: TextOverflow.ellipsis,
                                          textAlign:
                                              isArabic(itmCarous[index]['item'])
                                                  ? TextAlign.right
                                                  : TextAlign.left,
                                          style: isArabic(
                                                  itmCarous[index]['item'])
                                              ? GoogleFonts.cairo(
                                                  color: Colors.white70,
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.bold)
                                              : TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        options: CarouselOptions(
                          aspectRatio: 16 / 9,
                          viewportFraction: 1,
                          //0.8,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 5),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          autoPlayCurve: Curves.easeInToLinear,
                          //.fastOutSlowIn,
                          enlargeCenterPage: true,
                          enlargeFactor: 0,
                          // 0.3,
                          //onPageChanged: callbackFunction,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                    ), // Caroussel
              InfoAlert.isEmpty
                  ? Container()
                  : Container(
                      height: 30,
                      color: Colors.yellow,
                      child: Marquee(
                        text: marqueesList.toUpperCase(),
                        style: TextStyle(color: Colors.black),
                        scrollAxis: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        blankSpace: 20.0,
                        velocity: 35.0,
                        // pauseAfterRound: Duration(seconds: 1),
                        startPadding: 10.0,
                        //accelerationDuration: Duration(seconds: 1),
                        accelerationCurve: Curves.linear,
                        //decelerationDuration: Duration(milliseconds: 500),
                        decelerationCurve: Curves.easeOut,
                      ),
                    ),
              InfoAlertArabic.isEmpty
                  ? Container()
                  : Container(
                      height: 30,
                      color: Colors.black54,
                      child: Marquee(
                        text: marqueesListArabic.toUpperCase(),
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.cairo(
                            textStyle: Theme.of(context).textTheme.headline4,
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                        scrollAxis: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        blankSpace: 20.0,
                        velocity: 35.0,
                        pauseAfterRound: Duration(seconds: 1),
                        startPadding: 10.0,
                        accelerationDuration: Duration(seconds: 1),
                        accelerationCurve: Curves.linear,
                        decelerationDuration: Duration(milliseconds: 500),
                        decelerationCurve: Curves.easeOut,
                      ),
                    ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Wallet',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.brown,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'Coins : ',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.brown,
                          fontSize: 20,
                          fontWeight: FontWeight.w300),
                    ),
                    Text(
                      intl.NumberFormat.currency(symbol: '', decimalDigits: 2)
                          .format(userDoc['coins']),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    userDoc['displayName'].toString().toUpperCase(),
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "مرحبا",
                    style: GoogleFonts.cairo(
                        textStyle: Theme.of(context).textTheme.headline4,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
                child: GestureDetector(
                  //onTap: () => getFcm(),
                  onTap: () {
                    determinePosition()
                        .whenComplete(() => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => NearbyPlacesPage(),
                              ),
                            ));
                  },
                  child: Card(
                    // margin: const EdgeInsets.all(5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 2,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ShaderMask(
                          shaderCallback: (rect) {
                            return const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomLeft,
                              colors: [Colors.transparent, Colors.black],
                            ).createShader(
                                Rect.fromLTRB(0, 0, rect.width, rect.height));
                          },
                          blendMode: BlendMode.darken,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  'https://source.unsplash.com/random',
                                ),
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.radar,
                                color: Colors.white70,
                                shadows: [
                                  Shadow(
                                    blurRadius: 10.0, // shadow blur
                                    color: Colors.black54, // shadow color
                                    offset: Offset(2.0,
                                        2.0), // how much shadow will be shown
                                  ),
                                ],
                              ),
                              Text(
                                'Autour ',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10.0, // shadow blur
                                        color: Colors.black54, // shadow color
                                        offset: Offset(2.0,
                                            2.0), // how much shadow will be shown
                                      ),
                                    ],
                                    fontStyle: FontStyle.italic,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                              Text(
                                'De Moi',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10.0, // shadow blur
                                        color: Colors.black54, // shadow color
                                        offset: Offset(2.0,
                                            2.0), // how much shadow will be shown
                                      ),
                                    ],
                                    fontStyle: FontStyle.italic,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
                child: GestureDetector(
                  //onTap: () => getFcm(),
                  onTap: () {
                    determinePosition()
                        .whenComplete(() => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => stepper2_widget(
                                  ccollection: 'Products',
                                  userDoc: userDoc,
                                ),
                              ),
                            ));
                  },
                  child: Card(
                    // margin: const EdgeInsets.all(5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.black87,
                            ),
                            Text(
                              'Ajouter Une Annonce ',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                child: Row(
                  children: [
                    Text(
                      'Premium',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                    Text(
                      'Seller',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  ],
                ),
              ),
              TopUsers(premiumUsers),

              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                child: Row(
                  children: [
                    Text(
                      'Flash',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown),
                    ),
                    Text(
                      'Sell',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ],
                ),
              ), // FlashSell
              Container(
                padding: EdgeInsets.only(left: 6),
                height: 220,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: itm.length,
                  //1, //(iitem.documents.length / 3).truncate(),
                  itemBuilder: (BuildContext context, int index) {
                    var data = itm[index].data() as Map;
                    return GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SilverdetailItem(
                          data: data,
                          idDoc: itm[index].id,
                          isLiked:
                              data['usersLike'].toString().contains(user!.uid),
                        ),
                      )),
                      child: Card(
                        //  margin: const EdgeInsets.all(5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 2,
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                ShaderMask(
                                  shaderCallback: (rect) {
                                    return const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black
                                      ],
                                    ).createShader(Rect.fromLTRB(
                                        0, 0, rect.width, rect.height));
                                  },
                                  blendMode: BlendMode.darken,
                                  child: CachedNetworkImage(
                                    alignment: Alignment.topCenter,
                                    fadeInDuration: Duration(seconds: 2),
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 130,
                                    imageUrl: itm[index]['themb'],
                                    //iitem.documents[index]['themb'],
                                    // 'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/carre%2Fcarre%20(${index + 1}).jpg?alt=media&token=68e384f1-bb64-47cf-a245-9f7f12202443',
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  left: 5,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      itm[index]['category'],
                                      overflow: TextOverflow.fade,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        intl.NumberFormat.compact().format(
                                          itm[index]['likes'],
                                          // iitem.documents[index]['likes']
                                        ),
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 10,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Icon(
                                        FontAwesomeIcons.eye,
                                        size: 9,
                                        color: Colors.white70,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 100,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  itm[index]['item'].toString().toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: isArabic(itm[index]['item'])
                                      ? TextAlign.right
                                      : TextAlign.left,
                                  style: isArabic(itm[index]['item'])
                                      ? GoogleFonts.cairo(
                                          // textStyle: Theme.of(context).textTheme.headline4,
                                          fontSize: 12,
                                        )
                                      : TextStyle(
                                          // color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                ),
                              ),
                            ),
                            Container(
                              width: 100,
                              child: itm[index]['price'] <= 0
                                  ? Text('')
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      child: itm[index]['price'] >= 1000

                                          //   iitem.documents[index]['price'] >= 1000
                                          ? Text(
                                              intl.NumberFormat.compactCurrency(
                                                      symbol: 'Da ',
                                                      decimalDigits: 2)
                                                  .format(itm[index]['price']
                                                      //iitem.documents[index]['price']
                                                      ),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 14),
                                            )
                                          : Text(
                                              intl.NumberFormat.currency(
                                                      symbol: 'Da ',
                                                      decimalDigits: 2)
                                                  .format(itm[index]['price']
                                                      //iitem.documents[index]['price']
                                                      ),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 14),
                                            ),
                                    ),
                            ),
                            Container(
                              width: 100,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  '${itm[index]['category']}-${itm[index]['levelItem']}',
                                  //   '${iitem.documents[index]['category']}  ${iitem.documents[index]['levelItem']}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                            Container(
                              width: 100,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  itm[index]['createdAt']
                                      //iitem.documents[index]['createdAt']
                                      .toDate()
                                      .toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 9),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 5,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        ShaderMask(
                          shaderCallback: (rect) {
                            return const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomRight,
                              colors: [Colors.transparent, Colors.black45],
                            ).createShader(
                                Rect.fromLTRB(0, 0, rect.width, rect.height));
                          },
                          blendMode: BlendMode.darken,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.38,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/wall%2Fwall%20(0).jpg?alt=media&token=c5c01dca-4b32-4b9d-88fe-717e976ac2f5',
                                ),
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                          ),
                        ),
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                          child: Container(
                            alignment: Alignment.center,
                            color: Colors.grey.withOpacity(0.1),
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'A Ne Pas ',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          shadows: [
                                            Shadow(
                                              blurRadius: 10.0, // shadow blur
                                              color: Colors
                                                  .black54, // shadow color
                                              offset: Offset(2.0,
                                                  2.0), // how much shadow will be shown
                                            ),
                                          ],
                                          fontStyle: FontStyle.italic,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      'Rater',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          shadows: [
                                            Shadow(
                                              blurRadius: 10.0, // shadow blur
                                              color: Colors
                                                  .black38, // shadow color
                                              offset: Offset(2.0,
                                                  2.0), // how much shadow will be shown
                                            ),
                                          ],
                                          fontStyle: FontStyle.italic,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 6),
                              height: 200,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: itmm.length,
                                itemBuilder: (BuildContext context, int index) {
                                  print('////////////////////////////////////');
                                  print(itmm[index]['levelItem']);
                                  print(itmm.length);
                                  var data = itmm[index].data() as Map;
                                  return GestureDetector(
                                    onTap: () => Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => SilverdetailItem(
                                        data: data,
                                        idDoc: itmm[index].id,
                                        isLiked: data['usersLike']
                                            .toString()
                                            .contains(user!.uid),
                                      ),
                                    )),
                                    child: Card(
                                      //  margin: const EdgeInsets.all(5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      elevation: 2,
                                      child: Column(
                                        children: [
                                          Stack(
                                            alignment: Alignment.bottomCenter,
                                            children: [
                                              ShaderMask(
                                                shaderCallback: (rect) {
                                                  return const LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomLeft,
                                                    colors: [
                                                      Colors.transparent,
                                                      Colors.black
                                                    ],
                                                  ).createShader(Rect.fromLTRB(
                                                      0,
                                                      0,
                                                      rect.width,
                                                      rect.height));
                                                },
                                                blendMode: BlendMode.darken,
                                                child: CachedNetworkImage(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  fadeInDuration:
                                                      Duration(seconds: 2),
                                                  fit: BoxFit.cover,
                                                  width: 100,
                                                  height: 130,
                                                  imageUrl: itmm[index]
                                                      ['themb'],
                                                  //iitem.documents[index]['themb'],
                                                  // 'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/carre%2Fcarre%20(${index + 1}).jpg?alt=media&token=68e384f1-bb64-47cf-a245-9f7f12202443',
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          const Icon(
                                                    Icons.error,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 5,
                                                left: 5,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.black54,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    itmm[index]['category'],
                                                    overflow: TextOverflow.fade,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                              itmm[index]['price'] <= 0
                                                  ? Text('')
                                                  : Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 4.0),
                                                      child: itmm[index]
                                                                  ['price'] >=
                                                              1000000

                                                          //   iitem.documents[index]['price'] >= 1000
                                                          ? Text(
                                                              intl.NumberFormat.compactCurrency(
                                                                      symbol:
                                                                          'Da ',
                                                                      decimalDigits:
                                                                          2)
                                                                  .format(
                                                                      itmm[index]
                                                                          [
                                                                          'price']
                                                                      //iitem.documents[index]['price']
                                                                      ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .greenAccent),
                                                            )
                                                          : Text(
                                                              intl.NumberFormat.currency(
                                                                      symbol:
                                                                          'Da ',
                                                                      decimalDigits:
                                                                          2)
                                                                  .format(
                                                                      itmm[index]
                                                                          [
                                                                          'price']
                                                                      //iitem.documents[index]['price']
                                                                      ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .greenAccent),
                                                            ),
                                                    ),
                                            ],
                                          ),
                                          Container(
                                            width: 100,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4.0),
                                              child: Text(
                                                itmm[index]['item']
                                                    .toString()
                                                    .toUpperCase(),
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: isArabic(
                                                        itmm[index]['item'])
                                                    ? TextAlign.right
                                                    : TextAlign.left,
                                                style: isArabic(
                                                        itmm[index]['item'])
                                                    ? GoogleFonts.cairo(
                                                        //  textStyle: Theme.of(context).textTheme.headline4,
                                                        fontSize: 12,
                                                      )
                                                    : TextStyle(
                                                        fontSize: 12,
                                                      ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 100,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4.0),
                                              child: Text(
                                                '${itmm[index]['category']}-${itmm[index]['levelItem']}',
                                                //   '${iitem.documents[index]['category']}  ${iitem.documents[index]['levelItem']}',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 100,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4.0),
                                              child: Text(
                                                itmm[index]['createdAt']
                                                    //iitem.documents[index]['createdAt']
                                                    .toDate()
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(fontSize: 9),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  '${iitem.documents.length} Articles Les Plus Recent Par Pertinance. ',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
        itemsPerPage: 10000,
        onEmpty: const Scaffold(
          body: Center(
              child: Text(
            'BD Oran En Construcion',
            style: TextStyle(fontSize: 40),
          )),
        ),
        // EmptyDisplay(),
        separator: const EmptySeparator(),
        initialLoader: const InitialLoader(),
        bottomLoader: const BottomLoader(),
        shrinkWrap: true,
        isLive: true,
        itemBuilderType: PaginateBuilderType.gridView,
        query: query,
        itemBuilder: (BuildContext, DocumentSnapshot, intex) {
          var data = DocumentSnapshot[intex].data() as Map?;
          String dataid = DocumentSnapshot[intex].id;
          Random random = new Random();
          var randomNumber = random.nextInt(27);
          String randomPhoto =
              'https://firebasestorage.googleapis.com/v0/b/wahrane-a42eb.appspot.com/o/pub%2Fpub(${randomNumber}).jpg?alt=media&token=5d9e0764-23f6-4b18-95f4-e085736659cc';

          List<String> list3 = [
            'Area 1',
            'Area 2',
            'Area 3',
            'Area 4',
            'Area 5',
            'Area 6',
            'Area 7',
            'Area 8',
            'Area 9',
            'Area 10',
          ];

          if ((intex + 1) % 5 == 0) {
            int listIndex = ((intex + 1) ~/ 5) - 1;
            if (listIndex < list3.length) {
              return CardPubArea(
                randomPhoto: randomPhoto,
                label: list3[listIndex],
              );
            }
          }

          final bool isLiked =
              data!['usersLike'].toString().contains(user!.uid);
          return CardFirestore(
            user: user,
            data: data,
            isLiked: isLiked,
            dataid: dataid,
          );
        },
      ),
    );
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

// void getFcm() async {
//   String? fcmKey = await getFcmToken();
//   print('fcmKey : $fcmKey');
//   // sendNotification(
//   //     'daYiNgoeTqGL3tiZJXI4R-:APA91bFidQzX0ml2PmwWJZC_bWaauXQggw1TXQ-7V_j9EfHh0fBktjeY-p264z_hu1ReOXbTHBEjTgG-IhxP1elPtqrL8_IkYShY2zsYx19IQzWa1NC7h-uy9UQa-rVoo_HFX8Gv9OwX',
//   //     'Test Titre',
//   //     'Test body');
// }
}

class CardFirestore extends StatelessWidget {
  CardFirestore({
    Key? key,
    required this.user,
    required this.data,
    required this.isLiked,
    required this.dataid,
  }) : super(key: key);

  final Map data;
  bool isLiked;
  final user;
  final dataid;

  bool isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        updateViewsAndUserList(
          'Products',
          dataid,
          user.uid,
        ).whenComplete(
          () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                SilverdetailItem(data: data, idDoc: dataid, isLiked: isLiked),
          )),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ShaderMask(
              shaderCallback: (rect) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomLeft,
                  colors: [Colors.transparent, Colors.black],
                ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
              },
              blendMode: BlendMode.darken,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      data['themb'],
                    ),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 3),
                          child: Icon(
                            PropertyIconMapper.mapItemTypeToIcon(
                                data['category']),
                            color: Colors.white70,
                            size: 18,
                          ),
                        ),
                        Spacer(),
                        Builder(builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  intl.NumberFormat.compact()
                                      .format(data['views']),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Icon(
                                  FontAwesomeIcons.eye,
                                  size: 11,
                                  color: Colors.white70,
                                )
                              ],
                            ),
                          );
                        }),
                        Builder(builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  intl.NumberFormat.compact()
                                      .format(data['likes']),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    color:
                                        isLiked ? Colors.red : Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                isLiked
                                    ? Icon(
                                        FontAwesomeIcons.heartCircleCheck,
                                        size: 12,
                                        color: Colors.red,
                                      )
                                    : Icon(
                                        FontAwesomeIcons.heart,
                                        size: 12,
                                        color: Colors.white70,
                                      )
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: data['type'] == 'vente'
                                  ? Colors.blueAccent
                                  : Colors.green,
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            data['type'].toString().toUpperCase(),
                            overflow: TextOverflow.fade,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            data['category'],
                            overflow: TextOverflow.fade,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            data['item'].toString().toUpperCase(),
                            overflow: TextOverflow.ellipsis,
                            textAlign: isArabic(data['item'])
                                ? TextAlign.right
                                : TextAlign.left,
                            style: isArabic(data['item'])
                                ? GoogleFonts.cairo(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500)
                                : TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      data['price'] == 0
                          ? Text('')
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 0.0),
                              child: Center(
                                child: FittedBox(
                                  child: Row(
                                    children: [
                                      Text(
                                        data['price'] >= 1000000.00
                                            ? intl.NumberFormat.compactCurrency(
                                                    symbol: 'Da ',
                                                    decimalDigits: 2)
                                                .format(data['price'])
                                            : intl.NumberFormat.currency(
                                                    symbol: 'Da ',
                                                    decimalDigits: 2)
                                                .format(data['price']),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          //backgroundColor: Colors.black45,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                      data['type'] == 'location'
                                          ? data['modePayment'] != null &&
                                                  data['modePayment'] != ''
                                              ? Text(
                                                  '/' +
                                                      data['modePayment']
                                                          .toString()
                                                          .toUpperCase(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    //backgroundColor: Colors.black45,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : Text('')
                                          : Text(
                                              data['modePayment']
                                                  .toString()
                                                  .toUpperCase(),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                //backgroundColor: Colors.black45,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5, bottom: 5),
                        child: Text(
                            timeago.format(data['createdAt'].toDate(),
                                locale: 'fr'),
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardPubArea extends StatelessWidget {
  const CardPubArea({
    super.key,
    required this.randomPhoto,
    required this.label,
  });

  final String randomPhoto;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Card(
      //  margin: const EdgeInsets.all(5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5,
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.passthrough,
        children: [
          Container(
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: randomPhoto,
              //data['themb'],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: FittedBox(
                child: Text(
                  'Pub-$label',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      shadows: [
                        Shadow(
                          blurRadius: 10.0, // shadow blur
                          color: Colors.black54, // shadow color
                          offset:
                              Offset(2.0, 2.0), // how much shadow will be shown
                        ),
                      ],
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PropertyIconMapper {
  static IconData mapItemTypeToIcon(String itemType) {
    switch (itemType) {
      case 'Hotel':
        return Icons.hotel;
      case 'Autres':
        return Icons.account_balance;
      case 'Agence':
        return Icons.real_estate_agent_outlined;
      case 'Residence':
        return Icons.business;
      // case 'Sponsors':
      //   return Icons.monetization_on_rounded;
      default:
        return Icons.help_outline;
    }
  }
}

class UnsplashAvatarProvider extends StatelessWidget {
  const UnsplashAvatarProvider({
    Key? key,
    required this.userID,
  }) : super(key: key);

  final String userID;

  @override
  Widget build(BuildContext context) {
    final docRef = FirebaseFirestore.instance.collection('Users').doc(userID);
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: docRef.get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text('Loading..'),
            );
          }
          var data = snapshot.data?.data();
          return InkWell(
            onTap: () async {
              Map dataUser = data as Map;
              await Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return ProfileOthers(data: dataUser);
              }));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 20.0,
                    height: 20.0,
                    child: CachedNetworkImage(
                      imageUrl: data!['avatar'],
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.white),
                          // borderRadius: BorderRadius.circular(100),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.no_accounts_rounded),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: SizedBox(
                      child: Text(
                        data['displayName'] ?? 'Unknow',
                        style: TextStyle(fontSize: 16, color: Colors.cyan),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

Future<void> moveStock(String productID, data, int amount, PUA) async {
  final CollectionReference SourceCollection =
      FirebaseFirestore.instance.collection('Products');
  final CollectionReference DestinationCollection =
      FirebaseFirestore.instance.collection('Instalives');
  final DocumentReference sourceReference = SourceCollection.doc(productID);
  final DocumentReference destinationReference =
      DestinationCollection.doc(productID);
  User? _user = FirebaseAuth.instance.currentUser;

  await FirebaseFirestore.instance
      .runTransaction((Transaction transaction) async {
    //start
    DocumentSnapshot sourceSnapshot = await transaction.get(sourceReference);
    DocumentSnapshot destinationSnapshot =
        await transaction.get(destinationReference);

    int sourceStock = data['stock'];
    //    int destinationStock = destinationSnapshot.data()['qty'];
    DocumentSnapshot<Map<String?, dynamic>> docDestination =
        await FirebaseFirestore.instance
            .collection('Instalives')
            .doc(productID)
            .get();

    if (sourceStock >= amount) {
      if (docDestination.exists) {
        await transaction
            .update(sourceReference, {'stock': sourceStock - amount});
        await transaction.update(destinationReference, {
          'createdAt': Timestamp.now().toDate(),
          'category': data['category'],
          'model': data['model'],
          'description': data['description'],
          'size': data['size'],
          'prixAchat': data['prixAchat'],
          'prixVente': data['prixVente'],
          'stock': data['stock'],
          'codebar': data['codebar'],
          'oldStock': data['oldStock'],
          'origine': data['origine'],
          'user': _user!.uid, //data['user'],
          'qty': FieldValue.increment(amount),
          'state': true,
          //'earn': earn,
          'PUA': PUA,
        });
      } else {
        await transaction
            .update(sourceReference, {'stock': sourceStock - amount});
        await transaction.set(destinationReference, {
          'createdAt': Timestamp.now().toDate(),
          'category': data['category'],
          'model': data['model'],
          'description': data['description'],
          'size': data['size'],
          'prixAchat': data['prixAchat'],
          'prixVente': data['prixVente'],
          'stock': data['stock'],
          'codebar': data['codebar'],
          'oldStock': data['oldStock'],
          'origine': data['origine'],
          'user': _user!.uid, //data['user'],
          'qty': FieldValue.increment(amount),
          'state': true,
          //'earn': earn,
          'PUA': PUA,
        });
      }
    } else {
      throw Exception('Not enough stock in source product');
    }
  });
}

Future<void> updateViewsAndUserList(
    String collection, productId, String userId) async {
  // Récupération du document du produit
  DocumentReference productRef =
      FirebaseFirestore.instance.collection(collection).doc(productId);
  DocumentSnapshot productSnapshot = await productRef.get();

  // Vérification si l'utilisateur a déjà vu le produit
  List<dynamic> viewedByList = productSnapshot.get('viewed_by');
  bool userHasViewed = viewedByList.contains(userId);

  // Mise à jour des données du produit
  if (userHasViewed) {
    // L'utilisateur a déjà vu le produit
    // await productRef.update({
    //   'views': productSnapshot.get('views') + 1,
    // });
    return;
  } else {
    // L'utilisateur n'a pas encore vu le produit
    await productRef.update({
      'views': productSnapshot.get('views') + 1,
      'viewed_by': viewedByList..add(userId),
    });
  }
}
