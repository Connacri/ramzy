import 'dart:math';
import 'dart:ui';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ramzy/services/ad_mob_service.dart';

import '../pages/unloggerPublicPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:flutterflow_paginate_firestore/widgets/bottom_loader.dart';
import 'package:flutterflow_paginate_firestore/widgets/empty_display.dart';
import 'package:flutterflow_paginate_firestore/widgets/empty_separator.dart';
import 'package:flutterflow_paginate_firestore/widgets/initial_loader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../Oauth/AuthPage.dart';
import 'ProfileOthers.dart';
import 'package:intl/intl.dart';
import 'ProvidersPublic.dart';
import 'insta.dart';
import 'itemDetails.dart';

class unloggedHomeList extends StatefulWidget {
  const unloggedHomeList({Key? key}) : super(key: key);

  @override
  State<unloggedHomeList> createState() => _unloggedHomeListState();
}

class _unloggedHomeListState extends State<unloggedHomeList> {
  Future<List<QueryDocumentSnapshot>> getItems(String collection) async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection(collection).get();
    return querySnapshot.docs;
  }

  // BannerAd? _banner;
  // InterstitialAd? _interstitialAd;
  @override
  void initState() {
    super.initState();
    // _createBannerAd();
    // _createInterstitialAd();
    // _showInterstitialAd();

    //  MobileAds.instance.initialize();
    // _createInterstitialAd2();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _createInterstitialAd();
    // });
  }

  // void _createBannerAd() {
  //   _banner = BannerAd(
  //     size: AdSize.largeBanner,
  //     adUnitId: AdMobService.bannerAdUnitId!,
  //     listener: AdMobService.bannerListener,
  //     request: const AdRequest(),
  //   )..load();
  // }

  // void _showInterstitialAd() {
  //   if (_interstitialAd != null) {
  //     _interstitialAd!.fullScreenContentCallback =
  //         FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
  //       ad.dispose();
  //       _createInterstitialAd();
  //     }, onAdFailedToShowFullScreenContent: (ad, error) {
  //       ad.dispose();
  //       _createInterstitialAd();
  //     });
  //     _interstitialAd!.show();
  //     _interstitialAd = null;
  //   }
  // }
  //
  // void _createInterstitialAd() {
  //   InterstitialAd.load(
  //       adUnitId: AdMobService.interstatitialAdUnitId!,
  //       request: const AdRequest(),
  //       adLoadCallback: InterstitialAdLoadCallback(
  //           onAdLoaded: (ad) => _interstitialAd = ad,
  //           onAdFailedToLoad: (LoadAdError error) => _interstitialAd = null));
  // }

  // int clickCount = 0;
  // final int interstitialFrequency =
  //     4; // Affichez l'interstitial ad après chaque 4 clics
  //
  // Future<void> _createInterstitialAd2() async {
  //   final adUnitId = AdMobService
  //       .interstatitialAdUnitId!; // Remplacez cet ID par votre ID d'unité d'annonce réelle
  //
  //   // InterstitialAd.load(
  //   //   adUnitId: adUnitId,
  //   //   request: AdRequest(),
  //   //   adLoadCallback: InterstitialAdLoadCallback(
  //   //     onAdLoaded: (InterstitialAd ad) {
  //   //       _interstitialAd = ad;
  //   //     },
  //   //     onAdFailedToLoad: (LoadAdError error) {
  //   //       print('InterstitialAd failed to load: $error');
  //   //     },
  //   //   ),
  //   // );
  // }

  // void handleButtonPress() {
  //   clickCount++;
  //
  //   if (clickCount % interstitialFrequency == 0) {
  //     _interstitialAd?.show();
  //     _createInterstitialAd(); // Chargez un nouvel interstitial ad après l'affichage
  //   }
  //
  //   // Votre code de traitement supplémentaire ici
  //   Navigator.push(context, MaterialPageRoute(builder: (_) {
  //     return AuthPage();
  //   }));
  // }

  @override
  void dispose() {
    // _interstitialAd?.dispose();
    super.dispose();
  }

  // Future<void> _createInterstitialAdcallback() async {
  //   final adUnitId = InterstitialAd
  //       .testAdUnitId; // Remplacez cet ID par votre ID d'unité d'annonce réelle
  //
  //   _interstitialAd = InterstitialAd(
  //     adUnitId: adUnitId,
  //     request: AdRequest(),
  //     listener: AdListener(
  //       onAdLoaded: (Ad ad) {
  //         print('InterstitialAd loaded.');
  //       },
  //       onAdFailedToLoad: (Ad ad, LoadAdError error) {
  //         print('InterstitialAd failed to load: $error');
  //       },
  //       onAdClosed: (Ad ad) {
  //         print('InterstitialAd closed.');
  //         _interstitialAd?.dispose();
  //       },
  //     ),
  //   );
  //
  //   await _interstitialAd!.load();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PaginateFirestore(
          header: SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Caroussel")
                      .snapshots(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: LinearProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      // Handle error
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }

                    final List<DocumentSnapshot> documents =
                        snapshot.data!.docs;
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      child: CarouselSlider.builder(
                        itemCount: documents.length,
                        itemBuilder: (BuildContext context, int index,
                                int pageViewIndex) =>
                            GestureDetector(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => AuthPage())),
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
                                        documents[index]['themb'],
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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        documents[index]['item']
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
                        ),
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
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: GestureDetector(
                    // onTap: handleButtonPress,
                    // //onTap: () => getFcm(),
                    //onTap: _showInterstitialAd,

                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return AuthPage();
                      }));
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
                                    'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/wall%2Fwall%20(2).jpg?alt=media&token=c5c01dca-4b32-4b9d-88fe-717e976ac2f5',
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
                                Text(
                                  'Aya',
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
                                  ' Bismillah',
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
                // ElevatedButton(
                //   child: Text('Go to Another Page'),
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => AnotherPage()),
                //     ).then((value) {
                //       // Lorsque vous revenez à cette page après avoir quitté l'autre page
                //       _interstitialAd?.show();
                //     });
                //   },
                // ),
                // Center(
                //   child: _banner == null
                //       ? Container()
                //       : Container(
                //           height: _banner!.size.height.toDouble(),
                //           width: _banner!.size.width.toDouble(),
                //           child: AdWidget(ad: _banner!)),
                // ),

                // Padding(
                //   padding: const EdgeInsets.fromLTRB(18, 5, 18, 0),
                //   child: Row(
                //     children: [
                //       Text(
                //         'Premium',
                //         textAlign: TextAlign.start,
                //         style: TextStyle(
                //             fontStyle: FontStyle.italic,
                //             fontSize: 20,
                //             fontWeight: FontWeight.bold,
                //             color: Colors.blue),
                //       ),
                //       Text(
                //         'Seller',
                //         textAlign: TextAlign.start,
                //         style: TextStyle(
                //             fontStyle: FontStyle.italic,
                //             fontSize: 20,
                //             fontWeight: FontWeight.bold,
                //             color: Colors.black54),
                //       ),
                //     ],
                //   ),
                // ),
                // FutureBuilder<List<QueryDocumentSnapshot>>(
                //   future: getItems('Users'),
                //   builder: (context, snapshot) {
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return LinearProgressIndicator();
                //     }
                //     final premiumUsers = snapshot.data!;
                //     return Container(
                //         padding: EdgeInsets.only(left: 6),
                //         width: MediaQuery.of(context).size.width,
                //         height: 200,
                //         child: ListView.builder(
                //           shrinkWrap: true,
                //           physics: BouncingScrollPhysics(),
                //           scrollDirection: Axis.horizontal,
                //           itemCount: premiumUsers.length,
                //           itemBuilder: (BuildContext context, int index) =>
                //               Card(
                //             shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(50)),
                //             clipBehavior: Clip.antiAliasWithSaveLayer,
                //             elevation: 2,
                //             child: InkWell(
                //               child: Stack(
                //                 alignment: Alignment.center,
                //                 fit: StackFit.passthrough,
                //                 children: [
                //                   ShaderMask(
                //                     shaderCallback: (rect) {
                //                       return const LinearGradient(
                //                         begin: Alignment.topCenter,
                //                         end: Alignment.bottomLeft,
                //                         colors: [
                //                           Colors.transparent,
                //                           Colors.black
                //                         ],
                //                       ).createShader(Rect.fromLTRB(
                //                           0, 0, rect.width, rect.height));
                //                     },
                //                     blendMode: BlendMode.darken,
                //                     child: CachedNetworkImage(
                //                       width: 80,
                //                       height: 50,
                //                       fit: BoxFit.cover,
                //                       imageUrl: premiumUsers[index]['timeline'],
                //                       errorWidget: (context, url, error) =>
                //                           const Icon(
                //                         Icons.error,
                //                         color: Colors.red,
                //                       ),
                //                     ),
                //                   ),
                //                   Padding(
                //                     padding: const EdgeInsets.only(top: 15.0),
                //                     child: Column(
                //                         mainAxisAlignment:
                //                             MainAxisAlignment.end,
                //                         children: [
                //                           ShaderMask(
                //                               blendMode: BlendMode.srcIn,
                //                               shaderCallback: (Rect bounds) =>
                //                                   LinearGradient(
                //                                     colors: <Color>[
                //                                       Colors.red,
                //                                       Colors.yellowAccent,
                //                                       Color.fromRGBO(
                //                                           246, 132, 2, 1.0),
                //                                     ],
                //                                     begin: Alignment.topLeft,
                //                                     end: Alignment.bottomRight,
                //                                   ).createShader(bounds),
                //                               child: Text(
                //                                 premiumUsers[index]['levelUser']
                //                                     .toString()
                //                                     .toUpperCase(),
                //                                 style: TextStyle(
                //                                     color: Colors.white,
                //                                     fontSize: 20,
                //                                     fontWeight:
                //                                         FontWeight.bold),
                //                               )),
                //                           Container(
                //                             width: 70,
                //                             child: FittedBox(
                //                               child: RatingBar.builder(
                //                                 initialRating:
                //                                     premiumUsers[index]
                //                                         ['stars'],
                //                                 // double.parse(snapshot
                //                                 //     .data!.docs[index]['stars']
                //                                 //     .toString()),
                //                                 ignoreGestures: true,
                //                                 minRating: 1,
                //                                 direction: Axis.horizontal,
                //                                 allowHalfRating: true,
                //                                 itemCount: 5,
                //                                 itemPadding:
                //                                     EdgeInsets.symmetric(
                //                                         horizontal: 4.0),
                //                                 itemBuilder: (context, _) =>
                //                                     Icon(
                //                                   Icons.star,
                //                                   color: Colors.amber,
                //                                 ),
                //                                 onRatingUpdate: (rating) {
                //                                   print(rating);
                //                                 },
                //                               ),
                //                             ),
                //                           ),
                //                           Container(
                //                             width: 70,
                //                             height: 25,
                //                             child: FittedBox(
                //                               child: Text(
                //                                 premiumUsers[index]
                //                                         ['displayName']
                //                                     .toString()
                //                                     .toUpperCase(),
                //                                 style: TextStyle(
                //                                     color: Colors.white70,
                //                                     fontSize: 20,
                //                                     fontWeight:
                //                                         FontWeight.bold),
                //                               ),
                //                             ),
                //                           ),
                //                           Padding(
                //                             padding: EdgeInsets.fromLTRB(
                //                                 0, 10, 0, 20),
                //                             child: Container(
                //                               width: 50.0,
                //                               height: 50.0,
                //                               child: CachedNetworkImage(
                //                                 imageUrl: premiumUsers[index]
                //                                     ['avatar'],
                //                                 imageBuilder:
                //                                     (context, imageProvider) =>
                //                                         Container(
                //                                   decoration: BoxDecoration(
                //                                     border: Border.all(
                //                                         width: 2,
                //                                         color: Colors.white),
                //                                     shape: BoxShape.circle,
                //                                     image: DecorationImage(
                //                                         image: imageProvider,
                //                                         fit: BoxFit.cover),
                //                                   ),
                //                                 ),
                //                                 errorWidget: (context, url,
                //                                         error) =>
                //                                     Icon(Icons
                //                                         .no_accounts_rounded),
                //                               ),
                //                             ),
                //                           ),
                //                         ]),
                //                   )
                //                 ],
                //               ),
                //               // onTap: () async {
                //               //   Map dataUser =
                //               //       premiumUsers[index].data() as Map;
                //               //   await Navigator.push(context, MaterialPageRoute(
                //               //       builder: (BuildContext context) {
                //               //     return ProfileOthers(data: dataUser);
                //               //   }));
                //               // },
                //             ),
                //           ),
                //           //     Padding(
                //           //   padding: const EdgeInsets.all(8.0),
                //           //   child: Card(
                //           //     //  margin: const EdgeInsets.all(5),
                //           //     shape: RoundedRectangleBorder(
                //           //         borderRadius: BorderRadius.circular(50)),
                //           //     clipBehavior: Clip.antiAliasWithSaveLayer,
                //           //     elevation: 2,
                //           //     child: Stack(
                //           //       alignment: Alignment.center,
                //           //       children: [
                //           //         ShaderMask(
                //           //           shaderCallback: (rect) {
                //           //             return const LinearGradient(
                //           //               begin: Alignment.topCenter,
                //           //               end: Alignment.bottomLeft,
                //           //               colors: [
                //           //                 Colors.transparent,
                //           //                 Colors.black
                //           //               ],
                //           //             ).createShader(Rect.fromLTRB(
                //           //                 0, 0, rect.width, rect.height));
                //           //           },
                //           //           blendMode: BlendMode.darken,
                //           //           child: Container(
                //           //             height: 100,
                //           //             width: 100,
                //           //             child: CachedNetworkImage(
                //           //               imageUrl:
                //           //                   'https://firebasestorage.googleapis.com/v0/b/wahrane-a42eb.appspot.com/o/pub%2Fpub(${i}).jpg?alt=media&token=7fef3fb5-7a06-4df9-9112-88aefa8cb1c1',
                //           //               fit: BoxFit.cover,
                //           //             ),
                //           //           ),
                //           //         ),
                //           //         // ClipRRect(
                //           //         //   // make sure we apply clip it properly
                //           //         //   child: BackdropFilter(
                //           //         //     filter: ImageFilter.blur(
                //           //         //         sigmaX: 3, sigmaY: 3),
                //           //         //     child: Container(
                //           //         //       padding: EdgeInsets.all(15),
                //           //         //       alignment: Alignment.center,
                //           //         //       color: Colors.grey.withOpacity(0.1),
                //           //         //     ),
                //           //         //   ),
                //           //         // ),
                //           //         Padding(
                //           //           padding: const EdgeInsets.only(top: 15.0),
                //           //           child: Column(
                //           //             mainAxisAlignment:
                //           //                 MainAxisAlignment.center,
                //           //             children: [
                //           //               UnsplashAvatar(
                //           //                   UnsplashUrl: users[index].avatar),
                //           //               // Container(
                //           //               //   width: 90,
                //           //               //   child: FittedBox(
                //           //               //     child: RatingBar.builder(
                //           //               //       initialRating: double.parse(
                //           //               //           snapshot
                //           //               //               .data!
                //           //               //               .docs[index]
                //           //               //                   ['userItemsNbr']
                //           //               //               .toString()),
                //           //               //       ignoreGestures: true,
                //           //               //       minRating: 1,
                //           //               //       direction: Axis.horizontal,
                //           //               //       allowHalfRating: true,
                //           //               //       itemCount: 5,
                //           //               //       itemPadding:
                //           //               //           EdgeInsets.symmetric(
                //           //               //               horizontal: 4.0),
                //           //               //       itemBuilder: (context, _) =>
                //           //               //           Icon(
                //           //               //         Icons.star,
                //           //               //         color: Colors.amber,
                //           //               //       ),
                //           //               //       onRatingUpdate: (rating) {
                //           //               //         print(rating);
                //           //               //       },
                //           //               //     ),
                //           //               //   ),
                //           //               // ),
                //           //               FittedBox(
                //           //                 child: Text(
                //           //                   users[index]
                //           //                       .name
                //           //                       .toString()
                //           //                       .toUpperCase(),
                //           //                   style: TextStyle(
                //           //                       color: Colors.white70,
                //           //                       fontSize: 20,
                //           //                       fontWeight: FontWeight.bold),
                //           //                 ),
                //           //               ),
                //           //
                //           //               users[index].role == 'admin'
                //           //                   ? ShaderMask(
                //           //                       blendMode: BlendMode.srcIn,
                //           //                       shaderCallback: (Rect bounds) =>
                //           //                           LinearGradient(
                //           //                             colors: <Color>[
                //           //                               Colors.red,
                //           //                               Colors.yellowAccent,
                //           //                               Color.fromRGBO(
                //           //                                   246, 132, 2, 1.0),
                //           //                             ],
                //           //                             begin: Alignment.topLeft,
                //           //                             end:
                //           //                                 Alignment.bottomRight,
                //           //                           ).createShader(bounds),
                //           //                       child: Text(
                //           //                         users[index]
                //           //                             .role
                //           //                             .toString()
                //           //                             .toUpperCase(),
                //           //                         style: TextStyle(
                //           //                             color: Colors.white,
                //           //                             fontSize: 16,
                //           //                             fontWeight:
                //           //                                 FontWeight.bold),
                //           //                       ))
                //           //                   : Text(
                //           //                       users[index]
                //           //                           .role
                //           //                           .toString()
                //           //                           .toUpperCase(),
                //           //                       style: TextStyle(
                //           //                           color: Colors.white,
                //           //                           fontSize: 16,
                //           //                           fontWeight:
                //           //                               FontWeight.bold),
                //           //                     ),
                //           //             ],
                //           //           ),
                //           //         ),
                //           //       ],
                //           //     ),
                //           //   ),
                //           // ),
                //         ));
                //   },
                // ),
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
                FutureBuilder<List<QueryDocumentSnapshot>>(
                  future: getItems('Products'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return LinearProgressIndicator();
                    }
                    final itm = snapshot.data!;
                    return Container(
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
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => AuthPage())),
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
                    );
                  },
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
                                    'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/wall%2Fwall%20(2).jpg?alt=media&token=c5c01dca-4b32-4b9d-88fe-717e976ac2f5',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Affaire',
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
                                        'Jahde',
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
                              FutureBuilder<List<QueryDocumentSnapshot>>(
                                future: getItems('Products'),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  }
                                  final itmm = snapshot.data!;
                                  return Container(
                                    padding: EdgeInsets.only(left: 6),
                                    height: 200,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: itmm.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        var data = itmm[index].data() as Map;
                                        return GestureDetector(
                                          onTap: () => Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      AuthPage())),
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
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  children: [
                                                    ShaderMask(
                                                      shaderCallback: (rect) {
                                                        return const LinearGradient(
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomLeft,
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
                                                      blendMode:
                                                          BlendMode.darken,
                                                      child: CachedNetworkImage(
                                                        alignment:
                                                            Alignment.topCenter,
                                                        fadeInDuration:
                                                            Duration(
                                                                seconds: 2),
                                                        fit: BoxFit.cover,
                                                        width: 100,
                                                        height: 130,
                                                        imageUrl: itmm[index]
                                                            ['themb'],
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                          Icons.error,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 4.0),
                                                      child: itmm[index]
                                                                  ['price'] >=
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
                                                              NumberFormat.currency(
                                                                      symbol:
                                                                          'DZD ',
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
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 4.0),
                                                    child: Text(
                                                      itmm[index]['item'],
                                                      // iitem.documents[index]['item'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 100,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 4.0),
                                                    child: Text(
                                                      '${itmm[index]['category']}-${itmm[index]['levelItem']}',
                                                      //   '${iitem.documents[index]['category']}  ${iitem.documents[index]['levelItem']}',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 100,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 4.0),
                                                    child: Text(
                                                      itmm[index]['createdAt']
                                                          //iitem.documents[index]['createdAt']
                                                          .toDate()
                                                          .toString(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 9),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
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
                    'Les Articles Les Plus Recent Par Pertinance. ',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
          footer: SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
            ),
          ),
          itemsPerPage: 10000,
          onEmpty: const EmptyDisplay(),
          separator: const EmptySeparator(),
          initialLoader: const InitialLoader(),
          bottomLoader: const BottomLoader(),
          shrinkWrap: true,
          isLive: true,
          itemBuilderType: PaginateBuilderType.gridView,
          query: FirebaseFirestore.instance
              .collection('Products')
              .orderBy('createdAt', descending: true),
          itemBuilder: (BuildContext, DocumentSnapshot, int) {
            var data = DocumentSnapshot[int].data() as Map?;
            String dataid = DocumentSnapshot[int].id;
            Random random = new Random();
            var randomNumber = random.nextInt(27);
            String randomPhoto =
                'https://firebasestorage.googleapis.com/v0/b/wahrane-a42eb.appspot.com/o/pub%2Fpub(${randomNumber}).jpg?alt=media&token=5d9e0764-23f6-4b18-95f4-e085736659cc';
            // if (int % 5 == 0 && int != 0) {
            //   return GestureDetector(
            //     onTap: () => Navigator.of(context)
            //         .push(MaterialPageRoute(builder: (context) => AuthPage())),
            //     child: Card(
            //       //  margin: const EdgeInsets.all(5),
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(10)),
            //       clipBehavior: Clip.antiAliasWithSaveLayer,
            //       elevation: 5,
            //       child: Stack(
            //         alignment: Alignment.center,
            //         fit: StackFit.passthrough,
            //         children: [
            //           Container(
            //             // decoration: BoxDecoration(
            //             //   image: DecorationImage(
            //             //     image: CachedNetworkImageProvider(
            //             //       randomPhoto,
            //             //     ),
            //             //     fit: BoxFit.cover,
            //             //     alignment: Alignment.topCenter,
            //             //   ),
            //             // ),
            //             child: CachedNetworkImage(
            //               fit: BoxFit.cover,
            //               imageUrl: randomPhoto,
            //             ),
            //           ),
            //           Center(
            //             child: Text(
            //               'PubArea',
            //               style: TextStyle(
            //                   shadows: [
            //                     Shadow(
            //                       blurRadius: 10.0, // shadow blur
            //                       color: Colors.black54, // shadow color
            //                       offset: Offset(2.0,
            //                           2.0), // how much shadow will be shown
            //                     ),
            //                   ],
            //                   fontSize: 40,
            //                   color: Colors.white,
            //                   fontWeight: FontWeight.bold),
            //             ),
            //           )
            //         ],
            //       ),
            //     ),
            //   );
            // }

            return GestureDetector(
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AuthPage())),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
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
                        ).createShader(
                            Rect.fromLTRB(0, 0, rect.width, rect.height));
                      },
                      blendMode: BlendMode.darken,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              data!['imageUrls'][0],
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
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
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
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        NumberFormat.compact()
                                            .format(data['likes']),
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
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  data['item'].toString().toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 0.0),
                                child: Center(
                                  child: Text(
                                    data['price'] >= 1000000.00
                                        ? NumberFormat.compactCurrency(
                                                symbol: 'DZD ',
                                                decimalDigits: 2)
                                            .format(data['price'])
                                        : NumberFormat.currency(
                                                symbol: 'DZD ',
                                                decimalDigits: 2)
                                            .format(data['price']),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        //backgroundColor: Colors.black45,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontFamily: 'oswald'),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, bottom: 5),
                                child: Text(
                                    timeago.format(data['createdAt'].toDate(),
                                        locale: 'fr'),
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                      fontFamily: 'Oswald',
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // GridTile(
                    //   header: Container(
                    //     decoration: BoxDecoration(
                    //         color: Colors.black54,
                    //         borderRadius: BorderRadius.circular(8)),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Container(
                    //           decoration: BoxDecoration(
                    //               color: Colors.black54,
                    //               borderRadius: BorderRadius.circular(8)),
                    //           padding: const EdgeInsets.all(5.0),
                    //           child: Text(
                    //             data['category'],
                    //             overflow: TextOverflow.fade,
                    //             textAlign: TextAlign.center,
                    //             style: TextStyle(
                    //                 color: Colors.white,
                    //                 fontSize: 11,
                    //                 fontWeight: FontWeight.w500),
                    //           ),
                    //         ),
                    //         Padding(
                    //           padding: const EdgeInsets.symmetric(horizontal: 8),
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             crossAxisAlignment: CrossAxisAlignment.center,
                    //             children: [
                    //               Text(
                    //                 NumberFormat.compact().format(data['likes']),
                    //                 textAlign: TextAlign.end,
                    //                 style: TextStyle(
                    //                   color: Colors.white70,
                    //                   fontSize: 12,
                    //                 ),
                    //               ),
                    //               SizedBox(
                    //                 width: 3,
                    //               ),
                    //               Icon(
                    //                 FontAwesomeIcons.eye,
                    //                 size: 11,
                    //                 color: Colors.white70,
                    //               )
                    //             ],
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    //   footer: Column(
                    //     children: [
                    //       Padding(
                    //         padding: const EdgeInsets.symmetric(horizontal: 5),
                    //         child: Text(
                    //           data['item'],
                    //           overflow: TextOverflow.ellipsis,
                    //           style: TextStyle(
                    //               color: Colors.white70,
                    //               fontSize: 12,
                    //               fontWeight: FontWeight.w500),
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.only(bottom: 8.0),
                    //         child: Center(
                    //           child: Text(
                    //             data['price'] >= 1000000.00
                    //                 ? NumberFormat.compactCurrency(
                    //                         symbol: 'DZD ', decimalDigits: 2)
                    //                     .format(data['price'])
                    //                 : NumberFormat.currency(
                    //                         symbol: 'DZD ', decimalDigits: 2)
                    //                     .format(data['price']),
                    //             overflow: TextOverflow.ellipsis,
                    //             style: TextStyle(
                    //                 //backgroundColor: Colors.black45,
                    //                 fontSize: 16,
                    //                 fontWeight: FontWeight.w500,
                    //                 color: Colors.white,
                    //                 fontFamily: 'oswald'),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    //   child: Center(
                    //     child: Container(),
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
