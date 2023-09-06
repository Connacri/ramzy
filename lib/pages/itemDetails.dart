import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:open_location_picker/open_location_picker.dart';
import 'package:ramzy/pages/EditItem.dart';
import 'package:ramzy/pages/UsersListScreen.dart';
import 'package:ramzy/pages/homeList_StateFull.dart';
import 'package:ramzy/pages/insta.dart';
import 'package:ramzy/pages/itemDetails.dart';
import 'package:ramzy/services/ad_mob_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart' as intl;
import 'package:timeago/timeago.dart' as timeago;
import 'ProfileOthers.dart';

class SilverdetailItem extends StatefulWidget {
  SilverdetailItem({
    Key? key,
    required this.data,
    required this.idDoc,
    required this.isLiked,
  }) : super(key: key);

  final Map data;
  final String idDoc;
  bool isLiked;

  @override
  State<SilverdetailItem> createState() => _SilverdetailItemState();
}

class _SilverdetailItemState extends State<SilverdetailItem> {
  final CollectionReference docProducts =
      FirebaseFirestore.instance.collection("Products");
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  // Stream<Map<String, dynamic>> getPositionStream() {
  //   // Exemple d'utilisation d'un StreamController pour émettre les positions
  //   StreamController<Map<String, dynamic>> controller = StreamController();
  //
  //   // Exemple de récupération des nouvelles positions à partir d'une source de données
  //   // Vous pouvez remplacer cette logique par votre propre méthode de récupération des positions
  //
  //   // Simulation d'un flux de positions mises à jour
  //   Timer.periodic(Duration(seconds: 5), (timer) {
  //     // Ici, vous pouvez récupérer les nouvelles positions depuis votre source de données (par exemple, Firestore)
  //     // et émettre les données via le contrôleur du flux
  //
  //     // Exemple de nouvelles positions
  //     double newLatitude = 37.7749;
  //     double newLongitude = -122.4194;
  //
  //     // Création d'une nouvelle map contenant les positions mises à jour
  //     Map<String, dynamic> updatedData = {
  //       'position': {
  //         'latitude': newLatitude,
  //         'longitude': newLongitude,
  //       },
  //     };
  //
  //     // Émission des nouvelles positions via le flux
  //     controller.add(updatedData);
  //   });
  //
  //   // Retourne le flux du contrôleur
  //   return controller.stream;
  // }
  //BannerAd? _banner;
  // InterstitialAd? _interstitialAd;
  @override
  void initState() {
    super.initState();
    // _createBannerAd();
    // _createInterstitialAd();
    // _showInterstitialAd();

    // MobileAds.instance.initialize();
    //_createInterstitialAd2();
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

  int clickCount = 0;
  final int interstitialFrequency =
      4; // Affichez l'interstitial ad après chaque 4 clics

  // Future<void> _createInterstitialAd2() async {
  //   final adUnitId = AdMobService
  //       .interstatitialAdUnitId!; // Remplacez cet ID par votre ID d'unité d'annonce réelle
  //
  //   InterstitialAd.load(
  //     adUnitId: adUnitId,
  //     request: AdRequest(),
  //     adLoadCallback: InterstitialAdLoadCallback(
  //       onAdLoaded: (InterstitialAd ad) {
  //         _interstitialAd = ad;
  //       },
  //       onAdFailedToLoad: (LoadAdError error) {
  //         print('InterstitialAd failed to load: $error');
  //       },
  //     ),
  //   );
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
  //     return Container();
  //   }));
  // }

  @override
  void dispose() {
    // _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('fr', timeago.FrMessages());
    final String? userEmail = FirebaseAuth.instance.currentUser!.email;

    LatLng? point = widget.data['position'] != null
        ? LatLng(
            widget.data['position'].latitude, widget.data['position'].longitude)
        : LatLng(0, 0);
    return Scaffold(
      body: CustomScrollView(
        shrinkWrap: true,
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 220.0,
            floating: true,
            pinned: true,
            snap: true,
            elevation: 50,
            backgroundColor: Colors.black38,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  widget.data['category'] == null
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Icon(
                            PropertyIconMapper.mapItemTypeToIcon(
                                widget.data['category']),
                            color: Colors.white70,
                            size: 18,
                          ),
                        ),
                  widget.data['category'] == null
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            widget.data['category'] ?? ' ',
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                  Spacer(),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    child: Text(
                      '${widget.data['views']} Vue',
                      style: TextStyle(fontSize: 8, color: Colors.white70),
                    ),
                  ),
                ],
              ),
              background: ShaderMask(
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
                  imageUrl: widget.data['themb'],
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                      timeago.format(widget.data['createdAt'].toDate(),
                          locale: 'fr'),
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                      )),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Text(
                        intl.NumberFormat.compact(locale: 'fr_IN')
                            .format(widget.data['likes']),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: widget.isLiked ? Colors.red : Colors.blueGrey,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      HeartAnimationWidget(
                        alwaysAnimate: true,
                        isAnimating: widget.isLiked,
                        dataid: widget.idDoc,
                        user: userId,
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
                                      .collection('Products')
                                      .doc(widget.idDoc)
                                      .update({
                                    'likes': FieldValue.increment(-1),
                                    'usersLike':
                                        FieldValue.arrayRemove([userId]),
                                  });
                                  setState(
                                      () => widget.isLiked = !widget.isLiked);
                                }
                              : () async {
                                  await FirebaseFirestore.instance
                                      .collection('Products')
                                      .doc(widget.idDoc)
                                      .update({
                                    'likes': FieldValue.increment(1),
                                    'usersLike':
                                        FieldValue.arrayUnion([userId]),
                                  });
                                  setState(
                                      () => widget.isLiked = !widget.isLiked);
                                },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // SliverToBoxAdapter(
          //   child: Center(
          //     child: _banner == null
          //         ? Container()
          //         : Container(
          //             height: _banner!.size.height.toDouble(),
          //             width: _banner!.size.width.toDouble(),
          //             child: AdWidget(ad: _banner!)),
          //   ),
          // ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 10, 20), //.all(20.0),
              child: FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(widget.data['userID'])
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Icon(Icons.error);
                  }

                  if (snapshot.hasData && !snapshot.data!.exists) {
                    return Icon(Icons.account_box);
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> dataU =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return InkWell(
                      onTap: () async {
                        //  Map dataUser = data as Map;
                        await Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return ProfileOthers(data: dataU);
                        }));
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: CachedNetworkImage(
                              imageUrl: dataU['avatar'],
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            width: 140,
                            child: Text(
                              // 'lqsihdiqhsd lkqsdklhqlskdh lSHDKLHDSLKSHCKL',
                              "${dataU['displayName']}", // - ${data['email']}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Expanded(
                              child: SizedBox(
                            width: 50,
                          )),
                          IconButton(
                              icon: Icon(
                                Icons.call,
                                color: Colors.green,
                              ),
                              onPressed: () async {
                                final Uri launchUrlR = Uri(
                                    scheme: 'Tel',
                                    path: '+213${widget.data['phone']}');
                                if (await canLaunchUrl(launchUrlR)) {
                                  await launchUrl(launchUrlR);
                                } else {
                                  print('This Call Cant execute');
                                }
                              }),
                          IconButton(
                              icon: Icon(
                                FontAwesomeIcons.whatsapp,
                                color: Colors.green,
                              ),
                              onPressed: () async {
                                //var phone = 00971566129156;
                                String msg = 'Hi this is Oran';
                                var whatsappUrl =
                                    "whatsapp://send?phone=+213${widget.data['phone']}" +
                                        "&text=${Uri.encodeComponent(msg)}";

                                final Uri launchUrlRW = Uri(
                                    scheme: 'Tel',
                                    path: "+213${widget.data['phone']}" +
                                        "&text=${Uri.encodeComponent(msg)}");
                                try {
                                  launch(whatsappUrl);
                                } catch (e) {
                                  //To handle error and display error message
                                  print("Unable to open whatsapp");
                                }
                              }),
                          // IconButton(
                          //   icon: Icon(
                          //     FontAwesomeIcons.facebookMessenger,
                          //     color: Colors.blueAccent,
                          //   ),
                          //   onPressed: () async {
                          //     await Navigator.of(context).push(
                          //       MaterialPageRoute(
                          //         builder: (context) => ChatListScreen(),
                          //         //     ChatScreen(
                          //         //   id: dataU['id'],
                          //         // ),
                          //       ),
                          //     );
                          //   },
                          // ),
                        ],
                      ),
                    );
                  }

                  return Text("loading");
                },
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                widget.data['type'] == null || widget.data['type'] == ''
                    ? Container()
                    : Padding(
                        padding: new EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                            '${widget.data['type'] == 'vente' ? 'A Vendre' : 'A Louer'}'
                                .toUpperCase(),
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                widget.data['item'] == null
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: Container(
                          width: double.infinity,
                          child: Text(
                            widget.data['item'].toString().toUpperCase(),
                            overflow: TextOverflow.ellipsis,
                            textAlign: isArabic(widget.data['item'])
                                ? TextAlign.right
                                : TextAlign.left,
                            style: isArabic(widget.data['item'])
                                ? GoogleFonts.cairo(
                                    textStyle:
                                        Theme.of(context).textTheme.headline4,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500)
                                : TextStyle(
                                    fontSize: 18,
                                  ),
                          ),
                        ),
                      ),
                // widget.data['price'] == null
                //     ? Container()
                //     : widget.data['price'] <= 0
                //         ? Container()
                //         : Align(
                //             alignment: Alignment.centerRight,
                //             child: Padding(
                //               padding:
                //                   new EdgeInsets.symmetric(horizontal: 20.0),
                //               child: new Text(
                //                 'Prix : ' +
                //                     NumberFormat.currency(
                //                             symbol: 'DZD ', decimalDigits: 2)
                //                         .format(widget.data['price']),
                //                 overflow: TextOverflow.ellipsis,
                //                 style: TextStyle(
                //                   //backgroundColor: Colors.black45,
                //                   fontSize: 18,
                //                   fontWeight: FontWeight.w500,
                //                   color: Colors.green,
                //                 ),
                //               ),
                //             ),
                //           ),
                widget.data['price'] == 0
                    ? Text('')
                    : widget.data['price'] == null
                        ? Text('')
                        : Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  widget.data['price'] >= 1000000.00
                                      ? intl.NumberFormat.compactCurrency(
                                              symbol: 'Da ', decimalDigits: 2)
                                          .format(widget.data['price'])
                                      : intl.NumberFormat.currency(
                                              symbol: 'Da ', decimalDigits: 2)
                                          .format(widget.data['price']),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    //backgroundColor: Colors.black45,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green,
                                  ),
                                ),
                                widget.data['type'] == 'location'
                                    ? widget.data['modePayment'] != null &&
                                            widget.data['modePayment'] != ''
                                        ? Text(
                                            '/' +
                                                widget.data['modePayment']
                                                    .toString()
                                                    .toUpperCase(),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              //backgroundColor: Colors.black45,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.green,
                                            ),
                                          )
                                        : Text('')
                                    : Text(
                                        widget.data['modePayment']
                                            .toString()
                                            .toUpperCase(),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          //backgroundColor: Colors.black45,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.green,
                                        ),
                                      ),
                              ],
                            ),
                          ),

                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  height: 150.0,
                  child: Center(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.data['imageUrls'].length,
                      itemBuilder: (BuildContext context, int index) {
                        return UnsplashD(
                          UnsplashUrl: widget.data['imageUrls'][index],
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  child: widget.data['position'] == null
                      ? Container()
                      : Stack(
                          children: [
                            SizedBox(
                                height: 100,
                                width: MediaQuery.of(context).size.width,
                                child: FlutterMap(
                                  options: MapOptions(
                                    center: LatLng(
                                        widget.data['position'].latitude,
                                        widget.data['position'].longitude),
                                    zoom: 16.0,
                                  ),
                                  layers: [
                                    TileLayerOptions(
                                      minZoom: 1,
                                      maxZoom: 18,
                                      backgroundColor: Colors.black,
                                      urlTemplate:
                                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                      subdomains: ['a', 'b', 'c'],
                                    ),
                                    MarkerLayerOptions(markers: [
                                      Marker(
                                          width: 100,
                                          height: 100,
                                          point: point,
                                          builder: (ctx) => Icon(
                                                Icons.location_on,
                                                color: Colors.red,
                                              ))
                                    ])
                                  ],
                                )),
                          ],
                        ),
                ),
                // StreamBuilder<Map<String, dynamic>>(
                //   stream: positionStream,
                //   builder: (context, snapshot) {
                //     if (snapshot.hasData) {
                //       final double latitude =
                //           snapshot.data!['position'].latitude;
                //       final double longitude =
                //           snapshot.data!['position'].longitude;
                //       final LatLng position = LatLng(latitude, longitude);
                //       return FlutterMap(
                //         options: MapOptions(
                //           center: position,
                //           zoom: 16.0,
                //         ),
                //         layers: [
                //           TileLayerOptions(
                //             minZoom: 1,
                //             maxZoom: 18,
                //             backgroundColor: Colors.black,
                //             urlTemplate:
                //                 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                //             subdomains: ['a', 'b', 'c'],
                //           ),
                //           MarkerLayerOptions(
                //             markers: [
                //               Marker(
                //                 width: 100,
                //                 height: 100,
                //                 point: position,
                //                 builder: (ctx) => Icon(
                //                   Icons.location_on,
                //                   color: Colors.red,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ],
                //       );
                //     } else if (snapshot.hasError) {
                //       return Text('Erreur : ${snapshot.error}');
                //     } else {
                //       return CircularProgressIndicator();
                //     }
                //   },
                // ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                  child: widget.data['position'] == null
                      ? Container()
                      : ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo),
                          onPressed: () async {
                            final String url =
                                'https://www.google.com/maps/search/?api=1&query=${widget.data['position'].latitude},${widget.data['position'].longitude}';

                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          icon: Icon(
                            FontAwesomeIcons.mapLocation,
                            size: 16.0,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Itinéraire Sur GoogleMap',
                            style: TextStyle(color: Colors.white),
                          )),
                ),
                Padding(
                  padding: new EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    child: Text(
                      widget.data['Description'].toString().capitalize(),
                      textAlign: isArabic(widget.data['Description'])
                          ? TextAlign.right
                          : TextAlign.left,
                      style: isArabic(widget.data['Description'])
                          ? GoogleFonts.cairo(
                              textStyle: Theme.of(context).textTheme.headline4,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 2)
                          : TextStyle(
                              fontSize: 13,
                              height: 1.5,
                            ),
                    ),
                  ),
                ),
                widget.data['origine'] == null
                    ? Container()
                    : Padding(
                        padding: new EdgeInsets.all(20.0),
                        child: Text(
                          'Made In  ${widget.data['origine'] ?? 'Algeria'}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
              ],
            ),
          ),
          userEmail == 'forslog@gmail.com'
              ? SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(100, 10, 100, 10),
                        child: TextButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          onPressed: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditItem(
                                        itemId: widget.idDoc,
                                        itemData: widget.data,
                                      ))),
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Modifier',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          bool confirmed = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirmation'),
                                content: Text(
                                    'Êtes-vous sûr de vouloir supprimer cet élément ?'),
                                actions: [
                                  TextButton(
                                    child: Text('Annuler'),
                                    onPressed: () {
                                      Navigator.of(context).pop(
                                          false); // Retourne false pour indiquer l'annulation
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Supprimer'),
                                    onPressed: () {
                                      Navigator.of(context).pop(
                                          true); // Retourne true pour indiquer la confirmation
                                    },
                                  ),
                                ],
                              );
                            },
                          );

                          if (confirmed ?? false) {
                            // L'utilisateur a confirmé la suppression, procédez à la suppression de l'élément
                            // Get the document from Firestore
                            docProducts
                                .doc(widget.idDoc)
                                .get()
                                .then((documentSnapshot) async {
                              print(userId);
                              print(widget.data['userID']);
                              if (documentSnapshot.exists) {
                                // Document exists, check if the field is equal to user ID
                                var data = documentSnapshot;
                                final String fieldValue = data['userID'];
                                if (fieldValue == userId) {
                                  await docProducts
                                      .doc(widget.idDoc)
                                      .delete()
                                      .whenComplete(() {
                                    Navigator.of(context)
                                        .pop(); // Ferme la boîte de dialogue de confirmation
                                    // Navigator.of(context)
                                    //     .pop(); // Ferme la page actuelle
                                  });
                                }
                              } else {
                                print(
                                    'tu n\'est pas le proprietaire du document');
                              }
                            }).catchError((error) {
                              // Handle the error
                            });
                          }
                        },
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                )
              : SliverToBoxAdapter(
                  child: Container(),
                ),
          widget.data['userID'] != userId ||
                  widget.data['category'] == null ||
                  widget.data['category'] == '' ||
                  widget.data['category'].isEmpty
              ? SliverToBoxAdapter(
                  child: Container(),
                )
              : SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(100, 10, 100, 10),
                    child: TextButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      onPressed: () =>
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditItem(
                                    itemId: widget.idDoc,
                                    itemData: widget.data,
                                  ))),
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Modifier',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
          widget.data['userID'] == userId
              ? SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(100, 10, 100, 10),
                    child:
                        // TextButton(
                        //   onPressed: () async {
                        //     // Get the document from Firestore
                        //     docProducts
                        //         .doc(widget.idDoc)
                        //         .get()
                        //         .then((documentSnapshot) async {
                        //       print(userId);
                        //       print(widget.data['userID']);
                        //       if (documentSnapshot.exists) {
                        //         // Document exists, check if the field is equal to user ID
                        //         var data = documentSnapshot;
                        //         final String fieldValue = data['userID'];
                        //         if (fieldValue == userId) {
                        //           await docProducts
                        //               .doc(widget.idDoc)
                        //               .delete()
                        //               .whenComplete(
                        //                   () => Navigator.of(context).pop());
                        //         }
                        //       } else {
                        //         print('tu n\'est pas le proprietaire du document');
                        //       }
                        //     }).catchError((error) {
                        //       // Handle the error
                        //     });
                        //   },
                        //   child: Text(
                        //     'Delete',
                        //     style: TextStyle(color: Colors.red),
                        //   ),
                        // ),
                        TextButton(
                      onPressed: () async {
                        bool confirmed = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirmation'),
                              content: Text(
                                  'Êtes-vous sûr de vouloir supprimer cet élément ?'),
                              actions: [
                                TextButton(
                                  child: Text('Annuler'),
                                  onPressed: () {
                                    Navigator.of(context).pop(
                                        false); // Retourne false pour indiquer l'annulation
                                  },
                                ),
                                TextButton(
                                  child: Text('Supprimer'),
                                  onPressed: () {
                                    Navigator.of(context).pop(
                                        true); // Retourne true pour indiquer la confirmation
                                  },
                                ),
                              ],
                            );
                          },
                        );

                        if (confirmed ?? false) {
                          // L'utilisateur a confirmé la suppression, procédez à la suppression de l'élément
                          // Get the document from Firestore
                          docProducts
                              .doc(widget.idDoc)
                              .get()
                              .then((documentSnapshot) async {
                            print(userId);
                            print(widget.data['userID']);
                            if (documentSnapshot.exists) {
                              // Document exists, check if the field is equal to user ID
                              var data = documentSnapshot;
                              final String fieldValue = data['userID'];
                              if (fieldValue == userId) {
                                await docProducts
                                    .doc(widget.idDoc)
                                    .delete()
                                    .whenComplete(() {
                                  Navigator.of(context)
                                      .pop(); // Ferme la boîte de dialogue de confirmation
                                  // Navigator.of(context)
                                  //     .pop(); // Ferme la page actuelle
                                });
                              }
                            } else {
                              print(
                                  'tu n\'est pas le proprietaire du document');
                            }
                          }).catchError((error) {
                            // Handle the error
                          });
                        }
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                )
              : SliverToBoxAdapter(
                  child: Container(),
                ),
          // SliverToBoxAdapter(
          //     child: Center(
          //   child: Text(userEmail.toString()),
          // )),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
            ),
          ),
        ],
      ),
    );
  }

  bool isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }
}

