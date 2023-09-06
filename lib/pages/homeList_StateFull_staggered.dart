import 'dart:math';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_mobile_ads/src/ad_containers.dart';
import 'package:infinite_marquee/infinite_marquee.dart';
import 'package:marquee/marquee.dart';
import 'package:ramzy/pages/addAnnonce2.dart';
import 'package:ramzy/pages/addPost_Insta.dart';
import 'package:ramzy/services/ad_mob_service.dart';
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
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class homelist_staggered extends StatefulWidget {
  homelist_staggered({
    Key? key,
    required this.userDoc,
  }) : super(key: key);
  final userDoc;

  @override
  State<homelist_staggered> createState() => _homelist_staggeredState();
}

class _homelist_staggeredState extends State<homelist_staggered> {
// Assuming you have a reference to your Firestore instance
  final CollectionReference locationsRef =
      FirebaseFirestore.instance.collection('Products');

  get query => locationsRef.orderBy('createdAt', descending: true);

  bool isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  @override
  void initState() {
    super.initState();
    // _createBannerAd();
    // _createInterstitialAd();
    // _showInterstitialAd();
  }

  @override
  void dispose() {
    // _showInterstitialAd();
    super.dispose();
  }

  // BannerAd? ad;
  // //InterstitialAd? _interstitialAd;
  //
  // void _createBannerAd() {
  //   ad = BannerAd(
  //     size: AdSize.fullBanner,
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

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: PaginateFirestore(
        itemsPerPage: 10000,
        separator: const EmptySeparator(),
        initialLoader: const InitialLoader(),
        bottomLoader: const BottomLoader(),
        shrinkWrap: true,
        isLive: true,
        itemBuilderType: PaginateBuilderType.gridView,
        query: query,
        gridDelegate: SliverQuiltedGridDelegate(
          crossAxisCount: 4,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          repeatPattern: QuiltedGridRepeatPattern.inverted,
          pattern: [
            QuiltedGridTile(2, 2),
            QuiltedGridTile(1, 1),
            QuiltedGridTile(1, 1),
            QuiltedGridTile(1, 2),
          ],
        ),
        itemBuilder: (BuildContext, DocumentSnapshot, intex) {
          var data = DocumentSnapshot[intex].data() as Map?;
          String dataid = DocumentSnapshot[intex].id;

          final bool isLiked =
              data!['usersLike'].toString().contains(user!.uid);
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 5,
            child: Stack(
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
                          data['themb'],
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(data['item']),
                ),
              ],
            ),
          );

          // return CardFirestore(
          //   user: user,
          //   data: data,
          //   isLiked: isLiked,
          //   dataid: dataid,
          // );
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
                                          : Text(''
                                              // data['modePayment']
                                              //     .toString()
                                              //     .toUpperCase(),
                                              // overflow: TextOverflow.ellipsis,
                                              // style: TextStyle(
                                              //   //backgroundColor: Colors.black45,
                                              //   fontSize: 16,
                                              //   fontWeight: FontWeight.w500,
                                              //   color: Colors.white,
                                              // ),
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
