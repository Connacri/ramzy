import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:ramzy/pages/ProvidersPublic.dart';
import 'package:ramzy/pages/homeList.dart';
import 'package:ramzy/pages/itemDetails.dart';
import 'package:timeago/timeago.dart' as timeago;

class NearbyPlacesPage extends StatefulWidget {
  @override
  _NearbyPlacesPageState createState() => _NearbyPlacesPageState();
}

class _NearbyPlacesPageState extends State<NearbyPlacesPage> {
  List<DocumentSnapshot> _places = [];
  late Position? _currentLocation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _getCarouselItems();
  }

  //List<Map<dynamic, dynamic>> itmCarous = [];
  late List<DocumentSnapshot<Object?>> itmCarous = [];

  Future<void> _getCarouselItems() async {
    final carouselQuerySnapshot =
        await FirebaseFirestore.instance.collection('Caroussel').get();

    setState(() {
      itmCarous = carouselQuerySnapshot.docs;
    });
    print(itmCarous.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(_currentLocation!.latitude.toString() +
      //       '  ' +
      //       _currentLocation!.longitude.toString()),
      // ),
      body: _isLoading //_currentLocation == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : //_buildPlacesList(),
          _buildPlacesListyy(),
    );
  }

  Widget _buildPlacesList() {
    return ListView.builder(
      itemCount: _places.length,
      itemBuilder: (BuildContext context, int index) {
        _places.sort((a, b) => _calculateDistance(
              _currentLocation!.latitude,
              _currentLocation!.longitude,
              a['position'].latitude,
              a['position'].longitude,
            ).compareTo(
              _calculateDistance(
                _currentLocation!.latitude,
                _currentLocation!.longitude,
                b['position'].latitude,
                b['position'].longitude,
              ),
            ));
        final place = _places[index];
        final distance = _calculateDistance(
          _currentLocation!.latitude,
          _currentLocation!.longitude,
          place['position'].latitude,
          place['position'].longitude,
        );
        return _buildListItem(place, distance);
      },
    );
  }

  Widget _buildPlacesListyy() {
    var user = FirebaseAuth.instance.currentUser;

    return PaginateFirestore(
      header: SliverToBoxAdapter(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // user == null
            //     ? Padding(
            //         padding: const EdgeInsets.all(28.0),
            //         child: Padding(
            //           padding: const EdgeInsets.symmetric(horizontal: 70.0),
            //           child: Card(
            //             // margin: const EdgeInsets.all(5),
            //             shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(10)),
            //             clipBehavior: Clip.antiAliasWithSaveLayer,
            //             elevation: 5,
            //             child: Stack(
            //               children: [
            //                 ShaderMask(
            //                   shaderCallback: (rect) {
            //                     return const LinearGradient(
            //                       begin: Alignment.topCenter,
            //                       end: Alignment.bottomLeft,
            //                       colors: [
            //                         Colors.transparent,
            //                         Colors.black
            //                       ],
            //                     ).createShader(Rect.fromLTRB(
            //                         0, 0, rect.width, rect.height));
            //                   },
            //                   blendMode: BlendMode.darken,
            //                   child: Container(
            //                     height: 50,
            //                     decoration: BoxDecoration(
            //                       image: DecorationImage(
            //                         image: CachedNetworkImageProvider(
            //                           'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/wall%2Fwall%20(4).jpg?alt=media&token=c5c01dca-4b32-4b9d-88fe-717e976ac2f5',
            //                         ),
            //                         fit: BoxFit.cover,
            //                         alignment: Alignment.topCenter,
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //                 Center(
            //                   child: TextButton(
            //                     onPressed: () {
            //                       Navigator.of(context).push(
            //                           MaterialPageRoute(
            //                               builder: (context) =>
            //                                   AuthPage()));
            //                     },
            //                     child: Text(
            //                       'Google Sign in',
            //                       style: TextStyle(
            //                           fontSize: 20,
            //                           fontWeight: FontWeight.w500,
            //                           color: Colors.white),
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       )
            //     : Container(),
            itmCarous.length == 0
                ? Container()
                : Container(
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
                        viewportFraction: 1, //0.8,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 5),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.easeInToLinear, //.fastOutSlowIn,
                        enlargeCenterPage: true,
                        enlargeFactor: 0, // 0.3,
                        //onPageChanged: callbackFunction,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  ), // Caroussel
          ],
        ),
      ),
      itemsPerPage: 10000,
      shrinkWrap: true,
      isLive: true,
      query: FirebaseFirestore.instance.collection('Products'),
      itemBuilder: (BuildContext, DocumentSnapshot, int) {
        DocumentSnapshot.sort((a, b) => _calculateDistance(
              _currentLocation!.latitude,
              _currentLocation!.longitude,
              a['position'].latitude,
              a['position'].longitude,
            ).compareTo(
              _calculateDistance(
                _currentLocation!.latitude,
                _currentLocation!.longitude,
                b['position'].latitude,
                b['position'].longitude,
              ),
            ));
        final place = DocumentSnapshot[int];

        final distance = _calculateDistance(
          _currentLocation!.latitude,
          _currentLocation!.longitude,
          place['position'].latitude,
          place['position'].longitude,
        );
        return _buildListItem(place, distance);
      },
      //separator: Divider(),
      onEmpty: Center(
          child: Text(
        'No places found.',
        style: TextStyle(fontSize: 35),
      )),
      onError: (error) => Center(child: Text('Error: $error')),
      itemBuilderType: PaginateBuilderType.listView,
    );
  }

  Widget _buildListItem(DocumentSnapshot data, double distance) {
    // return ListTile(
    //   title: Text(place['item']),
    //   subtitle: Text(
    //       '${place['category']}\nDistance: ${distance.toStringAsFixed(2)} km'),
    // );
    var user = FirebaseAuth.instance.currentUser;
    String dataid = data.id;
    var datas = data.data() as Map?;
    final bool isLiked = data['usersLike'].toString().contains(user!.uid);
    return GestureDetector(
      onTap: () {
        updateViewsAndUserList(
          'Products',
          dataid,
          user.uid,
        ).whenComplete(
          () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                SilverdetailItem(data: datas!, idDoc: dataid, isLiked: isLiked),
          )),
        );
      },
      child: buildListTile(data, isLiked, distance),
    );
  }

  Widget buildListTile(
      DocumentSnapshot<Object?> data, bool isLiked, double distance) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
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
                        height: 210,
                        width: MediaQuery.of(context).size.width / 3,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                data['themb'] // data['imageUrls'][0],
                                ),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 210,
                      width: MediaQuery.of(context).size.width / 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                    '${data['type'] ? 'vente' : 'location'}'
                                        .toUpperCase(),
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          intl.NumberFormat.compact()
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
                                                FontAwesomeIcons
                                                    .heartCircleCheck,
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
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    height: 210,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: Container(
                                width: double.infinity,
                                child: Text(
                                  data['item'].toString().toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: isArabic(data['item'])
                                      ? TextAlign.right
                                      : TextAlign.left,
                                  style: isArabic(data['item'])
                                      ? GoogleFonts.cairo(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .headline4,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500)
                                      : TextStyle(
                                          fontSize: 18,
                                        ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Container(
                                child: Text(
                                  data['Description'].toString().toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: isArabic(data['Description'])
                                      ? TextAlign.right
                                      : TextAlign.left,
                                  maxLines: 4,
                                  style: isArabic(data['Description'])
                                      ? GoogleFonts.cairo(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .headline4,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)
                                      : TextStyle(
                                          fontSize: 13,
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Level : ${data['levelItem']}',
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12,
                                      )),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Text(
                                    data['price'] >= 1000000.00
                                        ? intl.NumberFormat.compactCurrency(
                                                symbol: 'DZD ',
                                                decimalDigits: 2)
                                            .format(data['price'])
                                        : intl.NumberFormat.currency(
                                                symbol: 'DZD ',
                                                decimalDigits: 2)
                                            .format(data['price']),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      //backgroundColor: Colors.black45,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      'Distance: ${distance.toStringAsFixed(2)} km',
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12,
                                      )),
                                  Text(
                                      timeago.format(data['createdAt'].toDate(),
                                          locale: 'fr'),
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Card buildCard(
      DocumentSnapshot<Object?> data, bool isLiked, double distance) {
    return Card(
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
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              intl.NumberFormat.compact().format(data['views']),
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
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              intl.NumberFormat.compact().format(data['likes']),
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: isLiked ? Colors.red : Colors.white70,
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
                      padding: const EdgeInsets.symmetric(horizontal: 5),
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
                              ? intl.NumberFormat.compactCurrency(
                                      symbol: 'DZD ', decimalDigits: 2)
                                  .format(data['price'])
                              : intl.NumberFormat.currency(
                                      symbol: 'DZD ', decimalDigits: 2)
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
                          const EdgeInsets.only(left: 5, bottom: 5, right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Distance: ${distance.toStringAsFixed(2)} km',
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                                fontFamily: 'Oswald',
                              )),
                          Text(
                              timeago.format(data['createdAt'].toDate(),
                                  locale: 'fr'),
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                                fontFamily: 'Oswald',
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation = position;
      _isLoading = false;
    });
    _getNearbyPlaces(position);
  }

  _getNearbyPlaces(Position position) async {
    final collectionReference =
        FirebaseFirestore.instance.collection('Products');
    GeoPoint center = GeoPoint(position.latitude, position.longitude);
    QuerySnapshot querySnapshot = await collectionReference
        //.where("position", isGreaterThan: center)
        //.orderBy("position", descending: true)
        // .limit(10)
        .get();
    List<DocumentSnapshot> places = querySnapshot.docs;
    setState(() {
      _places = places;
    });
  }

  double _calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    double distanceInMeters = Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
    return distanceInMeters / 1000.0; // Convert to kilometers
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

  bool isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }
}