class UnsplashD extends StatelessWidget {
  const UnsplashD({
    Key? key,
    required this.UnsplashUrl,
  }) : super(key: key);

  final String UnsplashUrl;

  @override
  Widget build(BuildContext context) {
    late TransformationController controller;

    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (_) => ImageViewerDetail(
                  UnsplashUrl: UnsplashUrl,
                ));
      },
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

class ImageViewerDetail extends StatefulWidget {
  ImageViewerDetail({
    Key? key,
    required this.UnsplashUrl,
  }) : super(key: key);

  final String UnsplashUrl;

  @override
  State<ImageViewerDetail> createState() => _ImageViewerDetailState();
}

class _ImageViewerDetailState extends State<ImageViewerDetail> {
  late TransformationController controller;
  TapDownDetails? tapDownDetail;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TransformationController();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent, foregroundColor: Colors.white),
      backgroundColor: Colors.black87,
      body: GestureDetector(
        onDoubleTapDown: (detail) => tapDownDetail = detail,
        onDoubleTap: () {
          final position = tapDownDetail!.localPosition;
          final double scale = 1;
          final x = -position.dx * (scale - 1);
          final y = position.dy * (scale - 1);
          final zoomed = Matrix4.identity()
            ..translate(x, y)
            ..scale(scale);
          final value =
              controller.value.isIdentity() ? zoomed : Matrix4.identity();
          controller.value = value;
        },
        child: InteractiveViewer(
          transformationController: controller,
          child: Center(
            child: FittedBox(
              fit: BoxFit.cover,
              //child: ShaderMask(
              // shaderCallback: (rect) {
              //   return const LinearGradient(
              //     begin: Alignment.topCenter,
              //     end: Alignment.bottomLeft,
              //     colors: [Colors.transparent, Colors.black],
              //   ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
              // },
              // blendMode: BlendMode.darken,
              child: CachedNetworkImage(
                fadeInCurve: Curves.easeIn,
                filterQuality: FilterQuality.high,
                // width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.width,
                //fit: BoxFit.contain,
                imageUrl: widget.UnsplashUrl,
                errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                  color: Colors.red,
                ),
              ),
              //),
            ),
          ),
        ),
      ),
    );
  }
}
