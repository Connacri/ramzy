// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:intl/intl.dart';
// import 'package:pretty_qr_code/pretty_qr_code.dart';
// import 'package:timeago/timeago.dart' as timeago;
// import 'package:open_location_picker/open_location_picker.dart';
// import 'package:http/http.dart' as http;
//
// class item_details_statefull extends StatefulWidget {
//   item_details_statefull({
//     Key? key,
//     required Map? data,
//     required this.docid,
//     required this.user,
//     required this.isLiked,
//     required this.docidd,
//   })  : datam = data,
//         //**************
//         super(key: key);
//
//   final Map? datam;
//   final User? user;
//   String docid;
//   bool isLiked;
//   String docidd;
//
//   final GlobalKey keyQr = GlobalKey(debugLabel: 'keyQr');
//
//   @override
//   State<item_details_statefull> createState() => _item_details_statefullState();
// }
//
// class _item_details_statefullState extends State<item_details_statefull> {
//   String? directionTXT;
//
//   @override
//   void initState() {
//     super.initState();
//     _determinePosition();
//     placemarks;
//     _getMeteo();
//     directionVent;
//   }
//
//   List<Placemark> placemarks = [];
//   String? _locality;
//
//   Position? _position;
//   String? _isoCountryCode;
//   String? _country;
//   String? _administrativeArea;
//   String? _street;
//   String? _subLocality;
//
//   Future<Position?> _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Location services are not enabled don't continue
//       // accessing the position and request users of the
//       // App to enable the location services.
//       return Future.error('Location services are disabled.');
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // Permissions are denied, next time you could try
//         // requesting permissions again (this is also where
//         // Android's shouldShowRequestPermissionRationale
//         // returned true. According to Android guidelines
//         // your App should show an explanatory UI now.
//         return Future.error('Location permissions are denied');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       // Permissions are denied forever, handle appropriately.
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//
//     // When we reach here, permissions are granted and we can
//     // continue accessing the position of the device.
//     //return await Geolocator.getCurrentPosition();
//     // Position position = await Geolocator.getCurrentPosition(
//     //         desiredAccuracy: LocationAccuracy.high) //;
//     //     .then((value) => value);
//     // setState(() {
//     //   _position = position;
//     // });
//
//     LatLng? point = widget.datam!['position'] != null
//         ? LatLng(widget.datam!['position'].latitude,
//             widget.datam!['position'].longitude)
//         : LatLng(0, 0);
//
//     List<Placemark> placemarks =
//         await placemarkFromCoordinates(point.latitude, point.longitude);
//
//     if (mounted) {
//       setState(() {
//         //_position = widget.datam!['position'];
//         _isoCountryCode = placemarks.first.isoCountryCode ?? '';
//
//         _country =
//             placemarks.first.country == null ? '' : placemarks.first.country!;
//
//         _administrativeArea = placemarks.first.administrativeArea == null
//             ? ''
//             : placemarks.first.administrativeArea!;
//         _locality =
//             placemarks.first.locality == null ? '' : placemarks.first.locality!;
//         _street =
//             placemarks.first.street == null ? '' : placemarks.first.street!;
//         _subLocality = placemarks.first.subLocality == null
//             ? ''
//             : placemarks.first.street!;
//       });
//     }
//     print('latitude');
//     print('MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM');
//     print(point.longitude);
//     print(widget.datam!['position'].latitude);
//     print('longitude');
//     print(widget.datam!['position'].longitude);
//
//     print(placemarks[0].locality); //Ain El Turk
//     print(placemarks.length);
//     //return null;
//   }
//
//   List meteoList = [];
//
//   Future _getMeteo() async {
//     // var urlMeteo =
//     //     //'https://api.meteo-concept.com/api/forecast/daily/periods?token=f70afd8eda4e451db5b1c1f36ba7057bfc455dc981630b028c5bdf2fc7d43c9a';
//     // 'https://api.openweathermap.org/data/2.5/weather?q={city name}&appid=dffcbee085bb56d1bc8cca47f58c727a';
// //'https://api.openweathermap.org/data/2.5/weather?lat=35.7351998&lon=-0.7730788&appid=dffcbee085bb56d1bc8cca47f58c727a';
// //
// //     var urlMeteo =
// //         'https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}';
// //     Position position2 = await Geolocator.getCurrentPosition(
// //         desiredAccuracy: LocationAccuracy.high);
//
//     final queryParameters = {
//       'lat': widget.datam!['position'].latitude.toString(),
//       'lon': widget.datam!['position'].longitude.toString(),
//       'appid': 'dffcbee085bb56d1bc8cca47f58c727a',
//       'lang': 'fr',
//       'units': 'metric'
//     };
//     final urlMeteov = Uri.https(
//         'api.openweathermap.org', '/data/2.5/weather', queryParameters);
//     final response = await http.get(urlMeteov);
//     var responseBody = jsonDecode(response.body);
//     print('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
//     print(responseBody.toString());
//     print('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
//
//     //if (mounted) {
//     setState(() {
//       meteoList.add(responseBody);
//     });
//     //}
//     //;
//     print(meteoList.toString());
//     print(meteoList[0]['weather']);
//     print(meteoList.length);
//     print('00000000000000000000000000000000000000000000000000000000000');
//     print(meteoList[0]['wind']['deg']);
//     print('latitude2');
//     print(widget.datam!['position'].latitude);
//     print('longitude2');
//     print(widget.datam!['position'].longitude);
//     print(meteoList[0]['weather'][0]['icon']);
//     //
//     // final String iconcode = '10d';
//     // final icon = Uri.https(
//     //     'openweathermap.org/img/wn/','10d', '@2x.png' );
//   }
//
//   late int? direction = meteoList.first['wind']['deg'];
//
//   @override
//   Widget build(BuildContext context) {
//     LatLng? point = widget.datam!['position'] != null
//         ? LatLng(widget.datam!['position'].latitude,
//             widget.datam!['position'].longitude)
//         : LatLng(0, 0);
//
//     return Scaffold(
//         body: CustomScrollView(slivers: [
//       SliverAppBar(
//         backgroundColor: Colors.black87,
//         bottom: PreferredSize(
//             preferredSize: const Size.fromHeight(10),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(15.0),
//                   child: FutureBuilder(
//                       future: FirebaseFirestore.instance
//                           .collection('Users')
//                           .doc(widget.docidd.trim())
//                           .get(),
//                       //.where('userID', isEqualTo: userIDD).get(),
//                       builder: (BuildContext context,
//                           AsyncSnapshot<dynamic> snapshot) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return const Text('...');
//                         } else if (snapshot.connectionState ==
//                             ConnectionState.done) {
//                           if (snapshot.hasData) {
//                             if (snapshot.data.data() != null) {
//                               return Row(
//                                 children: [
//                                   Container(
//                                       decoration: BoxDecoration(
//                                           border: Border.all(
//                                               width: 2, color: Colors.white),
//                                           borderRadius:
//                                               BorderRadius.circular(100)),
//                                       child: InkWell(
//                                           child: ClipRRect(
//                                             borderRadius:
//                                                 BorderRadius.circular(20),
//                                             child: CachedNetworkImage(
//                                               imageUrl: snapshot.data
//                                                   .data()['avatar'],
//                                               height: 30,
//                                               width: 30,
//                                               fit: BoxFit.cover,
//                                             ),
//                                           ),
//                                           onTap: () async {
//                                             // await Navigator.push(context,
//                                             //     MaterialPageRoute(builder:
//                                             //         (BuildContext context) {
//                                             //   return ProfileOthers(
//                                             //       data: snapshot.data.data());
//                                             // }));
//                                           })),
//                                   Padding(
//                                     padding: const EdgeInsets.all(6.0),
//                                     child: Text(
//                                       snapshot.data['displayName'],
//                                       style: const TextStyle(
//                                           fontSize: 15,
//                                           fontFamily: 'Oswald',
//                                           fontWeight: FontWeight.normal,
//                                           color: Colors.white),
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             } else {
//                               return Row(
//                                 children: [
//                                   Container(
//                                     decoration: BoxDecoration(
//                                         border: Border.all(
//                                             width: 2, color: Colors.white),
//                                         borderRadius:
//                                             BorderRadius.circular(100)),
//                                     child: InkWell(
//                                       child: ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(20),
//                                           child: const Icon(
//                                             Icons.account_circle_sharp,
//                                             size: 30,
//                                           )
//                                           // CachedNetworkImage(
//                                           //   imageUrl:
//                                           //       'https://source.unsplash.com/random/?city,night',
//                                           //   height: 30,
//                                           //   width: 30,
//                                           //   fit: BoxFit.cover,
//                                           // ),
//                                           ),
//                                     ),
//                                   ),
//                                   const Padding(
//                                     padding: EdgeInsets.all(6.0),
//                                     child: Text(
//                                       'Indisponible',
//                                       style: TextStyle(
//                                           fontSize: 15,
//                                           fontFamily: 'Oswald',
//                                           fontWeight: FontWeight.normal,
//                                           color: Colors.white),
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             }
//                           }
//                           return const Text('data');
//                         } else {
//                           return Text('State : ${snapshot.connectionState}');
//                         }
//                       }),
//                 ),
//                 Spacer(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       NumberFormat.compact().format(
//                         widget.datam!['likes'],
//                         // iitem.documents[index]['likes']
//                       ),
//                       style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: 10,
//                       ),
//                     ),
//                     SizedBox(
//                       width: 2,
//                     ),
//                     Icon(
//                       Icons.remove_red_eye_rounded,
//                       color: Colors.white70,
//                       size: 16,
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   width: 10,
//                 )
//               ],
//             )
//             // child: ListTile(
//             //   dense: true,
//             //   leading: FutureBuilder(
//             //     future: FirebaseFirestore.instance
//             //         .collection('Users')
//             //         .doc(docidd.trim())
//             //         .get(),
//             //     //.where('userID', isEqualTo: userIDD).get(),
//             //     builder:
//             //         (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//             //       if (snapshot.hasData) {
//             //         return Row(
//             //           children: [
//             //             Container(
//             //                 decoration: BoxDecoration(
//             //                     border:
//             //                         Border.all(width: 2, color: Colors.white),
//             //                     borderRadius: BorderRadius.circular(100)),
//             //                 child: InkWell(
//             //                     child: ClipRRect(
//             //                       borderRadius: BorderRadius.circular(20),
//             //                       child: CachedNetworkImage(
//             //                         imageUrl:
//             //                             snapshot.data.data()['userAvatar'],
//             //                         height: 30,
//             //                         width: 30,
//             //                         fit: BoxFit.cover,
//             //                       ),
//             //                     ),
//             //                     onTap: () async {
//             //                       await Navigator.push(context,
//             //                           MaterialPageRoute(
//             //                               builder: (BuildContext context) {
//             //                         return ProfileOthers(
//             //                             data: snapshot.data.data());
//             //
//             //
//             //                       }));
//             //                     })),
//             //             Padding(
//             //               padding: const EdgeInsets.all(6.0),
//             //               child: Text(
//             //                 snapshot.data['userDisplayName'],
//             //                 style: TextStyle(
//             //                     fontSize: 15,
//             //                     fontFamily: 'Oswald',
//             //                     fontWeight: FontWeight.normal,
//             //                     color: Colors.white),
//             //               ),
//             //             ),
//             //           ],
//             //         );
//             //       }
//             //       return const Text('');
//             //     },
//             //   ),
//             //   trailing: Row(
//             //     children: [
//             //       Align(
//             //         alignment: Alignment.centerRight,
//             //         child: Text(
//             //           NumberFormat.compact(locale: 'fr_IN')
//             //               .format(datam!['likes']),
//             //           overflow: TextOverflow.ellipsis,
//             //           style: const TextStyle(
//             //             color: Colors.black54,
//             //             fontWeight: FontWeight.normal,
//             //             fontSize: 14,
//             //             fontFamily: 'Oswald',
//             //           ),
//             //         ),
//             //       ),
//             //       Align(
//             //         alignment: Alignment.centerLeft,
//             //         child: IconButton(
//             //           padding: EdgeInsets.zero,
//             //           icon: Icon(
//             //             Icons.remove_red_eye_rounded,
//             //             color: Colors.black54,
//             //           ),
//             //           onPressed: () {},
//             //         ),
//             //       ),
//             //     ],
//             //   ),
//             // ),
//             ),
//         pinned: true,
//         expandedHeight: 300,
//         flexibleSpace: FlexibleSpaceBar(
//           collapseMode: CollapseMode.parallax,
//           background: ShaderMask(
//             shaderCallback: (rect) {
//               return const LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomLeft,
//                 colors: [Colors.transparent, Colors.black],
//               ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
//             },
//             blendMode: BlendMode.darken,
//             child: CachedNetworkImage(
//               imageUrl: widget.datam!['themb'],
//               width: double.maxFinite,
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//       ), //themb
//       SliverToBoxAdapter(
//         child: Align(
//           alignment: Alignment.centerRight,
//           child: Padding(
//             padding: const EdgeInsets.only(right: 10),
//             child: Text(
//               //datam!['createdAt'].toString(),
//               timeago.format(widget.datam!['createdAt'].toDate(), locale: 'fr'),
//               style: const TextStyle(
//                 fontSize: 12,
//                 fontFamily: 'Oswald',
//               ),
//             ),
//           ),
//         ),
//       ), //createdAt
//       SliverToBoxAdapter(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15),
//           child: Container(
//               //alignment: Alignment.topLeft,
//               child: widget.datam!['category'] == 'Hotel'
//                   ? CategoryColor(
//                       widget.datam!, Colors.blue, Colors.black87, Icons.hotel)
//                   : widget.datam!['category'] == 'Agence'
//                       ? CategoryColor(widget.datam!, Colors.red, Colors.black87,
//                           Icons.account_balance)
//                       : widget.datam!['category'] == 'Residence'
//                           ? CategoryColor(widget.datam!, Colors.green,
//                               Colors.black87, Icons.apartment)
//                           : widget.datam!['category'] == 'Autres'
//                               ? CategoryColor(widget.datam!, Colors.deepPurple,
//                                   Colors.black87, Icons.category)
//                               : CategoryColor(widget.datam!, Colors.black87,
//                                   Colors.amber, Icons.attach_money)
//
//               // sponsors
//               ), // Category
//         ),
//       ), //category
//       SliverToBoxAdapter(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//           child: Text(
//             widget.datam!['item'].toString().toUpperCase(),
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(
//               fontSize: 18,
//               fontFamily: 'Oswald',
//             ),
//           ),
//         ),
//       ), //item
//       SliverToBoxAdapter(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//                 child: Text(
//                   '${widget.datam!['price']}.00 DZD', //${' par mois'.toUpperCase()}',
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                     color: Colors.redAccent,
//                     fontSize: 18,
//                     fontFamily: 'Oswald',
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ),
//             Row(
//               children: [
//                 Text(
//                   widget.datam!['likes'].toString(),
//                   //NumberFormat.compact(locale: 'fr_IN').format(datam!['likes']),
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                     color: Colors.black54,
//                     fontWeight: FontWeight.normal,
//                     fontSize: 14,
//                     fontFamily: 'Oswald',
//                   ),
//                 ),
//                 IconButton(
//                   alignment: Alignment.centerLeft,
//                   padding: const EdgeInsets.symmetric(horizontal: 2),
//                   icon: const Icon(
//                     Icons.remove_red_eye_rounded,
//                     color: Colors.black54,
//                   ),
//                   onPressed: () {},
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ), //price
//       SliverPadding(
//         padding: const EdgeInsets.symmetric(horizontal: 15),
//         sliver: SliverGrid(
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 3,
//             mainAxisSpacing: 0,
//             crossAxisSpacing: 5,
//             childAspectRatio: 1.0,
//             //mainAxisExtent: 0
//           ),
//           delegate: SliverChildBuilderDelegate(
//             (Buildcontext, index) {
//               return Card(
//                 elevation: 5,
//                 semanticContainer: true,
//                 borderOnForeground: true,
//                 child: CachedNetworkImage(
//                   //height: 150, width: 100,
//                   imageUrl: widget.datam!['imageUrls'][index],
//                   fit: BoxFit.cover,
//                 ),
//               );
//             },
//             childCount: widget.datam!['imageUrls'].length,
//           ),
//         ),
//       ), // ListImage
//       SliverToBoxAdapter(
//         child: Padding(
//           padding: const EdgeInsets.all(18.0),
//           child: Card(
//             child: meteoList.isEmpty
//                 ? null //const Center(child: LinearProgressIndicator())
//                 : Padding(
//                     padding: const EdgeInsets.only(left: 30),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(15.0),
//                           child: Column(
//                             children: [
//                               CircleAvatar(
//                                 backgroundColor: Colors.grey,
//                                 backgroundImage: NetworkImage(
//                                   //'http://openweathermap.org/img/wn/10d@2x.png',
//                                   'http://openweathermap.org/img/wn/${meteoList.first['weather'][0]['icon']}@2x.png',
//                                 ),
//                               ),
//                               Text(
//                                 '${meteoList.first['main']['temp']}°C',
//                                 style: const TextStyle(fontFamily: 'Oswald'),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 const Icon(
//                                   Icons.location_on,
//                                   size: 13,
//                                 ),
//                                 Text(
//                                   // 'toress ',
//                                   //$_street,
//                                   '$_locality  ',
//                                   style: const TextStyle(
//                                       fontFamily: 'oswald', fontSize: 13
//                                       //fontSize: 13,
//                                       ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                                 Text(
//                                   // ${meteoList[indexM]['main']['temp']}°C '
//                                   '${meteoList.first['weather'][0]['description']}',
//                                   style: const TextStyle(fontFamily: 'Oswald'),
//                                 ),
//                               ],
//                             ),
//                             Text(
//                               'Vitesse du Vent : ${double.parse((meteoList.first['wind']['speed']).toStringAsFixed(2))} Nœud ',
//                               // * 3.6).toStringAsFixed(2))} Km/h ',
//                               style: const TextStyle(fontFamily: 'Oswald'),
//                             ),
//                             direction == null
//                                 ? Text(
//                                     'Direction : ${meteoList.first['wind']['deg']}°',
//                                     style:
//                                         const TextStyle(fontFamily: 'Oswald'),
//                                   )
//                                 : Row(
//                                     children: [
//                                       Text(
//                                         'Direction : ${meteoList.first['wind']['deg']}° ',
//                                         style: const TextStyle(
//                                             fontFamily: 'Oswald'),
//                                       ),
//                                       Text(
//                                         directionVent(direction).toString(),
//                                         style: const TextStyle(
//                                             fontFamily: 'Oswald'),
//                                       ),
//                                     ],
//                                   ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//           ),
//         ),
//       ), // Meteo
//       SliverToBoxAdapter(
//         child: widget.datam!['position'] == null
//             ? null
//             : SizedBox(
//                 height: 200,
//                 width: 200,
//                 child: Stack(
//                   children: [
//                     //Text(LatLng(datam!['position'].latitude,datam!['position'].longitude).toString(),)
//                     FlutterMap(
//                       options: MapOptions(
//                         center: LatLng(widget.datam!['position'].latitude,
//                             widget.datam!['position'].longitude),
//                         zoom: 16.0,
//                       ),
//                       layers: [
//                         TileLayerOptions(
//                           minZoom: 1,
//                           maxZoom: 18,
//                           backgroundColor: Colors.black,
//                           urlTemplate:
//                               'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//                           subdomains: ['a', 'b', 'c'],
//                         ),
//                         MarkerLayerOptions(markers: [
//                           Marker(
//                               width: 100,
//                               height: 100,
//                               point: point,
//                               builder: (ctx) => Icon(
//                                     Icons.location_on,
//                                     color: Colors.red,
//                                   ))
//                         ])
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//       ), // MapOSM
//       SliverToBoxAdapter(
//         child: IconButton(
//           onPressed: () {
//             showDialog(
//               context: context,
//               builder: (context) => AlertDialog(
//                 content: FittedBox(
//                   fit: BoxFit.contain,
//                   child: Column(
//                     children: [
//                       const SizedBox(
//                         height: 30,
//                       ),
//                       PrettyQr(
//                         data: widget.docid.toString(),
//                         size: 180,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           widget.docid.toString().toUpperCase(),
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontFamily: 'Oswald',
//                           ),
//                         ),
//                       ),
//                       ElevatedButton(
//                           child: Text('choisir Option'), onPressed: () {})
//                     ],
//                   ),
//                 ), // availibility,
//               ),
//             );
//           },
//           icon: Icon(
//             Icons.qr_code,
//             size: 25,
//           ),
//         ),
//       ),
//       // SliverToBoxAdapter(
//       //   child: Column(
//       //     children: [
//       //       const SizedBox(
//       //         height: 30,
//       //       ),
//       //       PrettyQr(
//       //         data: widget.docid.toString(),
//       //         size: 180,
//       //       ),
//       //       Padding(
//       //         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//       //         child: Text(
//       //           widget.docid.toString().toUpperCase(),
//       //           overflow: TextOverflow.ellipsis,
//       //           style: const TextStyle(
//       //             fontSize: 18,
//       //             fontFamily: 'Oswald',
//       //           ),
//       //         ),
//       //       ),
//       //     ],
//       //   ),
//       // ), // QRcode Docid
//       SliverToBoxAdapter(
//         child: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: Text(
//             widget.datam!['Description'].toString().toUpperCase(),
//             textAlign: TextAlign.justify,
//             style: const TextStyle(
//                 fontSize: 13, fontFamily: 'Oswald', color: Colors.black87),
//           ),
//         ),
//       ), //Description
//       SliverToBoxAdapter(
//         child: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: Text(
//             widget.datam!['levelItem'].toString().toUpperCase(),
//             style: const TextStyle(
//                 fontSize: 15, fontFamily: 'Oswald', color: Colors.blue),
//           ),
//         ),
//       ), //code
//       // SliverToBoxAdapter(
//       //   child: Align(
//       //     alignment: Alignment.center,
//       //     child: Padding(
//       //       padding: const EdgeInsets.only(right: 10),
//       //       child: Text(
//       //         'Date Debut : ' + widget.datam!['dateDebut'].toDate().toString(),
//       //         style: const TextStyle(
//       //           fontSize: 12,
//       //           fontFamily: 'Oswald',
//       //         ),
//       //       ),
//       //     ),
//       //   ),
//       // ), //dateDebut
//       // SliverToBoxAdapter(
//       //   child: Align(
//       //     alignment: Alignment.center,
//       //     child: Padding(
//       //       padding: const EdgeInsets.only(right: 10),
//       //       child: Text(
//       //         'Date Fin : ' + widget.datam!['dateFin'].toDate().toString(),
//       //         style: const TextStyle(
//       //           fontSize: 12,
//       //           fontFamily: 'Oswald',
//       //         ),
//       //       ),
//       //     ),
//       //   ),
//       // ), //dateFin
//
//       // SliverToBoxAdapter(
//       //   child: Padding(
//       //     padding: const EdgeInsets.all(15.0),
//       //     child: Padding(
//       //       padding: const EdgeInsets.only(top: 0),
//       //       child: CarouselSlider(
//       //           items: ,
//       //           options: CarouselOptions(
//       //             viewportFraction: 1,
//       //             initialPage: 0,
//       //             autoPlay: true,
//       //             height: 170,
//       //           )),
//       //     ),
//       //   ),
//       // ), //Description
//       SliverToBoxAdapter(
//         child: SizedBox(
//           height: 200,
//         ),
//       ),
//     ]));
//   }
//
//   directionVent(direction) {
//     if (direction >= 0 && direction < 22.5) {
//       return 'Nord N';
//     }
//     if (direction >= 22.5 && direction < 45) {
//       return 'Nord NNE';
//     }
//     if (direction >= 45 && direction < 67.5) {
//       return 'Nord NE';
//     }
//     if (direction >= 67.5 && direction < 90) {
//       return 'Est ENE';
//     }
//     if (direction >= 90 && direction < 112.5) {
//       return 'Est E';
//     }
//     if (direction >= 112.5 && direction < 135) {
//       return 'Est ESE';
//     }
//     if (direction >= 135 && direction < 157.5) {
//       return 'Sud SE';
//     }
//     if (direction >= 157.5 && direction < 180) {
//       return 'Sud SSE';
//     }
//     if (direction >= 180 && direction < 202.5) {
//       return 'Sud S';
//     }
//     if (direction >= 202.5 && direction < 225) {
//       return 'Sud SSW';
//     }
//     if (direction >= 225 && direction < 247.5) {
//       return 'Sud SW';
//     }
//     if (direction >= 247.5 && direction < 270) {
//       return 'Ouest WSW';
//     }
//     if (direction >= 270 && direction < 292.5) {
//       return 'Ouest W';
//     }
//     if (direction >= 292.5 && direction < 315) {
//       return 'Ouest WNW';
//     }
//     if (direction >= 315 && direction < 337.5) {
//       return 'Nord NW';
//     }
//     if (direction >= 337.5 && direction <= 360) {
//       return 'Nord NNW';
//     }
//     print(
//         'METEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEO');
//     //print(directionVent(direction).toString());
//   }
// }
//
// Widget CategoryColor(Map<dynamic, dynamic> data, customColor, customColor2,
//     IconData? customIcon) {
//   return Row(
//     children: [
//       CircleAvatar(
//         radius: 10,
//         backgroundColor: customColor,
//         //radius: 30,
//         child: Container(
//           child: Icon(
//             customIcon, //Icons.hotel,
//             color: customColor2,
//             size: 10,
//           ),
//         ),
//       ),
//       Text(
//         '${' ' + data['category'].toUpperCase()} ',
//         overflow: TextOverflow.ellipsis,
//         style: TextStyle(
//           //backgroundColor: customColor,
//           //Colors.blue,
//           color: customColor2,
//           fontWeight: FontWeight.normal,
//           fontSize: 10,
//           fontFamily: 'Oswald',
//         ),
//       ),
//     ],
//   );
//   // Chip(
//   //   backgroundColor: customColor,
//   //   labelPadding: EdgeInsets.zero,
//   //   label: Text(
//   //     '${' ' + data['category'].toUpperCase() + ' '}',
//   //     overflow: TextOverflow.ellipsis,
//   //     style: TextStyle(
//   //       //backgroundColor: customColor,
//   //       //Colors.blue,
//   //       color: customColor2,
//   //       fontWeight: FontWeight.normal,
//   //       fontSize: 10,
//   //       fontFamily: 'Oswald',
//   //     ),
//   //   ),
//   //   avatar: CircleAvatar(
//   //     radius: 10,
//   //     backgroundColor: customColor,
//   //     //radius: 30,
//   //     child: Container(
//   //       child: Icon(
//   //         customIcon, //Icons.hotel,
//   //         color: customColor2,
//   //         size: 10,
//   //       ),
//   //     ),
//   //   ),
//   // );
// }
