import 'dart:math';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:flutterflow_paginate_firestore/widgets/bottom_loader.dart';
import 'package:flutterflow_paginate_firestore/widgets/empty_display.dart';
import 'package:flutterflow_paginate_firestore/widgets/empty_separator.dart';
import 'package:flutterflow_paginate_firestore/widgets/initial_loader.dart';
import 'package:intl/intl.dart' as intl;
import '../Oauth/AuthPage.dart';
import '../pages/itemDetails.dart';

class publicLoggerPage extends StatelessWidget {
  publicLoggerPage({
    Key? key,
    required this.datta,
  }) : super(key: key);

  final DocumentSnapshot<Object?>? datta;
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   actions: [
        //     IconButton(
        //         onPressed: () async {
        //           FirebaseAuth.instance.signOut();
        //           final provider =
        //               Provider.of<googleSignInProvider>(context, listen: false);
        //           await provider.logouta();
        //           // Navigator.of(context).pop();
        //           // Navigator.pop(context, true);
        //         },
        //         icon: Icon(FontAwesomeIcons.signOut)),
        //     IconButton(
        //         onPressed: () => Navigator.of(context).push(MaterialPageRoute(
        //               builder: (context) => stepper_widget(),
        //             )),
        //         icon: Icon(FontAwesomeIcons.add)),
        //   ],
        //   automaticallyImplyLeading: true,
        // ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: PaginateFirestore(
                header: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      user == null
                          ? Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 70.0),
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
                      // ShaderMask(
                      //   shaderCallback: (rect) {
                      //     return const LinearGradient(
                      //       begin: Alignment.topCenter,
                      //       end: Alignment.bottomLeft,
                      //       colors: [Colors.transparent, Colors.black],
                      //     ).createShader(
                      //         Rect.fromLTRB(0, 0, rect.width, rect.height));
                      //   },
                      //   blendMode: BlendMode.darken,
                      //   child: Container(
                      //     padding: EdgeInsets.symmetric(vertical: 8),
                      //     height: 210,
                      //     child: YoutubePlayerBuilder(
                      //         player: YoutubePlayer(
                      //           controller: ControllerYoutube,
                      //           showVideoProgressIndicator: true,
                      //           aspectRatio: 16 / 9,
                      //           // thumbnail: CachedNetworkImage(
                      //           //   fit: BoxFit.cover,
                      //           //   imageUrl:
                      //           //       'https://images.unsplash.com/photo-1533112050809-b85548ba39c4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=871&q=80',
                      //           // ),
                      //           onReady: () => debugPrint(
                      //               'Readyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy'),
                      //         ),
                      //         builder: (context, player) => ListView(
                      //               children: [
                      //                 player,
                      //               ],
                      //             )),
                      //   ),
                      // ),
                      Container(
                        height: 200,
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('Users')
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text('');
                              } else {
                                return //Text(snapshot.data!.size.toString());
                                    Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CarouselSlider.builder(
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (BuildContext context,
                                            int index, int pageViewIndex) =>
                                        Card(
                                      // margin: const EdgeInsets.all(5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      elevation: 5,
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
                                              ).createShader(Rect.fromLTRB(0, 0,
                                                  rect.width, rect.height));
                                            },
                                            blendMode: BlendMode.darken,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image:
                                                      CachedNetworkImageProvider(
                                                    'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/wall%2Fwall%20(${index}).jpg?alt=media&token=c5c01dca-4b32-4b9d-88fe-717e976ac2f5',
                                                  ),
                                                  fit: BoxFit.cover,
                                                  alignment:
                                                      Alignment.topCenter,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 250,
                                            width: 100,
                                            // decoration: BoxDecoration(
                                            //   image: DecorationImage(
                                            //     image: NetworkImage(
                                            //       'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/carre%2Fcarre%20(${inte}).jpg?alt=media&token=fbcb6223-39c8-4ed7-9b62-13acac60fe94',
                                            //     ),
                                            //     fit: BoxFit.cover,
                                            //   ),
                                            // ),
                                            child: ClipRRect(
                                              // make sure we apply clip it properly
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                    sigmaX: 3, sigmaY: 3),
                                                child: Container(
                                                  padding: EdgeInsets.all(15),
                                                  alignment: Alignment.center,
                                                  color: Colors.grey
                                                      .withOpacity(0.1),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                UnsplashAvatar(
                                                    UnsplashUrl: snapshot.data!
                                                        .docs[index]['avatar']),
                                                // Container(
                                                //   width: 90,
                                                //   child: FittedBox(
                                                //     child: RatingBar.builder(
                                                //       initialRating: double.parse(
                                                //           snapshot
                                                //               .data!
                                                //               .docs[index]
                                                //                   ['userItemsNbr']
                                                //               .toString()),
                                                //       ignoreGestures: true,
                                                //       minRating: 1,
                                                //       direction: Axis.horizontal,
                                                //       allowHalfRating: true,
                                                //       itemCount: 5,
                                                //       itemPadding:
                                                //           EdgeInsets.symmetric(
                                                //               horizontal: 4.0),
                                                //       itemBuilder: (context, _) =>
                                                //           Icon(
                                                //         Icons.star,
                                                //         color: Colors.amber,
                                                //       ),
                                                //       onRatingUpdate: (rating) {
                                                //         print(rating);
                                                //       },
                                                //     ),
                                                //   ),
                                                // ),
                                                Container(
                                                  width: 80,
                                                  height: 40,
                                                  child: FittedBox(
                                                    child: Text(
                                                      snapshot
                                                          .data!
                                                          .docs[index]
                                                              ['displayName']
                                                          .toString()
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 28,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                snapshot.data!.docs[index]
                                                            ['role'] ==
                                                        'admin'
                                                    ? ShaderMask(
                                                        blendMode:
                                                            BlendMode.srcIn,
                                                        shaderCallback: (Rect
                                                                bounds) =>
                                                            LinearGradient(
                                                              colors: <Color>[
                                                                Colors.red,
                                                                Colors
                                                                    .yellowAccent,
                                                                Color.fromRGBO(
                                                                    246,
                                                                    132,
                                                                    2,
                                                                    1.0),
                                                              ],
                                                              begin: Alignment
                                                                  .topLeft,
                                                              end: Alignment
                                                                  .bottomRight,
                                                            ).createShader(
                                                                bounds),
                                                        child: Text(
                                                          snapshot
                                                              .data!
                                                              .docs[index]
                                                                  ['role']
                                                              .toString()
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ))
                                                    : Text(
                                                        snapshot.data!
                                                            .docs[index]['role']
                                                            .toString()
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    options: CarouselOptions(
                                      //height: 400,
                                      aspectRatio: 16 / 9,
                                      viewportFraction: 0.8,
                                      initialPage: 0,
                                      enableInfiniteScroll: true,
                                      reverse: false,
                                      autoPlay: true,
                                      autoPlayInterval: Duration(seconds: 3),
                                      autoPlayAnimationDuration:
                                          Duration(milliseconds: 800),
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      enlargeCenterPage: true,
                                      enlargeFactor: 0.3,
                                      //onPageChanged: callbackFunction,
                                      scrollDirection: Axis.horizontal,
                                    ),
                                  ),
                                );
                              }
                            }),
                      ),
                      Container(
                        height: 200.0,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: 12,
                          itemBuilder: (BuildContext context, int index) {
                            return UnsplashSlider(
                              UnsplashUrl:
                                  'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/carre%2Fcarre%20(${index + 1}).jpg?alt=media&token=68e384f1-bb64-47cf-a245-9f7f12202443',
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                footer: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Container(
                        height: 200.0,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: 16,
                          itemBuilder: (BuildContext context, int index) {
                            return UnsplashSlider(
                              UnsplashUrl:
                                  'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/mob%2Fmob%20(${index}).jpg?alt=media&token=e307d1db-a16f-42f9-a472-1f3a2f47ee79',
                            );
                          },
                        ),
                      ),
                    ],
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
                  var randomNumber = random.nextInt(31);
                  String randomPhoto =
                      'https://firebasestorage.googleapis.com/v0/b/wahrane-a42eb.appspot.com/o/pub%2Fpub(${randomNumber}).jpg?alt=media&token=65512912-41f1-4c47-9529-b2124b18cd8f';
                  if (int % 5 == 0 && int != 0) {
                    return Card(
                      margin: const EdgeInsets.all(5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              randomPhoto,
                            ),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      ),
                    );
                  }
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SilverdetailItem(
                        data: data,
                        idDoc: dataid,
                      ),
                    )),

                    child: Card(
                      margin: const EdgeInsets.all(5),
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
                          GridTile(
                            header: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                            footer: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    data['item'],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Center(
                                    child: Text(
                                      data['price'] >= 1000000.00
                                          ? NumberFormat.compactCurrency(
                                                  symbol: 'DZ ',
                                                  decimalDigits: 2)
                                              .format(data['price'])
                                          : NumberFormat.currency(
                                                  symbol: 'DZ ',
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
                              ],
                            ),
                            child: Center(
                              child: Text(''),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // child: GridTile(
                    //   footer: Text(
                    //     data!['item'],
                    //     overflow: TextOverflow.ellipsis,
                    //     style: TextStyle(
                    //         color: Colors.white,
                    //         fontSize: 12,
                    //         fontWeight: FontWeight.w500),
                    //   ),
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       image: DecorationImage(
                    //         image: CachedNetworkImageProvider(
                    //           data!['imageUrls'][0],
                    //         ),
                    //         fit: BoxFit.cover,
                    //         alignment: Alignment.topCenter,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}

class UnsplashSlider extends StatelessWidget {
  const UnsplashSlider({
    Key? key,
    required this.UnsplashUrl,
  }) : super(key: key);

  final String UnsplashUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => UnsplashSlider(
          UnsplashUrl: UnsplashUrl,
        ),
      )),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        semanticContainer: true,
        child: ShaderMask(
          shaderCallback: (rect) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomLeft,
              colors: [Colors.transparent, Colors.black],
            ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
          },
          blendMode: BlendMode.darken,
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: UnsplashUrl,
            errorWidget: (context, url, error) => const Icon(
              Icons.error,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}

class UnsplashAvatar extends StatelessWidget {
  const UnsplashAvatar({
    Key? key,
    required this.UnsplashUrl,
  }) : super(key: key);

  final String UnsplashUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 40.0,
        height: 40.0,
        child: CachedNetworkImage(
          imageUrl: UnsplashUrl,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
          errorWidget: (context, url, error) => Icon(Icons.no_accounts_rounded),
        ),
      ),
    );
  }
}

//
// '😀 😃 😄 😁 😆 😅 😂 🤣 🥲 ☺️ 😊 😇 🙂 🙃 😉 😌 😍 🥰 😘 😗 😙 😚 😋 😛 😝 😜 🤪 🤨',
//
// '🍅 🍑 🍒 🏄‍♂️ 🐻 💖 📙 ',
