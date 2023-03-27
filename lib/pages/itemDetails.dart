import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:open_location_picker/open_location_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:timeago/timeago.dart' as timeago;
import '../2/publicLoggedPage.dart';
import 'ProfileOthers.dart';

class SilverdetailItem extends StatelessWidget {
  SilverdetailItem({
    Key? key,
    required this.data,
    required this.idDoc,
  }) : super(key: key);

//  final String UnsplashUrl;
  final Map data;
  final String idDoc;
  // final int intex;
  final CollectionReference docProducts =
      FirebaseFirestore.instance.collection("Products");
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('fr', timeago.FrMessages());

    LatLng? point = data['position'] != null
        ? LatLng(data['position'].latitude, data['position'].longitude)
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
                    child: Text(
                      data['category'] ?? 'null',
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          fontFamily: 'oswald',
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
                      '${data['likes']} Vue',
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
                  imageUrl: data['themb'],
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child:
                  Text(timeago.format(data['createdAt'].toDate(), locale: 'fr'),
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                        fontFamily: 'Oswald',
                      )),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(data['userID'])
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
                                    path: '+213${data['phone']}');
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
                                String msg = 'Hello Oran';
                                var whatsappUrl =
                                    "whatsapp://send?phone=+213${data['phone']}" +
                                        "&text=${Uri.encodeComponent(msg)}";

                                final Uri launchUrlRW = Uri(
                                    scheme: 'Tel',
                                    path: "+213${data['phone']}" +
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
                Padding(
                  padding: new EdgeInsets.symmetric(horizontal: 20.0),
                  child: new Text(
                    data['item'].toString().toUpperCase(),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'oswald'),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: new EdgeInsets.symmetric(horizontal: 20.0),
                    child: new Text(
                      'Prix : ' +
                          NumberFormat.currency(
                                  symbol: 'DZD ', decimalDigits: 2)
                              .format(data['price']),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          //backgroundColor: Colors.black45,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.green,
                          fontFamily: 'oswald'),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  height: 150.0,
                  child: Center(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: data['imageUrls'].length,
                      itemBuilder: (BuildContext context, int index) {
                        return UnsplashSlider(
                            UnsplashUrl: data['imageUrls'][index]);
                      },
                    ),
                  ),
                ),
                Container(
                  child: data['position'] == null
                      ? null
                      : Stack(
                          children: [
                            SizedBox(
                                height: 100,
                                width: MediaQuery.of(context).size.width,
                                child: FlutterMap(
                                  options: MapOptions(
                                    center: LatLng(data['position'].latitude,
                                        data['position'].longitude),
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
                            // Container(
                            //   height: 100,
                            //   width: MediaQuery.of(context).size.width,
                            //   child: InkWell(
                            //     onTap: () async {
                            //       final String url =
                            //           'https://www.google.com/maps/search/?api=1&query=${data['position'].latitude},${data['position'].longitude}';
                            //
                            //       if (await canLaunch(url)) {
                            //         await launch(url);
                            //       } else {
                            //         throw 'Could not launch $url';
                            //       }
                            //     },
                            //     // onTap: () async {
                            //     //   final Uri gMapsUrl = Uri(
                            //     //       scheme: 'Map',
                            //     //       path:
                            //     //           //'https://www.google.com/maps/dir/api=1&destination=${data['position'].latitude},${data['position'].longitude}&travelmode=driving');
                            //     //           'https://www.google.com/maps/search/?api=1&query=${data['position'].latitude},${data['position'].longitude}');
                            //     //   if (Platform.isAndroid &&
                            //     //       await canLaunchUrl(gMapsUrl)) {
                            //     //     await launchUrl(gMapsUrl,
                            //     //         mode: LaunchMode.externalApplication);
                            //     //   }
                            //     //
                            //     //   // final Uri launchUrlR = Uri(
                            //     //   //     scheme: 'Tel', path: '+213${data['phone']}');
                            //     //   // if (await canLaunchUrl(gMapsUrl)) {
                            //     //   //   await launchUrl(gMapsUrl);
                            //     //   //   print('tap map secces');
                            //     //   // } else {
                            //     //   //   print('This Call Cant execute');
                            //     //   // }
                            //     // },
                            //   ),
                            // ),
                          ],
                        ),
                ),
                // MapOSM
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                  child: data['position'] == null
                      ? null
                      : ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo),
                          onPressed: () async {
                            final String url =
                                'https://www.google.com/maps/search/?api=1&query=${data['position'].latitude},${data['position'].longitude}';

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

                Center(
                  child: Padding(
                    padding: new EdgeInsets.all(20.0),
                    child: Text(
                      'Niveau : ' + data['levelItem'],
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'oswald'),
                    ),
                  ),
                ),
                Padding(
                  padding: new EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Description : ' + data['Description'],
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54),
                  ),
                ),
                Padding(
                  padding: new EdgeInsets.all(20.0),
                  child: Text(
                    'Made In  ${data['origine'] ?? 'Algeria'}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontFamily: 'oswald'),
                  ),
                ),
                // Padding(
                //     padding: new EdgeInsets.symmetric(horizontal: 20.0),
                //     child: new Text(
                //         'Le Lorem Ipsum est simplement du faux texte employé dans la composition et la mise en page avant impression. Le Lorem Ipsum est le faux texte standard de l\'imprimerie depuis les années 1500, quand un imprimeur anonyme assembla ensemble des morceaux de texte pour réaliser un livre spécimen de polices de texte. Il n\'a pas fait que survivre cinq siècles, mais s\'est aussi adapté à la bureautique informatique, sans que son contenu n\'en soit modifié. Il a été popularisé dans les années 1960 grâce à la vente de feuilles Letraset contenant des passages du Lorem Ipsum, et, plus récemment, par son inclusion dans des applications de mise en page de texte, comme Aldus PageMaker.',
                //         textAlign: TextAlign.justify,
                //         style: new TextStyle(
                //             fontSize: 18.0, fontFamily: 'oswald'))),
                // Padding(
                //     padding: new EdgeInsets.all(20.0),
                //     child: new Text('Item ${2.toString()}',
                //         style: new TextStyle(
                //             fontWeight: FontWeight.bold,
                //             color: Colors.blue,
                //             fontSize: 25.0,
                //             fontFamily: 'oswald'))),
                // Padding(
                //     padding: new EdgeInsets.symmetric(horizontal: 20.0),
                //     child: new Text(
                //         "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.",
                //         textAlign: TextAlign.justify,
                //         style: new TextStyle(
                //             fontSize: 18.0, fontFamily: 'oswald'))),
              ],
            ),
          ),
          // data['userID'] == userId
          //     ? SliverList(
          //         delegate: SliverChildListDelegate([
          //           StreamBuilder<QuerySnapshot>(
          //             stream: FirebaseFirestore.instance
          //                 .collection("Products")
          //                 .where("userID", isEqualTo: userId)
          //                 .snapshots(),
          //             builder: (BuildContext context,
          //                 AsyncSnapshot<QuerySnapshot> snapshot) {
          //               if (snapshot.hasError)
          //                 return new Text('Error: ${snapshot.error}');
          //               switch (snapshot.connectionState) {
          //                 case ConnectionState.waiting:
          //                   return new Text('Loading...');
          //                 default:
          //                   return new ListView(
          //                     physics: NeverScrollableScrollPhysics(),
          //                     shrinkWrap: true,
          //                     children: snapshot.data!.docs
          //                         .map((DocumentSnapshot document) {
          //                       return new ListTile(
          //                         leading: ClipRRect(
          //                           borderRadius: BorderRadius.circular(5),
          //                           child: Container(
          //                             height: 50,
          //                             width: 50,
          //                             child: CachedNetworkImage(
          //                               imageUrl: document['themb'],
          //                               fit: BoxFit.cover,
          //                             ),
          //                           ),
          //                         ),
          //                         title: new Text(
          //                           document["item"],
          //                           overflow: TextOverflow.ellipsis,
          //                         ),
          //                       );
          //                     }).toList(),
          //                   );
          //               }
          //             },
          //           )
          //         ]),
          //       )
          //     : SliverToBoxAdapter(
          //         child: Container(),
          //       ),
          data['userID'] == userId
              ? SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(100, 20, 100, 60),
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () async {
                        // Get the document from Firestore
                        docProducts
                            .doc(idDoc)
                            .get()
                            .then((documentSnapshot) async {
                          print(userId);
                          print(data['userID']);
                          if (documentSnapshot.exists) {
                            // Document exists, check if the field is equal to user ID
                            var data = documentSnapshot;
                            final String fieldValue = data['userID'];
                            if (fieldValue == userId) {
                              await docProducts
                                  .doc(idDoc)
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
        ],
      ),
    );
  }
}
