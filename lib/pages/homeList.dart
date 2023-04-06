import 'dart:math';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:marquee/marquee.dart';
import 'package:ramzy/Oauth/getFCM.dart';
import 'package:ramzy/pages/booking2.dart';

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
import 'package:intl/intl.dart';
import '../2/Hotel/new/globalrooms.dart';
import 'ProfileOthers.dart';
import 'ProvidersPublic.dart';
import 'insta.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../Oauth/AuthPage.dart';
import 'addAnnonce.dart';
import 'itemDetails.dart';

class homeList extends StatelessWidget {
  const homeList({Key? key, required this.userDoc}) : super(key: key);
  final userDoc;

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

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    final uusers = Provider.of<Collection2Data>(context);

    final iitem = Provider.of<Collection1Data>(context);

    final carouss = Provider.of<Collection3Data>(context);

    final alertItems = Provider.of<CollectionAlertData>(context);

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

    var InfoAlert = alertItems.documents.toList();

    List<String> fieldValues =
        InfoAlert.map((map) => map['text'].toString() + '.').toList();
    String marqueesList = fieldValues.join('     ');

    return Scaffold(
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
                              onDoubleTap: () =>
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
                            viewportFraction: 1, //0.8,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 5),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            autoPlayCurve:
                                Curves.easeInToLinear, //.fastOutSlowIn,
                            enlargeCenterPage: true,
                            enlargeFactor: 0, // 0.3,
                            //onPageChanged: callbackFunction,
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                      ), // Caroussel
                InfoAlert.isEmpty
                    ? Container()
                    : Container(
                        height: 20,
                        color: Colors.cyan,
                        child: Marquee(
                          text: marqueesList.toUpperCase(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                          scrollAxis: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          blankSpace: 20.0,
                          velocity: 100.0,
                          // pauseAfterRound: Duration(seconds: 1),
                          startPadding: 10.0,
                          //accelerationDuration: Duration(seconds: 1),
                          accelerationCurve: Curves.linear,
                          //decelerationDuration: Duration(milliseconds: 500),
                          decelerationCurve: Curves.easeOut,
                        ),
                      ),

                userDoc != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 40),
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
                              NumberFormat.currency(
                                      symbol: '', decimalDigits: 2)
                                  .format(userDoc['coins']),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      )
                    : Container(), // wallet
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: GestureDetector(
                    onTap: () => getFcm(),
                    // onTap: () => Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => GranttChartScreen2(),
                    //     //gantt_chart(),
                    //   ),
                    // ),
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
                                    'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/wall%2Fwall%20(1).jpg?alt=media&token=c5c01dca-4b32-4b9d-88fe-717e976ac2f5',
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
                                  'Top',
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
                                  'Dealer',
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
                    itemCount: itm
                        .length, //1, //(iitem.documents.length / 3).truncate(),
                    itemBuilder: (BuildContext context, int index) {
                      var data = itm[index].data() as Map;
                      return GestureDetector(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SilverdetailItem(
                            data: data,
                            idDoc: itm[index].id,
                            isLiked: data['usersLike']
                                .toString()
                                .contains(user!.uid),
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
                              Container(
                                padding: EdgeInsets.only(left: 6),
                                height: 200,
                                // child: ListView.builder(
                                //   shrinkWrap: true,
                                //   physics: BouncingScrollPhysics(),
                                //   scrollDirection: Axis.horizontal,
                                //   itemCount: 12,
                                //   itemBuilder:
                                //       (BuildContext context, int index) {
                                //     return Card(
                                //       //  margin: const EdgeInsets.all(5),
                                //       shape: RoundedRectangleBorder(
                                //           borderRadius:
                                //               BorderRadius.circular(10)),
                                //       clipBehavior: Clip.antiAliasWithSaveLayer,
                                //       elevation: 2,
                                //       child: ShaderMask(
                                //         shaderCallback: (rect) {
                                //           return const LinearGradient(
                                //             begin: Alignment.topCenter,
                                //             end: Alignment.bottomLeft,
                                //             colors: [
                                //               Colors.transparent,
                                //               Colors.black
                                //             ],
                                //           ).createShader(Rect.fromLTRB(
                                //               0, 0, rect.width, rect.height));
                                //         },
                                //         blendMode: BlendMode.darken,
                                //         child: CachedNetworkImage(
                                //           width: 90,
                                //           fit: BoxFit.cover,
                                //           imageUrl:
                                //               'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/carre%2Fcarre%20(${index + 1}).jpg?alt=media&token=68e384f1-bb64-47cf-a245-9f7f12202443',
                                //           errorWidget: (context, url, error) =>
                                //               const Icon(
                                //             Icons.error,
                                //             color: Colors.red,
                                //           ),
                                //         ),
                                //       ),
                                //     );
                                //   },
                                // ),
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
          // footer: SliverToBoxAdapter(
          //   child: Column(
          //     children: [
          //       Container(
          //         height: 200.0,
          //         child: ListView.builder(
          //           shrinkWrap: true,
          //           physics: BouncingScrollPhysics(),
          //           scrollDirection: Axis.horizontal,
          //           itemCount: 16,
          //           itemBuilder: (BuildContext context, int index) {
          //             return UnsplashSlider(
          //               UnsplashUrl:
          //                   'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/mob%2Fmob%20(${index}).jpg?alt=media&token=e307d1db-a16f-42f9-a472-1f3a2f47ee79',
          //             );
          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

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
            if (int % 5 == 0 && int != 0) {
              return Card(
                //  margin: const EdgeInsets.all(5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 5,
                child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.passthrough,
                  children: [
                    Container(
                      // decoration: BoxDecoration(
                      //   image: DecorationImage(
                      //     image: CachedNetworkImageProvider(
                      //       randomPhoto,
                      //     ),
                      //     fit: BoxFit.cover,
                      //     alignment: Alignment.topCenter,
                      //   ),
                      // ),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: randomPhoto,
                      ),
                    ),
                    Center(
                      child: Text(
                        'PubArea',
                        style: TextStyle(
                            shadows: [
                              Shadow(
                                blurRadius: 10.0, // shadow blur
                                color: Colors.black54, // shadow color
                                offset: Offset(
                                    2.0, 2.0), // how much shadow will be shown
                              ),
                            ],
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              );
            }
            final bool isLiked =
                data!['usersLike'].toString().contains(user!.uid);
            return GestureDetector(
              onTap: () {
                updateViewsAndUserList(
                  'Products',
                  dataid,
                  user.uid,
                ).whenComplete(
                  () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SilverdetailItem(
                        data: data, idDoc: dataid, isLiked: isLiked),
                  )),
                );
              },
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
                              data['imageUrls'][0],
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
                                Spacer(),
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
                                          color: isLiked
                                              ? Colors.red
                                              : Colors.white70,
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
                  ],
                ),
              ),
            );
          }),
    );
  }

  void getFcm() async {
    String? fcmKey = await getFcmToken();
    print('fcmKey : $fcmKey');
    // sendNotification(
    //     'daYiNgoeTqGL3tiZJXI4R-:APA91bFidQzX0ml2PmwWJZC_bWaauXQggw1TXQ-7V_j9EfHh0fBktjeY-p264z_hu1ReOXbTHBEjTgG-IhxP1elPtqrL8_IkYShY2zsYx19IQzWa1NC7h-uy9UQa-rVoo_HFX8Gv9OwX',
    //     'Test Titre',
    //     'Test body');
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
