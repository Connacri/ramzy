import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:flutterflow_paginate_firestore/widgets/bottom_loader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../Oauth/AuthPage.dart';
import 'ProfileOthers.dart';
import 'ProvidersPublic.dart';
import 'addPost.dart';
import 'addPost2.dart';
import 'homeList.dart';
import 'itemDetails.dart';
import 'item_details-statefull.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';

class insta extends StatefulWidget {
  const insta({Key? key, required this.userDoc}) : super(key: key);
  final userDoc;

  @override
  State<insta> createState() => _instaState();
}

class _instaState extends State<insta> {
  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    // Add french messages
    timeago.setLocaleMessages('fr', timeago.FrMessages());
    final userm = FirebaseAuth.instance.currentUser;
    final bool _enabled = true;
    var user = FirebaseAuth.instance.currentUser;
    final uusers = Provider.of<Collection2Data>(context);

    final iitem = Provider.of<Collection1Data>(context);

    final carouss = Provider.of<Collection3Data>(context);
    //final iiitem = iitem.goldItems;
    var premiumUsers = uusers.documents
        .where((element) => element['plan'] == 'premium')
        .toList();
    var itmCarous = carouss.documents
        // .where((element) => element['levelItem'] == 'carou')
        .toList();
    var itm = iitem.documents
        .where((element) => element['levelItem'] == 'gold')
        .toList();
    var itmm = iitem.documents
        .where((element) => element['levelItem'] == 'silver')
        .toList();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.transparent,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return stepper2_widget(
              userDoc: widget.userDoc,
              ccollection: 'Instalives',
            );
          }));
        },
        child: const Icon(
          FontAwesomeIcons.telegram,
          color: Colors.black54,
        ),
      ),
      body: PageStorage(
        bucket: _bucket,
        child: PaginateFirestore(
          header: SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                user == null
                    ? Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 70.0),
                          child: Card(
                            // margin: const EdgeInsets.all(5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            elevation: 5,
                            child: Stack(
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
                                    height: 50,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                          'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/wall%2Fwall%20(4).jpg?alt=media&token=c5c01dca-4b32-4b9d-88fe-717e976ac2f5',
                                        ),
                                        fit: BoxFit.cover,
                                        alignment: Alignment.topCenter,
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AuthPage()));
                                    },
                                    child: Text(
                                      'Google Sign in',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: CarouselSlider.builder(
                    itemCount: itmCarous.length,
                    itemBuilder:
                        (BuildContext context, int index, int pageViewIndex) {
                      var data = itmCarous[index].data() as Map;
                      return InkWell(
                        onDoubleTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SilverdetailItem(
                            data: data,
                            idDoc: itmCarous[index].id,
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
                                  colors: [Colors.transparent, Colors.black],
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
                                      style: TextStyle(
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
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.easeInToLinear,
                      //.fastOutSlowIn,
                      enlargeCenterPage: true,
                      enlargeFactor: 0,
                      // 0.3,
                      //onPageChanged: callbackFunction,
                      scrollDirection: Axis.horizontal,
                    ),
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
                        NumberFormat.currency(symbol: '', decimalDigits: 2)
                            .format(widget.userDoc['coins']),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                  child: Row(
                    children: [
                      Text(
                        'Top',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                      Text(
                        'Publiers',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown),
                      ),
                    ],
                  ),
                ),
                TopUsers(premiumUsers),

                //Users Premium

                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                  child: Row(
                    children: [
                      Text(
                        'Super',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                      Text(
                        'Recommendations',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
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
                      print('////////////////////////////////////');
                      print(itm[index]['levelItem']);
                      print(itm.length);
                      var data = itm[index].data() as Map;
                      return GestureDetector(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SilverdetailItem(
                            data: data,
                            idDoc: itm[index].id,
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
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          NumberFormat.compact().format(
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: Text(
                                    itm[index]['item'],
                                    // iitem.documents[index]['item'],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                              Container(
                                width: 100,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: itm[index]['price'] >= 1000

                                      //   iitem.documents[index]['price'] >= 1000
                                      ? Text(
                                          NumberFormat.compactCurrency(
                                                  symbol: 'DZD ',
                                                  decimalDigits: 2)
                                              .format(itm[index]['price']
                                                  //iitem.documents[index]['price']
                                                  ),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 14),
                                        )
                                      : Text(
                                          NumberFormat.currency(
                                                  symbol: 'DZD ',
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
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
                                    'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/wall%2Fwall%20(3).jpg?alt=media&token=c5c01dca-4b32-4b9d-88fe-717e976ac2f5',
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
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(
                              //       horizontal: 20.0, vertical: 10),
                              //   child: Card(
                              //     // margin: const EdgeInsets.all(5),
                              //     shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(15)),
                              //     clipBehavior: Clip.antiAliasWithSaveLayer,
                              //     elevation: 2,
                              //     child: Stack(
                              //       alignment: Alignment.center,
                              //       children: [
                              //         // ShaderMask(
                              //         //   shaderCallback: (rect) {
                              //         //     return const LinearGradient(
                              //         //       begin: Alignment.topCenter,
                              //         //       end: Alignment.bottomLeft,
                              //         //       colors: [
                              //         //         Colors.transparent,
                              //         //         Colors.black
                              //         //       ],
                              //         //     ).createShader(Rect.fromLTRB(
                              //         //         0, 0, rect.width, rect.height));
                              //         //   },
                              //         //   blendMode: BlendMode.darken,
                              //         //   // child: Container(
                              //         //   //   height: 50,
                              //         //   //   decoration: BoxDecoration(
                              //         //   //     image: DecorationImage(
                              //         //   //       image: CachedNetworkImageProvider(
                              //         //   //         'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/wall%2Fwall%20(3).jpg?alt=media&token=c5c01dca-4b32-4b9d-88fe-717e976ac2f5',
                              //         //   //       ),
                              //         //   //       fit: BoxFit.cover,
                              //         //   //       alignment: Alignment.topCenter,
                              //         //   //     ),
                              //         //   //   ),
                              //         //   // ),
                              //         // ),
                              //         Center(
                              //           child: Row(
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment.center,
                              //             crossAxisAlignment:
                              //                 CrossAxisAlignment.center,
                              //             children: [
                              //               Text(
                              //                 'Affaire',
                              //                 textAlign: TextAlign.start,
                              //                 style: TextStyle(
                              //                     fontStyle: FontStyle.italic,
                              //                     fontSize: 20,
                              //                     fontWeight: FontWeight.bold,
                              //                     color: Colors.white),
                              //               ),
                              //               Text(
                              //                 'Jahde',
                              //                 textAlign: TextAlign.center,
                              //                 style: TextStyle(
                              //                     fontStyle: FontStyle.italic,
                              //                     fontSize: 20,
                              //                     fontWeight: FontWeight.bold,
                              //                     color: Colors.black),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Dir',
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
                                        'Affaire',
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    print(
                                        '////////////////////////////////////');
                                    print(itmm[index]['levelItem']);
                                    print(itmm.length);
                                    var data = itmm[index].data() as Map;
                                    return GestureDetector(
                                      onTap: () => Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => SilverdetailItem(
                                          data: data,
                                          idDoc: itmm[index].id,
                                        ),
                                      )),
                                      child: Card(
                                        //  margin: const EdgeInsets.all(5),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        elevation: 2,
                                        child: Column(
                                          children: [
                                            Stack(
                                              alignment: Alignment.bottomCenter,
                                              children: [
                                                ShaderMask(
                                                  shaderCallback: (rect) {
                                                    return const LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment.bottomLeft,
                                                      colors: [
                                                        Colors.transparent,
                                                        Colors.black
                                                      ],
                                                    ).createShader(
                                                        Rect.fromLTRB(
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
                                                // Padding(
                                                //   padding: const EdgeInsets
                                                //           .symmetric(
                                                //       horizontal: 8,
                                                //       vertical: 4),
                                                //   child: Row(
                                                //     mainAxisAlignment:
                                                //         MainAxisAlignment
                                                //             .center,
                                                //     crossAxisAlignment:
                                                //         CrossAxisAlignment
                                                //             .center,
                                                //     children: [
                                                //       Text(
                                                //         NumberFormat.compact()
                                                //             .format(
                                                //           itm[index]['likes'],
                                                //           // iitem.documents[index]['likes']
                                                //         ),
                                                //         textAlign:
                                                //             TextAlign.end,
                                                //         style: TextStyle(
                                                //           color: Colors.white70,
                                                //           fontSize: 10,
                                                //         ),
                                                //       ),
                                                //       SizedBox(
                                                //         width: 3,
                                                //       ),
                                                //       Icon(
                                                //         FontAwesomeIcons.eye,
                                                //         size: 9,
                                                //         color: Colors.white70,
                                                //       )
                                                //     ],
                                                //   ),
                                                // ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 4.0),
                                                  child: itmm[index]['price'] >=
                                                          1000000

                                                      //   iitem.documents[index]['price'] >= 1000
                                                      ? Text(
                                                          NumberFormat.compactCurrency(
                                                                  symbol:
                                                                      'DZD ',
                                                                  decimalDigits:
                                                                      2)
                                                              .format(
                                                                  itmm[index]
                                                                      ['price']
                                                                  //iitem.documents[index]['price']
                                                                  ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .greenAccent),
                                                        )
                                                      : Text(
                                                          NumberFormat.currency(
                                                                  symbol:
                                                                      'DZD ',
                                                                  decimalDigits:
                                                                      2)
                                                              .format(
                                                                  itmm[index]
                                                                      ['price']
                                                                  //iitem.documents[index]['price']
                                                                  ),
                                                          overflow: TextOverflow
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
                                                  itmm[index]['item'],
                                                  // iitem.documents[index]['item'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      TextStyle(fontSize: 12),
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      TextStyle(fontSize: 12),
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
          footer: const SliverToBoxAdapter(child: Center(child: Text('Fin.'))),
          itemsPerPage: 10000,
          isLive: true,
          //scrollController: _scrollController,
          itemBuilderType: PaginateBuilderType.listView,
          query: FirebaseFirestore.instance
              .collection('Instalives')
              .orderBy('createdAt', descending: true),
          bottomLoader: const BottomLoader(),
          itemBuilder: (BuildContext, documentSnapshots, index) {
            var data = documentSnapshots[index].data() as Map?;
            String /*var*/ dataid = documentSnapshots[index].id;

            final docidd = data!['userID'];

            return data == null
                ? const Text(
                    'Error in data',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Oswald'),
                  )
                : InkWell(
                    child: like_instagram(
                      data: data,
                      user: userm,
                      isLiked:
                          data['usersLike'].toString().contains(userm!.uid),
                      docid: dataid,
                      docidd: docidd.toString(),
                    ),
                  );
          },
        ),
      ),
    );
  }

  directionVent(direction) {
    if (direction >= 0 && direction < 22.5) {
      return 'Nord N';
    }
    if (direction >= 22.5 && direction < 45) {
      return 'Nord NNE';
    }
    if (direction >= 45 && direction < 67.5) {
      return 'Nord NE';
    }
    if (direction >= 67.5 && direction < 90) {
      return 'Est ENE';
    }
    if (direction >= 90 && direction < 112.5) {
      return 'Est E';
    }
    if (direction >= 112.5 && direction < 135) {
      return 'Est ESE';
    }
    if (direction >= 135 && direction < 157.5) {
      return 'Sud SE';
    }
    if (direction >= 157.5 && direction < 180) {
      return 'Sud SSE';
    }
    if (direction >= 180 && direction < 202.5) {
      return 'Sud S';
    }
    if (direction >= 202.5 && direction < 225) {
      return 'Sud SSW';
    }
    if (direction >= 225 && direction < 247.5) {
      return 'Sud SW';
    }
    if (direction >= 247.5 && direction < 270) {
      return 'Ouest WSW';
    }
    if (direction >= 270 && direction < 292.5) {
      return 'Ouest W';
    }
    if (direction >= 292.5 && direction < 315) {
      return 'Ouest WNW';
    }
    if (direction >= 315 && direction < 337.5) {
      return 'Nord NW';
    }
    if (direction >= 337.5 && direction <= 360) {
      return 'Nord NNW';
    }
    print(
        'METEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEO');
    //print(directionVent(direction).toString());
  }
}

class like_instagram extends StatefulWidget {
  like_instagram({
    Key? key,
    required Map? data,
    required this.docid,
    required this.user,
    required this.isLiked,
    required this.docidd,
  })  : datam = data,
        //**************
        super(key: key);

  final Map? datam;
  final User? user;
  String docid;
  bool isLiked;
  String docidd;

  @override
  State<like_instagram> createState() => _like_instagramState();
}

class _like_instagramState extends State<like_instagram> {
  bool isHeartAnimating = false;

  final user = FirebaseAuth.instance.currentUser;
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildImage(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      //color: Colors.green,
                      child: HeartAnimationWidget(
                        alwaysAnimate: true,
                        isAnimating: widget.isLiked,
                        dataid: '',
                        user: '',
                        child: IconButton(
                          icon: widget.isLiked
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : const Icon(Icons.favorite_border_outlined,
                                  color: Colors.blueGrey),
                          onPressed: widget.isLiked
                              ? () async {
                                  await FirebaseFirestore.instance
                                      .collection('Instalives')
                                      .doc(widget.docid)
                                      .update({
                                    'likes': FieldValue.increment(-1),
                                    'usersLike':
                                        FieldValue.arrayRemove([user!.uid]),
                                  });
                                  //setState(() => widget.isLiked = !widget.isLiked);
                                }
                              : () async {
                                  await FirebaseFirestore.instance
                                      .collection('Instalives')
                                      .doc(widget.docid)
                                      .update({
                                    'likes': FieldValue.increment(1),
                                    'usersLike':
                                        FieldValue.arrayUnion([user!.uid]),
                                  });
                                  //setState(() => widget.isLiked = !widget.isLiked);
                                },
                        ),
                      ),
                    ),
                    Container(
                      //color: Colors.blue,
                      child: Text(
                        intl.NumberFormat.compact(locale: 'fr_IN')
                            .format(widget.datam!['likes']),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          fontFamily: 'Oswald',
                        ),
                      ),
                    ), // Likes Number
                  ],
                ),
              ],
            ), // Likes Number // Price
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
              child: ReadMoreText(
                widget.datam!['Description'].toUpperCase(),
                trimLines: 3,
                colorClickableText: Colors.pink,
                trimMode: TrimMode.Line,
                textAlign: TextAlign.justify,
                trimCollapsedText: 'Plus',
                trimExpandedText: '  Moins',
                moreStyle: const TextStyle(
                    fontSize: 14, fontFamily: 'oswald', color: Colors.blue),
                lessStyle: const TextStyle(
                    fontSize: 14, fontFamily: 'oswald', color: Colors.red),
                style: const TextStyle(
                    fontSize: 14, fontFamily: 'oswald', color: Colors.black87),
              ),
            ),
            Divider()
          ],
        ),
      );

  Widget buildImage() => GestureDetector(
        child: Stack(
          alignment: Alignment.topCenter,
          //fit: StackFit.loose,
          //clipBehavior: Clip.hardEdge,
          children: [
            ShaderMask(
              shaderCallback: (rect) {
                return const RadialGradient(
                  colors: [Colors.transparent, Colors.black87],
                  tileMode: TileMode.clamp,
                  focalRadius: 1,
                  radius: 1,
                  stops: [0.1, 1],
                  center: Alignment.center,
                ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
              },
              blendMode: BlendMode.darken,
              child: widget.datam!['imageUrls'].length == 1
                  ? AspectRatio(
                      aspectRatio: 1.0,
                      child: CachedNetworkImage(
                        imageUrl: widget.datam!['imageUrls'][0],
                        fit: BoxFit.cover,
                      ),
                    )
                  : Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        CarouselSlider.builder(
                          //carouselController: _controller,
                          itemCount: widget.datam!['imageUrls'].length,
                          itemBuilder: (BuildContext context, int index,
                                  int pageViewIndex) =>
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
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      widget.datam!['imageUrls'][index],
                                    ),
                                    fit: BoxFit.cover,
                                    alignment: Alignment.topCenter,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          options: CarouselOptions(
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            },
                            aspectRatio: 1,
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
                        Container(
                          padding: EdgeInsets.only(left: 6),
                          height: 100,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.datam!['imageUrls'].length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                elevation: 2,
                                child: CachedNetworkImage(
                                  alignment: Alignment.topCenter,
                                  fadeInDuration: Duration(seconds: 2),
                                  fit: BoxFit.cover,
                                  width: _current == index ? 100 : 50,
                                  imageUrl: widget.datam!['imageUrls'][index],
                                  errorWidget: (context, url, error) =>
                                      const Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        // Container(
                        //   width: 150,
                        //   child: SizedBox(
                        //     child: ListView(
                        //         scrollDirection: Axis.horizontal,
                        //         shrinkWrap: true,
                        //         children: [
                        //           Icon(
                        //             Icons.do_not_disturb_on_total_silence,
                        //             color: Colors.cyanAccent,
                        //           ),
                        //           Icon(
                        //             Icons.do_not_disturb_on_total_silence,
                        //             color: Colors.cyanAccent,
                        //           ),
                        //           Icon(
                        //             Icons.do_not_disturb_on_total_silence,
                        //             color: Colors.cyanAccent,
                        //           ),
                        //           Icon(
                        //             Icons.do_not_disturb_on_total_silence,
                        //             color: Colors.cyanAccent,
                        //           ),
                        //         ]),
                        //     // child: ListView.builder(
                        //     //     scrollDirection: Axis.horizontal,
                        //     //     itemCount: widget.datam!['imageUrls'].length,
                        //     //     shrinkWrap: true,
                        //     //     itemBuilder: (BuildContext, int) => Icon(
                        //     //         Icons.do_not_disturb_on_total_silence)),
                        //   ),
                        // ),
                        // Center(
                        //     child: Text(
                        //   _current.toString(),
                        //   style: TextStyle(fontSize: 100),
                        // )),
                      ],
                    ),
            ),
            Positioned(
              top: 30,
              left: 10,
              // height: 40,
              // width: 300,
              child: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(widget.docidd.trim())
                    .get(),
                //.where('userID', isEqualTo: userIDD).get(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('...');
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Text('error user');
                    } else if (snapshot.hasData) {
                      if (snapshot.data.data() != null) {
                        return Row(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: Colors.white),
                                    borderRadius: BorderRadius.circular(100)),
                                child: InkWell(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            snapshot.data.data()['avatar'],
                                        height: 30,
                                        width: 30,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    onTap: () async {
                                      await Navigator.push(context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                        return ProfileOthers(
                                            data: snapshot.data.data());

                                        Container(
                                          child: Center(
                                            child: Text(
                                              snapshot.data
                                                  .data()['userDisplayName'],
                                              style: const TextStyle(
                                                  color: Colors.redAccent),
                                            ),
                                          ),
                                        );
                                      }));
                                    })),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                snapshot.data['displayName'],
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Oswald',
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 2, color: Colors.white),
                                  borderRadius: BorderRadius.circular(100)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://source.unsplash.com/random/?city,night',
                                  height: 30,
                                  width: 30,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Text(
                                'NADA',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Oswald',
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      }
                    } else {
                      return const Text('Empty Data');
                    }
                  } else {
                    return Text('State : ${snapshot.connectionState}');
                  }
                },
              ),
            ),
            Positioned(
              top: 140,
              left: 140,
              child: Opacity(
                opacity: isHeartAnimating ? 1 : 0,
                child: HeartAnimationWidget(
                  isAnimating: isHeartAnimating,
                  duration: const Duration(milliseconds: 700),
                  onEnd: () => setState(
                    () => isHeartAnimating = false,
                  ),
                  user: widget.user!.uid,
                  dataid: widget.docid,
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.redAccent,
                    size: 80,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 15,
              child: Text(
                  timeago.format(widget.datam!['createdAt'].toDate(),
                      locale: 'fr'),
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                    fontFamily: 'Oswald',
                  )),
            ),
          ],
        ),
        onDoubleTap: () {
          widget.isLiked
              ? setState(() {
                  isHeartAnimating = false;
                  //widget.isLiked = false;
                })
              : setState(() {
                  isHeartAnimating = true;
                  widget.isLiked = true;
                  FirebaseFirestore.instance
                      .collection('Instalives')
                      .doc(widget.docid)
                      .update({
                    'likes': FieldValue.increment(1),
                    'usersLike': FieldValue.arrayUnion([user!.uid]),
                  });
                });
        },
      );

  List<Widget> imageIndicator(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: currentIndex == index ? Colors.teal.shade400 : Colors.black26,
          shape: BoxShape.circle,
        ),
      );
    });
  }
}

