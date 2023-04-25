import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:open_location_picker/open_location_picker.dart';
import 'package:ramzy/pages/homeList.dart';
import 'package:ramzy/pages/insta.dart';
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

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('fr', timeago.FrMessages());

    LatLng? point = widget.data['position'] != null
        ? LatLng(
            widget.data['position'].latitude, widget.data['position'].longitude)
        : LatLng(0, 0);
    return Scaffold(
      body: CustomScrollView(
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
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Icon(
                      PropertyIconMapper.mapItemTypeToIcon(
                          widget.data['category']),
                      color: Colors.white70,
                      size: 18,
                    ),
                  ),
                  Padding(
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
                      style: TextStyle(fontSize: 8),
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
                // Row(
                //   children: [
                //     Text(
                //       widget.data['likes'].toString(),
                //       style: TextStyle(
                //           color: widget.isLiked ? Colors.red : Colors.blueGrey),
                //     ),
                //     IconButton(
                //       icon: widget.isLiked
                //           ? const Icon(
                //               Icons.favorite,
                //               color: Colors.red,
                //             )
                //           : const Icon(Icons.favorite_border_outlined,
                //               color: Colors.blueGrey),
                //       onPressed: widget.isLiked
                //           ? () async {
                //               await FirebaseFirestore.instance
                //                   .collection('Products')
                //                   .doc(widget.idDoc)
                //                   .update({
                //                 'likes': FieldValue.increment(-1),
                //                 'usersLike': FieldValue.arrayRemove([userId]),
                //               });
                //               setState(() => widget.isLiked = !widget.isLiked);
                //             }
                //           : () async {
                //               await FirebaseFirestore.instance
                //                   .collection('Products')
                //                   .doc(widget.idDoc)
                //                   .update({
                //                 'likes': FieldValue.increment(1),
                //                 'usersLike': FieldValue.arrayUnion([userId]),
                //               });
                //               setState(() {
                //                 widget.isLiked = !widget.isLiked;
                //               });
                //             },
                //     ),
                //   ],
                // ),
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
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
                          Text(
                            "${dataU['displayName']}", // - ${data['email']}",
                            style: TextStyle(fontSize: 14),
                          ),
                          Expanded(
                              child: SizedBox(
                            width: 50,
                          )),
                          // Text(
                          //   "+213${data['phone']}", // - ${data['email']}",
                          //   style: TextStyle(fontSize: 14),
                          // ),
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
                            '${widget.data['type'] ? 'A Vendre' : 'A Louer'}'
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
                // widget.data['levelItem'] == null ||
                //         widget.data['levelItem'] == ''
                //     ? Container()
                //     : Padding(
                //         padding: new EdgeInsets.symmetric(horizontal: 15.0),
                //         child: Text(
                //           'Level : ' +
                //               widget.data['levelItem'].toString().toUpperCase(),
                //           style: TextStyle(
                //             color: Colors.red,
                //             fontSize: 16,
                //             fontWeight: FontWeight.w500,
                //           ),
                //         ),
                //       ),
                widget.data['price'] == null
                    ? Container()
                    : Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: new EdgeInsets.symmetric(horizontal: 20.0),
                          child: new Text(
                            'Prix : ' +
                                NumberFormat.currency(
                                        symbol: 'DZD ', decimalDigits: 2)
                                    .format(widget.data['price']),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              //backgroundColor: Colors.black45,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.green,
                            ),
                          ),
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
                            UnsplashUrl: widget.data['imageUrls'][index]);
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
          widget.data['userID'] == userId
              ? SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(100, 20, 100, 60),
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () async {
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
                                  .whenComplete(
                                      () => Navigator.of(context).pop());
                            }
                          } else {
                            print('tu n\'est pas le proprietaire du document');
                          }
                        }).catchError((error) {
                          // Handle the error
                        });
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              : SliverToBoxAdapter(
                  child: Container(),
                ),
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

// class SilverdetailItem extends StatelessWidget {
//   SilverdetailItem({
//     Key? key,
//     required this.data,
//     required this.idDoc,
//     required this.isLiked,
//   }) : super(key: key);
//
// //  final String UnsplashUrl;
//   final Map data;
//   final String idDoc;
//   bool isLiked;
//   // final int intex;
//   final CollectionReference docProducts =
//   FirebaseFirestore.instance.collection("Products");
//   final String userId = FirebaseAuth.instance.currentUser!.uid;
//
//   @override
//   Widget build(BuildContext context) {
//     timeago.setLocaleMessages('fr', timeago.FrMessages());
//
//     LatLng? point = data['position'] != null
//         ? LatLng(data['position'].latitude, data['position'].longitude)
//         : LatLng(0, 0);
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: <Widget>[
//           SliverAppBar(
//             expandedHeight: 220.0,
//             floating: true,
//             pinned: true,
//             snap: true,
//             elevation: 50,
//             backgroundColor: Colors.black38,
//             flexibleSpace: FlexibleSpaceBar(
//               centerTitle: true,
//               title: Row(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 15),
//                     child: Text(
//                       data['category'] ?? ' ',
//                       overflow: TextOverflow.fade,
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500),
//                     ),
//                   ),
//                   Spacer(),
//                   Padding(
//                     padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
//                     child: Text(
//                       '${data['views']} Vue',
//                       style: TextStyle(fontSize: 8),
//                     ),
//                   ),
//                 ],
//               ),
//               background: ShaderMask(
//                 shaderCallback: (rect) {
//                   return const LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomLeft,
//                     colors: [Colors.transparent, Colors.black],
//                   ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
//                 },
//                 blendMode: BlendMode.darken,
//                 child: CachedNetworkImage(
//                   fit: BoxFit.cover,
//                   imageUrl: data['themb'],
//                   errorWidget: (context, url, error) => const Icon(
//                     Icons.error,
//                     color: Colors.red,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 18),
//                   child: Text(
//                       timeago.format(data['createdAt'].toDate(), locale: 'fr'),
//                       textAlign: TextAlign.start,
//                       style: const TextStyle(
//                         color: Colors.black54,
//                         fontWeight: FontWeight.normal,
//                         fontSize: 12,
//                       )),
//                 ),
//                 Spacer(),
//                 StatefulBuilder(
//                     builder: (BuildContext context, StateSetter setState) {
//                       return Row(
//                         children: [
//                           Text(
//                             data['likes'].toString(),
//                             style: TextStyle(
//                                 color: isLiked ? Colors.red : Colors.blueGrey),
//                           ),
//                           IconButton(
//                             icon: isLiked
//                                 ? const Icon(
//                               Icons.favorite,
//                               color: Colors.red,
//                             )
//                                 : const Icon(Icons.favorite_border_outlined,
//                                 color: Colors.blueGrey),
//                             onPressed: isLiked
//                                 ? () async {
//                               await FirebaseFirestore.instance
//                                   .collection('Products')
//                                   .doc(idDoc)
//                                   .update({
//                                 'likes': FieldValue.increment(-1),
//                                 'usersLike': FieldValue.arrayRemove([userId]),
//                               });
//                               setState(() => isLiked = !isLiked);
//                             }
//                                 : () async {
//                               await FirebaseFirestore.instance
//                                   .collection('Products')
//                                   .doc(idDoc)
//                                   .update({
//                                 'likes': FieldValue.increment(1),
//                                 'usersLike': FieldValue.arrayUnion([userId]),
//                               });
//                               setState(() {
//                                 isLiked = !isLiked;
//                               });
//                             },
//                           ),
//                         ],
//                       );
//                     }),
//               ],
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: FutureBuilder<DocumentSnapshot>(
//                 future: FirebaseFirestore.instance
//                     .collection('Users')
//                     .doc(data['userID'])
//                     .get(),
//                 builder: (BuildContext context,
//                     AsyncSnapshot<DocumentSnapshot> snapshot) {
//                   if (snapshot.hasError) {
//                     return Icon(Icons.error);
//                   }
//
//                   if (snapshot.hasData && !snapshot.data!.exists) {
//                     return Icon(Icons.account_box);
//                   }
//
//                   if (snapshot.connectionState == ConnectionState.done) {
//                     Map<String, dynamic> dataU =
//                     snapshot.data!.data() as Map<String, dynamic>;
//                     return InkWell(
//                       onTap: () async {
//                         //  Map dataUser = data as Map;
//                         await Navigator.push(context,
//                             MaterialPageRoute(builder: (BuildContext context) {
//                               return ProfileOthers(data: dataU);
//                             }));
//                       },
//                       child: Row(
//                         children: [
//                           Container(
//                             width: 40.0,
//                             height: 40.0,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                             ),
//                             child: CachedNetworkImage(
//                               imageUrl: dataU['avatar'],
//                               imageBuilder: (context, imageProvider) =>
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       image: DecorationImage(
//                                           image: imageProvider, fit: BoxFit.cover),
//                                     ),
//                                   ),
//                               errorWidget: (context, url, error) =>
//                                   Icon(Icons.error),
//                             ),
//                           ),
//                           SizedBox(
//                             width: 5,
//                           ),
//                           Text(
//                             "${dataU['displayName']}", // - ${data['email']}",
//                             style: TextStyle(fontSize: 14),
//                           ),
//                           Expanded(
//                               child: SizedBox(
//                                 width: 50,
//                               )),
//                           // Text(
//                           //   "+213${data['phone']}", // - ${data['email']}",
//                           //   style: TextStyle(fontSize: 14),
//                           // ),
//                           IconButton(
//                               icon: Icon(
//                                 Icons.call,
//                                 color: Colors.green,
//                               ),
//                               onPressed: () async {
//                                 final Uri launchUrlR = Uri(
//                                     scheme: 'Tel',
//                                     path: '+213${data['phone']}');
//                                 if (await canLaunchUrl(launchUrlR)) {
//                                   await launchUrl(launchUrlR);
//                                 } else {
//                                   print('This Call Cant execute');
//                                 }
//                               }),
//                           IconButton(
//                               icon: Icon(
//                                 FontAwesomeIcons.whatsapp,
//                                 color: Colors.green,
//                               ),
//                               onPressed: () async {
//                                 //var phone = 00971566129156;
//                                 String msg = 'Hello Oran';
//                                 var whatsappUrl =
//                                     "whatsapp://send?phone=+213${data['phone']}" +
//                                         "&text=${Uri.encodeComponent(msg)}";
//
//                                 final Uri launchUrlRW = Uri(
//                                     scheme: 'Tel',
//                                     path: "+213${data['phone']}" +
//                                         "&text=${Uri.encodeComponent(msg)}");
//                                 try {
//                                   launch(whatsappUrl);
//                                 } catch (e) {
//                                   //To handle error and display error message
//                                   print("Unable to open whatsapp");
//                                 }
//                               }),
//                         ],
//                       ),
//                     );
//                   }
//
//                   return Text("loading");
//                 },
//               ),
//             ),
//           ),
//           SliverList(
//             delegate: SliverChildListDelegate(
//               [
//                 data['item'] == null
//                     ? Container()
//                     : Padding(
//                   padding: new EdgeInsets.symmetric(horizontal: 20.0),
//                   child: new Text(
//                     data['item'].toString().toUpperCase(),
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//                 data['price'] == null
//                     ? Container()
//                     : Align(
//                   alignment: Alignment.centerLeft,
//                   child: Padding(
//                     padding: new EdgeInsets.symmetric(horizontal: 20.0),
//                     child: new Text(
//                       'Prix : ' +
//                           NumberFormat.currency(
//                               symbol: 'DZD ', decimalDigits: 2)
//                               .format(data['price']),
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         //backgroundColor: Colors.black45,
//                         fontSize: 18,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.green,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
//                   height: 150.0,
//                   child: Center(
//                     child: ListView.builder(
//                       shrinkWrap: true,
//                       physics: BouncingScrollPhysics(),
//                       scrollDirection: Axis.horizontal,
//                       itemCount: data['imageUrls'].length,
//                       itemBuilder: (BuildContext context, int index) {
//                         return UnsplashSlider(
//                             UnsplashUrl: data['imageUrls'][index]);
//                       },
//                     ),
//                   ),
//                 ),
//                 Container(
//                   child: data['position'] == null
//                       ? Container()
//                       : Stack(
//                     children: [
//                       SizedBox(
//                           height: 100,
//                           width: MediaQuery.of(context).size.width,
//                           child: FlutterMap(
//                             options: MapOptions(
//                               center: LatLng(data['position'].latitude,
//                                   data['position'].longitude),
//                               zoom: 16.0,
//                             ),
//                             layers: [
//                               TileLayerOptions(
//                                 minZoom: 1,
//                                 maxZoom: 18,
//                                 backgroundColor: Colors.black,
//                                 urlTemplate:
//                                 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//                                 subdomains: ['a', 'b', 'c'],
//                               ),
//                               MarkerLayerOptions(markers: [
//                                 Marker(
//                                     width: 100,
//                                     height: 100,
//                                     point: point,
//                                     builder: (ctx) => Icon(
//                                       Icons.location_on,
//                                       color: Colors.red,
//                                     ))
//                               ])
//                             ],
//                           )),
//                       // Container(
//                       //   height: 100,
//                       //   width: MediaQuery.of(context).size.width,
//                       //   child: InkWell(
//                       //     onTap: () async {
//                       //       final String url =
//                       //           'https://www.google.com/maps/search/?api=1&query=${data['position'].latitude},${data['position'].longitude}';
//                       //
//                       //       if (await canLaunch(url)) {
//                       //         await launch(url);
//                       //       } else {
//                       //         throw 'Could not launch $url';
//                       //       }
//                       //     },
//                       //     // onTap: () async {
//                       //     //   final Uri gMapsUrl = Uri(
//                       //     //       scheme: 'Map',
//                       //     //       path:
//                       //     //           //'https://www.google.com/maps/dir/api=1&destination=${data['position'].latitude},${data['position'].longitude}&travelmode=driving');
//                       //     //           'https://www.google.com/maps/search/?api=1&query=${data['position'].latitude},${data['position'].longitude}');
//                       //     //   if (Platform.isAndroid &&
//                       //     //       await canLaunchUrl(gMapsUrl)) {
//                       //     //     await launchUrl(gMapsUrl,
//                       //     //         mode: LaunchMode.externalApplication);
//                       //     //   }
//                       //     //
//                       //     //   // final Uri launchUrlR = Uri(
//                       //     //   //     scheme: 'Tel', path: '+213${data['phone']}');
//                       //     //   // if (await canLaunchUrl(gMapsUrl)) {
//                       //     //   //   await launchUrl(gMapsUrl);
//                       //     //   //   print('tap map secces');
//                       //     //   // } else {
//                       //     //   //   print('This Call Cant execute');
//                       //     //   // }
//                       //     // },
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 ),
//                 // MapOSM
//                 Padding(
//                   padding:
//                   const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
//                   child: data['position'] == null
//                       ? Container()
//                       : ElevatedButton.icon(
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.indigo),
//                       onPressed: () async {
//                         final String url =
//                             'https://www.google.com/maps/search/?api=1&query=${data['position'].latitude},${data['position'].longitude}';
//
//                         if (await canLaunch(url)) {
//                           await launch(url);
//                         } else {
//                           throw 'Could not launch $url';
//                         }
//                       },
//                       icon: Icon(
//                         FontAwesomeIcons.mapLocation,
//                         size: 16.0,
//                         color: Colors.white,
//                       ),
//                       label: Text(
//                         'Itinéraire Sur GoogleMap',
//                         style: TextStyle(color: Colors.white),
//                       )),
//                 ),
//
//                 data['levelItem'] == null || data['levelItem'] == ''
//                     ? Container()
//                     : Center(
//                   child: Padding(
//                     padding: new EdgeInsets.all(20.0),
//                     child: Text(
//                       'Niveau : ' +
//                           data['levelItem'].toString().toUpperCase(),
//                       style: TextStyle(
//                         color: Colors.red,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: new EdgeInsets.symmetric(horizontal: 20.0),
//                   child: Text(
//                     'Description : ' + data['Description'],
//                     style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.black54),
//                   ),
//                 ),
//                 data['origine'] == null
//                     ? Container()
//                     : Padding(
//                   padding: new EdgeInsets.all(20.0),
//                   child: Text(
//                     'Made In  ${data['origine'] ?? 'Algeria'}',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//                 // Padding(
//                 //     padding: new EdgeInsets.symmetric(horizontal: 20.0),
//                 //     child: new Text(
//                 //         'Le Lorem Ipsum est simplement du faux texte employé dans la composition et la mise en page avant impression. Le Lorem Ipsum est le faux texte standard de l\'imprimerie depuis les années 1500, quand un imprimeur anonyme assembla ensemble des morceaux de texte pour réaliser un livre spécimen de polices de texte. Il n\'a pas fait que survivre cinq siècles, mais s\'est aussi adapté à la bureautique informatique, sans que son contenu n\'en soit modifié. Il a été popularisé dans les années 1960 grâce à la vente de feuilles Letraset contenant des passages du Lorem Ipsum, et, plus récemment, par son inclusion dans des applications de mise en page de texte, comme Aldus PageMaker.',
//                 //         textAlign: TextAlign.justify,
//                 //         style: new TextStyle(
//                 //             fontSize: 18.0, fontFamily: 'oswald'))),
//                 // Padding(
//                 //     padding: new EdgeInsets.all(20.0),
//                 //     child: new Text('Item ${2.toString()}',
//                 //         style: new TextStyle(
//                 //             fontWeight: FontWeight.bold,
//                 //             color: Colors.blue,
//                 //             fontSize: 25.0,
//                 //             fontFamily: 'oswald'))),
//                 // Padding(
//                 //     padding: new EdgeInsets.symmetric(horizontal: 20.0),
//                 //     child: new Text(
//                 //         "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.",
//                 //         textAlign: TextAlign.justify,
//                 //         style: new TextStyle(
//                 //             fontSize: 18.0, fontFamily: 'oswald'))),
//               ],
//             ),
//           ),
//           // data['userID'] == userId
//           //     ? SliverList(
//           //         delegate: SliverChildListDelegate([
//           //           StreamBuilder<QuerySnapshot>(
//           //             stream: FirebaseFirestore.instance
//           //                 .collection("Products")
//           //                 .where("userID", isEqualTo: userId)
//           //                 .snapshots(),
//           //             builder: (BuildContext context,
//           //                 AsyncSnapshot<QuerySnapshot> snapshot) {
//           //               if (snapshot.hasError)
//           //                 return new Text('Error: ${snapshot.error}');
//           //               switch (snapshot.connectionState) {
//           //                 case ConnectionState.waiting:
//           //                   return new Text('Loading...');
//           //                 default:
//           //                   return new ListView(
//           //                     physics: NeverScrollableScrollPhysics(),
//           //                     shrinkWrap: true,
//           //                     children: snapshot.data!.docs
//           //                         .map((DocumentSnapshot document) {
//           //                       return new ListTile(
//           //                         leading: ClipRRect(
//           //                           borderRadius: BorderRadius.circular(5),
//           //                           child: Container(
//           //                             height: 50,
//           //                             width: 50,
//           //                             child: CachedNetworkImage(
//           //                               imageUrl: document['themb'],
//           //                               fit: BoxFit.cover,
//           //                             ),
//           //                           ),
//           //                         ),
//           //                         title: new Text(
//           //                           document["item"],
//           //                           overflow: TextOverflow.ellipsis,
//           //                         ),
//           //                       );
//           //                     }).toList(),
//           //                   );
//           //               }
//           //             },
//           //           )
//           //         ]),
//           //       )
//           //     : SliverToBoxAdapter(
//           //         child: Container(),
//           //       ),
//           data['userID'] == userId
//               ? SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(100, 20, 100, 60),
//               child: ElevatedButton(
//                 style:
//                 ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                 onPressed: () async {
//                   // Get the document from Firestore
//                   docProducts
//                       .doc(idDoc)
//                       .get()
//                       .then((documentSnapshot) async {
//                     print(userId);
//                     print(data['userID']);
//                     if (documentSnapshot.exists) {
//                       // Document exists, check if the field is equal to user ID
//                       var data = documentSnapshot;
//                       final String fieldValue = data['userID'];
//                       if (fieldValue == userId) {
//                         await docProducts
//                             .doc(idDoc)
//                             .delete()
//                             .whenComplete(
//                                 () => Navigator.of(context).pop());
//                       }
//                     } else {
//                       print('tu n\'est pas le proprietaire du document');
//                     }
//                   }).catchError((error) {
//                     // Handle the error
//                   });
//                 },
//                 child: Text(
//                   'Delete',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           )
//               : SliverToBoxAdapter(
//             child: Container(),
//           ),
//         ],
//       ),
//     );
//   }
// }

class UnsplashD extends StatelessWidget {
  const UnsplashD({
    Key? key,
    required this.UnsplashUrl,
  }) : super(key: key);

  final String UnsplashUrl;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            scrollable: true,
            content: ShaderMask(
              shaderCallback: (rect) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomLeft,
                  colors: [Colors.transparent, Colors.black],
                ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
              },
              blendMode: BlendMode.darken,
              child: CachedNetworkImage(
                fadeInCurve: Curves.easeIn,
                filterQuality: FilterQuality.high,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                fit: BoxFit.contain,
                imageUrl: UnsplashUrl,
                errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        );
      },

      // GestureDetector(
      // onTap: () async {
      //   await Navigator.push(context,
      //       MaterialPageRoute(builder: (BuildContext) {
      //     return Hero_UnsplashUrl(UnsplashUrl: UnsplashUrl);
      //   }));
      // },
      //
      // // onTap: () => Navigator.of(context).push(MaterialPageRoute(
      // //   builder: (context) => UnsplashSlider(
      // //     UnsplashUrl: UnsplashUrl,
      // //   ),
      // // )),
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