class HeartAnimationWidget extends StatefulWidget {
  final Widget child;
  final bool isAnimating;
  final bool alwaysAnimate;
  final Duration duration;
  final VoidCallback? onEnd;

  final String user;
  final String dataid;

  const HeartAnimationWidget({
    Key? key,
    required this.child,
    required this.isAnimating,
    this.alwaysAnimate = false,
    this.duration = const Duration(milliseconds: 150),
    this.onEnd,
    required this.user,
    required this.dataid,
  }) : super(key: key);

  @override
  State<HeartAnimationWidget> createState() => _HeartAnimationWidgetState();
}

class _HeartAnimationWidgetState extends State<HeartAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();
    final halfDuration = widget.duration.inMilliseconds ~/ 2;
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: halfDuration));
    scale = Tween<double>(begin: 1, end: 1.2).animate(controller);
  }

  @override
  void didUpdateWidget(HeartAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != oldWidget.isAnimating) {
      doAnimation();
    }
  }

  Future doAnimation() async {
    if (widget.isAnimating || widget.alwaysAnimate) {
      await controller.forward();
      await controller.reverse();
      await Future.delayed(const Duration(milliseconds: 400));
      if (widget.onEnd != null) {
        widget.onEnd!();
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(
      scale: scale,
      child: SizedBox(height: 40, width: 33, child: widget.child));
}

Builder TopUsers(List<DocumentSnapshot<Object?>> premiumUsers) {
  return Builder(builder: (context) {
    return Container(
        padding: EdgeInsets.only(left: 6),
        width: MediaQuery.of(context).size.width,
        height: 200,
        child: ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: premiumUsers.length,
          itemBuilder: (BuildContext context, int index) => Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 2,
            child: InkWell(
              child: Stack(
                alignment: Alignment.center,
                fit: StackFit.passthrough,
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
                    child: CachedNetworkImage(
                      width: 80,
                      height: 50,
                      fit: BoxFit.cover,
                      imageUrl: premiumUsers[index]['timeline'],
                      errorWidget: (context, url, error) => const Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ShaderMask(
                              blendMode: BlendMode.srcIn,
                              shaderCallback: (Rect bounds) => LinearGradient(
                                    colors: <Color>[
                                      Colors.red,
                                      Colors.yellowAccent,
                                      Color.fromRGBO(246, 132, 2, 1.0),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ).createShader(bounds),
                              child: Text(
                                premiumUsers[index]['levelUser']
                                    .toString()
                                    .toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              )),
                          Container(
                            width: 70,
                            child: FittedBox(
                              child: RatingBar.builder(
                                initialRating: premiumUsers[index]['stars'],
                                // double.parse(snapshot
                                //     .data!.docs[index]['stars']
                                //     .toString()),
                                ignoreGestures: true,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                },
                              ),
                            ),
                          ),
                          Container(
                            width: 70,
                            height: 25,
                            child: FittedBox(
                              child: Text(
                                premiumUsers[index]['displayName']
                                    .toString()
                                    .toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                            child: Container(
                              width: 50.0,
                              height: 50.0,
                              child: CachedNetworkImage(
                                imageUrl: premiumUsers[index]['avatar'],
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: Colors.white),
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.no_accounts_rounded),
                              ),
                            ),
                          ),
                        ]),
                  )
                ],
              ),
              onTap: () async {
                Map dataUser = premiumUsers[index].data() as Map;
                await Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return ProfileOthers(data: dataUser);
                }));
              },
            ),
          ),
          //     Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Card(
          //     //  margin: const EdgeInsets.all(5),
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(50)),
          //     clipBehavior: Clip.antiAliasWithSaveLayer,
          //     elevation: 2,
          //     child: Stack(
          //       alignment: Alignment.center,
          //       children: [
          //         ShaderMask(
          //           shaderCallback: (rect) {
          //             return const LinearGradient(
          //               begin: Alignment.topCenter,
          //               end: Alignment.bottomLeft,
          //               colors: [
          //                 Colors.transparent,
          //                 Colors.black
          //               ],
          //             ).createShader(Rect.fromLTRB(
          //                 0, 0, rect.width, rect.height));
          //           },
          //           blendMode: BlendMode.darken,
          //           child: Container(
          //             height: 100,
          //             width: 100,
          //             child: CachedNetworkImage(
          //               imageUrl:
          //                   'https://firebasestorage.googleapis.com/v0/b/wahrane-a42eb.appspot.com/o/pub%2Fpub(${i}).jpg?alt=media&token=7fef3fb5-7a06-4df9-9112-88aefa8cb1c1',
          //               fit: BoxFit.cover,
          //             ),
          //           ),
          //         ),
          //         // ClipRRect(
          //         //   // make sure we apply clip it properly
          //         //   child: BackdropFilter(
          //         //     filter: ImageFilter.blur(
          //         //         sigmaX: 3, sigmaY: 3),
          //         //     child: Container(
          //         //       padding: EdgeInsets.all(15),
          //         //       alignment: Alignment.center,
          //         //       color: Colors.grey.withOpacity(0.1),
          //         //     ),
          //         //   ),
          //         // ),
          //         Padding(
          //           padding: const EdgeInsets.only(top: 15.0),
          //           child: Column(
          //             mainAxisAlignment:
          //                 MainAxisAlignment.center,
          //             children: [
          //               UnsplashAvatar(
          //                   UnsplashUrl: users[index].avatar),
          //               // Container(
          //               //   width: 90,
          //               //   child: FittedBox(
          //               //     child: RatingBar.builder(
          //               //       initialRating: double.parse(
          //               //           snapshot
          //               //               .data!
          //               //               .docs[index]
          //               //                   ['userItemsNbr']
          //               //               .toString()),
          //               //       ignoreGestures: true,
          //               //       minRating: 1,
          //               //       direction: Axis.horizontal,
          //               //       allowHalfRating: true,
          //               //       itemCount: 5,
          //               //       itemPadding:
          //               //           EdgeInsets.symmetric(
          //               //               horizontal: 4.0),
          //               //       itemBuilder: (context, _) =>
          //               //           Icon(
          //               //         Icons.star,
          //               //         color: Colors.amber,
          //               //       ),
          //               //       onRatingUpdate: (rating) {
          //               //         print(rating);
          //               //       },
          //               //     ),
          //               //   ),
          //               // ),
          //               FittedBox(
          //                 child: Text(
          //                   users[index]
          //                       .name
          //                       .toString()
          //                       .toUpperCase(),
          //                   style: TextStyle(
          //                       color: Colors.white70,
          //                       fontSize: 20,
          //                       fontWeight: FontWeight.bold),
          //                 ),
          //               ),
          //
          //               users[index].role == 'admin'
          //                   ? ShaderMask(
          //                       blendMode: BlendMode.srcIn,
          //                       shaderCallback: (Rect bounds) =>
          //                           LinearGradient(
          //                             colors: <Color>[
          //                               Colors.red,
          //                               Colors.yellowAccent,
          //                               Color.fromRGBO(
          //                                   246, 132, 2, 1.0),
          //                             ],
          //                             begin: Alignment.topLeft,
          //                             end:
          //                                 Alignment.bottomRight,
          //                           ).createShader(bounds),
          //                       child: Text(
          //                         users[index]
          //                             .role
          //                             .toString()
          //                             .toUpperCase(),
          //                         style: TextStyle(
          //                             color: Colors.white,
          //                             fontSize: 16,
          //                             fontWeight:
          //                                 FontWeight.bold),
          //                       ))
          //                   : Text(
          //                       users[index]
          //                           .role
          //                           .toString()
          //                           .toUpperCase(),
          //                       style: TextStyle(
          //                           color: Colors.white,
          //                           fontSize: 16,
          //                           fontWeight:
          //                               FontWeight.bold),
          //                     ),
          //             ],
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ));
  });
}
