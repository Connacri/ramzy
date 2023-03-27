import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:shimmer/shimmer.dart';

class CardTop extends StatelessWidget {
  const CardTop({
    Key? key,
    required Map<String, dynamic> data,
  })  : _data = data,
        super(key: key);

  final Map<String, dynamic> _data;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 2,
      semanticContainer: true,
      color: Colors.white70,
      child: SizedBox(
        height: MediaQuery.of(context).size.width * 0.15,
        width: MediaQuery.of(context).size.width * 0.30,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ShaderMask(
                    shaderCallback: (rect) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black],
                      ).createShader(
                          Rect.fromLTRB(0, 0, rect.width, rect.height));
                    },
                    blendMode: BlendMode.darken,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: _data['themb'],
                      /*placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(),
                        ),*/
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ), // image
                  // Container(
                  //   padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                  //   alignment: Alignment.topLeft,
                  //   child: _data['category'] == 'Hotel'
                  //       ? Text(
                  //           _data['category'].toUpperCase(),
                  //           overflow: TextOverflow.ellipsis,
                  //           style: const TextStyle(
                  //             backgroundColor: Colors.blue,
                  //             color: Colors.white,
                  //             fontWeight: FontWeight.normal,
                  //             fontSize: 15,
                  //             fontFamily: 'Oswald',
                  //           ),
                  //         )
                  //       : Text(
                  //           _data['category'].toUpperCase(),
                  //           overflow: TextOverflow.ellipsis,
                  //           style: const TextStyle(
                  //             backgroundColor: Colors.red,
                  //             color: Colors.white,
                  //             fontWeight: FontWeight.normal,
                  //             fontSize: 15,
                  //             fontFamily: 'Oswald',
                  //           ),
                  //         ),
                  // ), // category
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: ListTile(
                      title: Text(
                        _data['item'].toUpperCase(),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                          fontFamily: 'Oswald',
                        ),
                      ),
                      subtitle: Text(
                        _data['code'].toUpperCase(),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          fontFamily: 'Oswald',
                        ),
                      ),
                    ),
                  ), // item & code
                  // Container(
                  //   padding: EdgeInsets.fromLTRB(4, 12, 0, 0),
                  //   alignment: Alignment.bottomLeft,
                  //   child: Text(
                  //     _data['Description'].toUpperCase(),
                  //     overflow: TextOverflow.ellipsis,
                  //     style: const TextStyle(
                  //       color: Colors.blue,
                  //       fontWeight: FontWeight.normal,
                  //       fontSize: 12,
                  //       fontFamily: 'Oswald',
                  //     ),
                  //   ),
                  // ), // description
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class H1 extends StatelessWidget {
  const H1({
    Key? key,
    required this.collectionRMZ,
    required this.documentTop,
  }) : super(key: key);

  final String collectionRMZ;
  final String documentTop;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection(collectionRMZ)
            .doc(documentTop)
            .get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // final _img = snapshot.data['themb'];
          // print(_img);

          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CardTopShimmer(); //Text("Loading");
          }

          return InkWell(
            child: Hero(
              tag: 'detailheroo',
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 2,
                semanticContainer: true,
                color: Colors.white70,
                child: SizedBox(
                  height: MediaQuery.of(context).size.width * 0.15,
                  width: MediaQuery.of(context).size.width * 0.30,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        child: ShaderMask(
                          shaderCallback: (rect) {
                            return const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black],
                            ).createShader(
                                Rect.fromLTRB(0, 0, rect.width, rect.height));
                          },
                          blendMode: BlendMode.darken,
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: snapshot.data['themb'], //_img,
                            /*placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(),
                          ),*/
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        //height: 60,
                        //color: Colors.black45,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),

      // Expanded(
      //   flex: 1,
      //   child: Card(
      //     color: Colors.lightBlue,
      //     elevation: 5,
      //     child: Padding(
      //       padding: EdgeInsets.only(left: 5, right: 5),
      //       child: Container(
      //         height: 90,
      //         width: 150,
      //       ),
      //     ),
      //   ),
      // ),
      // Expanded(
      //   flex: 1,
      //   child: Card(
      //     color: Colors.lightBlue,
      //     elevation: 5,
      //     child: Padding(
      //       padding: EdgeInsets.only(left: 5, right: 5),
      //       child: Container(
      //         height: 90,
      //         width: 150,
      //       ),
      //     ),
      //   ),
      // ),
      // Expanded(
      //   flex: 1,
      //   child: Card(
      //     color: Colors.lightBlue,
      //     elevation: 5,
      //     child: Padding(
      //       padding: EdgeInsets.only(left: 5, right: 5),
      //       child: Container(
      //         height: 90,
      //         width: 150,
      //       ),
      //     ),
      //   ),
      // ),
      // Expanded(
      //   flex: 1,
      //   child: Card(
      //     color: Colors.lightBlue,
      //     elevation: 5,
      //     child: Padding(
      //       padding: EdgeInsets.only(left: 5, right: 5),
      //       child: Container(
      //         height: 90,
      //         width: 150,
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}

class TopWidget extends StatelessWidget {
  const TopWidget({
    Key? key,
    required Future<QuerySnapshot<Object?>> TopFuture,
  })  : _TopResidenceFuture = TopFuture,
        super(key: key);

  final Future<QuerySnapshot<Object?>> _TopResidenceFuture;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder<QuerySnapshot>(
        future: _TopResidenceFuture,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CardTopShimmer(); //Text("Loading");
          }

          return ListView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return CardTop(data: data);
                  }));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 2,
                  semanticContainer: true,
                  color: Colors.white70,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width * 0.15,
                    width: MediaQuery.of(context).size.width * 0.30,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          child: ShaderMask(
                            shaderCallback: (rect) {
                              return const RadialGradient(
                                colors: [Colors.transparent, Colors.black87],
                                tileMode: TileMode.clamp,
                                focalRadius: 1,
                                radius: 1,
                                stops: [0.1, 1],
                                center: Alignment.center,
                              ).createShader(
                                  Rect.fromLTRB(0, 0, rect.width, rect.height));
                              // LinearGradient(
                              //   begin: Alignment.topCenter,
                              //   end: Alignment.bottomCenter,
                              //   colors: [Colors.transparent, Colors.black],
                              // ).createShader(Rect.fromLTRB(
                              //     0, 0, rect.width, rect.height));
                            },
                            blendMode: BlendMode.darken,
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: data['themb'],
                              /*placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(),
                                ),*/
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          //height: 60,
                          //color: Colors.black45,

                          child: ListTile(
                            title: Text(
                              data['item'].toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                                fontFamily: 'Oswald',
                              ),
                            ),
                            subtitle: Text(
                              '${data['price']}.00 DZD',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                fontFamily: 'Oswald',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),

      /*ListView.builder(
              itemCount: 20,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.all(10),
                    child: Center(
                      child: Text('Cardrat $index'),
                    ),
                    color: Colors.green,
                  )),*/
    );
  }
}

class Top_Title extends StatelessWidget {
  const Top_Title({
    Key? key,
    required this.toptitle,
    required this.toptitle2,
    required this.CustomColorSpan,
    required this.toptitle3,
    required this.CustomColorSpan2,
    required this.CustomIcon,
  }) : super(key: key);

  final toptitle;
  final toptitle2;
  final CustomColorSpan;
  final toptitle3;
  final CustomColorSpan2;
  final IconData? CustomIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                toptitle,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Oswald'),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
                alignment: Alignment.bottomRight,
                child: RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                          text: toptitle2,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Oswald',
                              fontSize: 18,
                              color: CustomColorSpan)),
                      TextSpan(
                          text: toptitle3,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Oswald',
                              fontSize: 18,
                              color: CustomColorSpan2)),
                    ],
                    //text: 'Aujourd\'Hui ',
                  ),
                )),
          ),
          Icon(CustomIcon),
          /*add_to_photos_rounded
            arrow_forward_ios_sharp
            arrow_right_sharp*/
        ],
      ),
    );
  }
}

class Top_Hotel extends StatelessWidget {
  const Top_Hotel({
    Key? key,
    required Future<QuerySnapshot<Object?>> TopHotelFuture,
  })  : _TopHotelFuture = TopHotelFuture,
        super(key: key);

  final Future<QuerySnapshot<Object?>> _TopHotelFuture;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Top Hôtel',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Oswald'),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: const <TextSpan>[
                            TextSpan(
                                text: 'Super',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oswald',
                                    fontSize: 18,
                                    color: Colors.red)),
                            TextSpan(
                                text: 'Deals',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oswald',
                                    fontSize: 18,
                                    color: Colors.blue)),
                          ],
                          //text: 'Aujourd\'Hui ',
                        ),
                      )),
                ),
                const Icon(Icons.arrow_forward_ios_sharp),
                /*add_to_photos_rounded
                  arrow_forward_ios_sharp
                  arrow_right_sharp*/
              ],
            ),
          ),
          // SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.25,
          //   width: MediaQuery.of(context).size.width,
          //   child: FutureBuilder<QuerySnapshot>(
          //     future: _TopHotelFuture,
          //     builder: (BuildContext context,
          //         AsyncSnapshot<QuerySnapshot> snapshot) {
          //       // if (snapshot.hasError) {
          //       //   return const Text('Something went wrong');
          //       // }
          //       //
          //       // if (snapshot.connectionState == ConnectionState.waiting) {
          //       //   return CardTopShimmer();
          //       // }
          //       return Container(
          //           child: snapshot.data!.docs.map((DocumentSnapshot document) {
          //             Map<String, dynamic> data =
          //             document.data()! as Map<String, dynamic>;
          //             return CardTop(data: data);
          //           }).first
          //       );
          //
          //
          //       return ListView(
          //         scrollDirection: Axis.horizontal,
          //         physics: const NeverScrollableScrollPhysics(),
          //         children:
          //         snapshot.data!.docs.map((DocumentSnapshot document) {
          //           Map<String, dynamic> data =
          //           document.data()! as Map<String, dynamic>;
          //           return InkWell(
          //               onTap: () {
          //                 Navigator.push(context, MaterialPageRoute(
          //                     builder: (BuildContext context) {
          //                       return CardTop(data: data);
          //                     }));
          //               },
          //               child:
          //               Hero(tag: 'detailh1', child: CardTop(data: data)));
          //         }).toList(),
          //       );
          //     },
          //   ),
          // ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder<QuerySnapshot>(
              future: _TopHotelFuture,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CardTopShimmer();
                }
                // return Container(
                //     child: snapshot.data!.docs.map((DocumentSnapshot document) {
                //       Map<String, dynamic> data =
                //       document.data()! as Map<String, dynamic>;
                //       return CardTop(data: data);
                //     }).first
                // );

                return ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return CardTop(data: data);
                          }));
                        },
                        child: CardTop(data: data));
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Top_Hotelstream extends StatelessWidget {
  Top_Hotelstream({
    Key? key,
    required Stream<QuerySnapshot<Object?>>
        streamTopHotelFuture, //****************
  })  : _streamTopHotelFuture = streamTopHotelFuture, //**************
        super(key: key);

  final Stream<QuerySnapshot<Object?>> _streamTopHotelFuture; //***************

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Top Hôtel',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Oswald'),
                    ),
                  ), // Titre Top Hôtel
                ), // Titre Top Hôtel
                Expanded(
                  flex: 1,
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: const <TextSpan>[
                            TextSpan(
                                text: 'Super',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oswald',
                                    fontSize: 18,
                                    color: Colors.red)),
                            TextSpan(
                                text: 'Deals',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oswald',
                                    fontSize: 18,
                                    color: Colors.blue)), // SuperDeals
                          ],
                          //text: 'Aujourd\'Hui ',
                        ), // Titre Top Hotel
                      )), // Titre Top Hotel
                ), // Titre Top Hotel
                const Icon(Icons.arrow_forward_ios_sharp),
                /*add_to_photos_rounded
                  arrow_forward_ios_sharp
                  arrow_right_sharp*/
              ],
            ), // Titre Top Hôtel
          ), // Titre Top Hôtel
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder<QuerySnapshot>(
              stream: _streamTopHotelFuture,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CardTopShimmer();
                }
                return Container(
                    child: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data1 =
                      document.data() as Map<String, dynamic>;

                  final docid = document.id;
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    elevation: 1,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Column(
                      children: [
                        Expanded(
                            child: Stack(fit: StackFit.expand, children: [
                          ShaderMask(
                            shaderCallback: (rect) {
                              return const
                                  //   const LinearGradient(
                                  //   begin: Alignment.topCenter,
                                  //   end: Alignment.bottomCenter,
                                  //   colors: [Colors.transparent, Colors.black],
                                  // )
                                  RadialGradient(
                                colors: [Colors.transparent, Colors.black87],
                                tileMode: TileMode.clamp,
                                focalRadius: 1,
                                radius: 1,
                                stops: [0.1, 1],
                                center: Alignment.center,
                              ).createShader(Rect.fromLTRB(
                                      0, 0, rect.width, rect.height));
                            },
                            blendMode: BlendMode.darken,
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: data1['themb'],
                            ),
                          ),
                          Column(
                            mainAxisAlignment:
                                MainAxisAlignment.start, //***********
                            children: [
                              Expanded(
                                child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 05, 0),
                                    //alignment: Alignment.topLeft,
                                    child: data1['category'] == 'Hotel'
                                        ? CategoryColors(data1, Colors.blue,
                                            Colors.white, Icons.hotel)
                                        : data1['category'] == 'Agence'
                                            ? CategoryColors(
                                                data1,
                                                Colors.red,
                                                Colors.white,
                                                Icons.account_balance)
                                            : data1['category'] == 'Residence'
                                                ? CategoryColors(
                                                    data1,
                                                    Colors.green,
                                                    Colors.white,
                                                    Icons.apartment)
                                                : data1['category'] == 'Autres'
                                                    ? CategoryColors(
                                                        data1,
                                                        Colors.deepPurple,
                                                        Colors.white,
                                                        Icons.category)
                                                    : CategoryColors(
                                                        data1,
                                                        Colors.black54,
                                                        Colors.amber,
                                                        Icons.attach_money)

                                    // sponsors
                                    ),
                              ), // Category
                              Container(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  data1['item'].toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                    fontFamily: 'Oswald',
                                  ),
                                ),
                              ), // Items
                            ],
                          ),

                          //     ListTile(
                          //   dense: true,
                          //   title: Text(''),
                          //   leading: FutureBuilder(
                          //     future: fetchData_users(),
                          //     // FirebaseFirestore.instance
                          //     //     .collection('Users')
                          //     //     .where('userID', isEqualTo: user!.uid)
                          //     //     .get(),
                          //     builder:
                          //         (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          //       return snapshot.data != null
                          //           ? Container(
                          //               height: 35,
                          //               width: 35,
                          //               child: CircleAvatar(
                          //                   radius: 40,
                          //                   backgroundImage: NetworkImage(
                          //                       '${snapshot.data!['userAvatar']}')),
                          //             )
                          //           // CircleAvatar(
                          //           //   radius: 40,
                          //           //   backgroundImage: Image.network(
                          //           //     '${snapshot.data!['userAvatar']}'
                          //           //   )
                          //           //
                          //           // )
                          //           //
                          //           : Text('');
                          //     },
                          //   ),
                          //   subtitle: FutureBuilder(
                          //     future: fetchData_users(),
                          //     // FirebaseFirestore.instance
                          //     //     .collection('Users')
                          //     //     .where('userID', isEqualTo: user!.uid)
                          //     //     .get(),
                          //     builder:
                          //         (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          //       return snapshot.data != null
                          //           ? Text(
                          //               '${snapshot.data!['userDisplayName']}',
                          //               style: TextStyle(
                          //                   color: Colors.tealAccent,
                          //                   fontWeight: FontWeight.w400,
                          //                   fontFamily: 'Oswald'),
                          //             )
                          //           : Text('');
                          //     },
                          //   ),
                          //   // Text(
                          //   //   _data!['userID'].toUpperCase(),
                          //   //   overflow: TextOverflow.ellipsis,
                          //   //   style: const TextStyle(
                          //   //     color: Colors.amber,
                          //   //     fontWeight: FontWeight.w400,
                          //   //     fontSize: 12,
                          //   //     fontFamily: 'Oswald',
                          //   //   ),
                          //   // ),
                          // ),
                        ])),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 4, 0, 4),
                            child: FutureBuilder(
                                future: FirebaseFirestore.instance
                                    .collection('Users')
                                    .where('userID', isEqualTo: data1['userID'])
                                    .get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  if (snapshot.hasError) {
                                    return const Text('Something went wrong');
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CardTopShimmer();
                                  }
                                  return Container(
                                      child: snapshot.data!.docs
                                          .map((DocumentSnapshot document) {
                                    Map<String, dynamic> data2 =
                                        document.data() as Map<String, dynamic>;

                                    return data2 != null //snapshot.data != null
                                        ? Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8),
                                                child: SizedBox(
                                                  height: 25,
                                                  width: 25,
                                                  child: CircleAvatar(
                                                      radius: 40,
                                                      backgroundImage: NetworkImage(
                                                          data2['userAvatar']
                                                          //'${snapshot.data!['userAvatar']}'
                                                          )),
                                                ),
                                              ),
                                              Text(
                                                data2['userDisplayName'],
                                                //'${snapshot.data!['userDisplayName']}',
                                                style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Oswald'),
                                              ),
                                            ],
                                          )
                                        : const Text('');
                                  }));
                                }),
                          ),
                        ), // FutureBuilder Users

                        // Padding(
                        //   padding: const EdgeInsets.fromLTRB(8, 4, 0, 4),
                        //   child: _data1 != null
                        //       ? Row(
                        //     children: [
                        //       Padding(
                        //         padding: const EdgeInsets.only(right: 8),
                        //         child: Container(
                        //           height: 25,
                        //           width: 25,
                        //           child: CircleAvatar(
                        //               radius: 40,
                        //               backgroundImage: NetworkImage(
                        //                   _data1['userAvatar'])),
                        //         ),
                        //       ),
                        //       Text(
                        //         _data1['userDisplayName'],
                        //         style: TextStyle(
                        //             color: Colors.black54,
                        //             fontWeight: FontWeight.w400,
                        //             fontFamily: 'Oswald'),
                        //       ),
                        //     ],
                        //   )
                        //       : Text('')
                        // ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    '${data1['price']}.00 DZD',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      fontFamily: 'Oswald',
                                    ),
                                  ),
                                ),
                              ), // Price
                              user == null
                                  ? Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          data1['likes']
                                              .toString(), //.toUpperCase(),
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14,
                                            fontFamily: 'Oswald',
                                          ),
                                        ),
                                      ),
                                    ) // like Grey
                                  : Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          data1['likes']
                                              .toString(), //.toUpperCase(),
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14,
                                            fontFamily: 'Oswald',
                                          ),
                                        ),
                                      ),
                                    ), // like blue
                              user == null
                                  ? const Icon(
                                      Icons.favorite,
                                      color: Colors.grey,
                                      size: 20.0,
                                    ) // icon grey
                                  //: user!.uid.contains(_data1['usersLike'].toString())
                                  : data1['usersLike']
                                          .toString()
                                          .contains(user!.uid)
                                      ? GestureDetector(
                                          onTap: () => {
                                            FirebaseFirestore.instance
                                                .collection('Products')
                                                .doc(docid)
                                                .update({
                                              // 'likes': FieldValue.increment(-1),
                                              // 'usersLike':
                                              // FieldValue.arrayUnion(
                                              //     [user!.uid]),
                                              'likes': FieldValue.increment(-1),
                                              'usersLike':
                                                  FieldValue.arrayRemove(
                                                      [user!.uid]),
                                            }),
                                          },
                                          child: const Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                            size: 20.0,
                                          ),
                                        ) // favorite_border_outlined blue
                                      : GestureDetector(
                                          onTap: () => {
                                            FirebaseFirestore.instance
                                                .collection('Products')
                                                .doc(docid)
                                                .update({
                                              'likes': FieldValue.increment(1),
                                              'usersLike':
                                                  FieldValue.arrayUnion(
                                                      [user!.uid]),
                                            }),
                                          },
                                          child: const Icon(
                                            Icons.favorite_border_outlined,
                                            color: Colors.blue,
                                            size: 20.0,
                                          ),
                                        ) // icon red
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).first);
              },
            ),
          ), // Stream Top Hôtel
        ],
      ),
    );
  }
}

class SliderH extends StatelessWidget {
  const SliderH({
    Key? key,
    required Future<QuerySnapshot<Object?>> TopHotelFuture,
    required bool enabled,
  })  : _TopHotelFuture = TopHotelFuture,
        _enabled = enabled,
        super(key: key);

  final Future<QuerySnapshot<Object?>> _TopHotelFuture;
  final bool _enabled;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _TopHotelFuture,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
          // return Shimmer.fromColors(
          //   baseColor: Colors.grey.shade300,
          //   highlightColor: Colors.grey.shade100,
          //   period: const Duration(microseconds: 3000),
          //   enabled: _enabled,
          //   child: const SizedBox(height: 170, child: Text("Loading")),
          // );
        }
        return snapshot.data == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 0),
                child: CarouselSlider(
                    items: snapshot.data!.docs.map(
                      (DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ShaderMask(
                            shaderCallback: (rect) {
                              return const
                                  // RadialGradient(
                                  //   colors: [Colors.transparent, Colors.black87],
                                  //   tileMode: TileMode.clamp,
                                  //   focalRadius:1,
                                  //   radius:1,
                                  //   stops: [
                                  //     0.1,1
                                  //   ],
                                  //   center: Alignment.center,
                                  // ).createShader(
                                  //     Rect.fromLTRB(0, 0, rect.width, rect.height));
                                  LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black],
                              ).createShader(Rect.fromLTRB(
                                      0, 0, rect.width, rect.height));
                            },
                            blendMode: BlendMode.darken,
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: data['themb'],
                            ),
                          ),
                        );
                      },
                    ).toList(),
                    options: CarouselOptions(
                      viewportFraction: 1,
                      initialPage: 0,
                      autoPlay: true,
                      height: 170,
                    )),
              );
      },
      //),
    );
  }
}

class Cardless extends StatelessWidget {
  const Cardless({
    Key? key,
    required Map? data,
    required String dataid,
    //required Function like,
    //required Function Dislike,
  })  : _data = data,
        dataid = dataid,
        //like = like,
        //Dislike = Dislike,
        super(key: key);

  final Map? _data;
  final String dataid;
  //final Function like;
  //final Function Dislike;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    bool isLiked = false;
    bool hasBackground = false;
    int likeCount = 17;
    final key = GlobalKey<LikeButtonState>();
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      elevation: 5,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ShaderMask(
                    shaderCallback: (rect) {
                      return const
                          //   const LinearGradient(
                          //   begin: Alignment.topCenter,
                          //   end: Alignment.bottomCenter,
                          //   colors: [Colors.transparent, Colors.black],
                          // )
                          RadialGradient(
                        colors: [Colors.transparent, Colors.black87],
                        tileMode: TileMode.clamp,
                        focalRadius: 1,
                        radius: 1,
                        stops: [0.1, 1],
                        center: Alignment.center,
                      ).createShader(
                              Rect.fromLTRB(0, 0, rect.width, rect.height));
                    },
                    blendMode: BlendMode.darken,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: _data!['themb'],
                    ),
                  ), // image
                  Container(
                      padding: const EdgeInsets.fromLTRB(0, 10, 05, 0),
                      //alignment: Alignment.topLeft,
                      child: _data!['category'] == 'Hotel'
                          ? CategoryColors(
                              _data!, Colors.blue, Colors.white, Icons.hotel)
                          : _data!['category'] == 'Agence'
                              ? CategoryColors(_data!, Colors.red, Colors.white,
                                  Icons.account_balance)
                              : _data!['category'] == 'Residence'
                                  ? CategoryColors(_data!, Colors.green,
                                      Colors.white, Icons.apartment)
                                  : _data!['category'] == 'Autres'
                                      ? CategoryColors(
                                          _data!,
                                          Colors.deepPurple,
                                          Colors.white,
                                          Icons.category)
                                      : CategoryColors(_data!, Colors.black54,
                                          Colors.amber, Icons.attach_money)

                      // sponsors
                      ), // category
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: ListTile(
                      dense: true,
                      title: Text(
                        _data!['item'].toUpperCase(),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                          fontFamily: 'Oswald',
                        ),
                      ),
                      subtitle: Text(
                        _data!['code'].toUpperCase(),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          fontFamily: 'Oswald',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        '${_data!['price']}.00 DZD',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          fontFamily: 'Oswald',
                        ),
                      ),
                    ),
                  ), // price
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      NumberFormat.compact(locale: 'fr_IN')
                          .format(_data!['likes']),
                      overflow: TextOverflow.ellipsis,
                      style: _data!['usersLike'].toString().contains(user!.uid)
                          ? const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                              fontFamily: 'Oswald',
                            )
                          : const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                              fontFamily: 'Oswald',
                            ),
                    ),
                  ),

                  // like_class(dataid: dataid, data: _data,),
                  ///////////////////////////////////
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                    child: _data!['usersLike'].toString().contains(user.uid)
                        ? const Icon(
                            FontAwesomeIcons.solidHeart,
                            color: Colors.redAccent,
                            size: 15,
                          )
                        : const Icon(
                            FontAwesomeIcons.heart,
                            color: Colors.blue,
                            size: 15,
                          ),
                  ),
                  ///////////////////////////////////
                  // user == null
                  //     ? IconButtonWidget1(
                  //               IconVar: FontAwesomeIcons.solidHeart,
                  //               likecolor: Colors.grey,
                  //               function: () {
                  //                 Navigator.of(context).push(MaterialPageRoute(
                  //                     builder: (context) => MainPageAuth()));
                  //               },
                  //               likes: _data!['likes'],
                  //             )
                  //
                  //
                  //     : _data!['usersLike'].toString().contains(user.uid)
                  //         ? IconButtonWidget1(
                  //                   IconVar: FontAwesomeIcons.solidHeart,
                  //                   likecolor: Colors.red,
                  //                   function: () async {
                  //                     //final user = FirebaseAuth.instance.currentUser;
                  //                     FirebaseFirestore.instance
                  //                         .collection('Products')
                  //                         .doc(dataid)
                  //                         .update({
                  //                       'likes': FieldValue.increment(-1),
                  //   buttonSize = 30          'usersLike':
                  //                           FieldValue.arrayRemove([user.uid]),
                  //                     });
                  //                   },
                  //                   likes: _data!['likes'],
                  //                 )
                  //         : IconButtonWidget1(
                  //                   IconVar: FontAwesomeIcons.heart,
                  //                   likecolor: Colors.blue,
                  //                   function: () async {
                  //                     //final user = FirebaseAuth.instance.currentUser;
                  //                     FirebaseFirestore.instance
                  //                         .collection('Products')
                  //                         .doc(dataid)
                  //                         .update({
                  //                       'likes': FieldValue.increment(1),
                  //                       'usersLike':
                  //                           FieldValue.arrayUnion([user.uid]),
                  //                     });
                  //                   },
                  //                   likes: _data!['likes'],
                  //                 ),
                  ////////////////////////////////////////////////////////////////
                  // _data!['usersLike'].toString().contains(user!.uid)
                  //     ? LikeButton(
                  //         size: 20,
                  //         circleColor: CircleColor(
                  //             start: Color(0xffdc1b4e), end: Color(0xffb71c1c)),
                  //         bubblesColor: BubblesColor(
                  //           dotPrimaryColor: Color(0xffea0c0c),
                  //           dotSecondaryColor: Color(0xffb71c1c),
                  //         ),
                  //         likeBuilder: (bool isLiked) {
                  //           return Icon(
                  //             FontAwesomeIcons.solidHeart,
                  //             color: Colors.redAccent,
                  //             size: 20,
                  //           );
                  //         },
                  //         //likeCount: _data!['likes'],
                  //         onTap: onLikeButtonTapped,
                  //       )
                  //     : LikeButton(
                  //         size: 20,
                  //         circleColor: CircleColor(
                  //             start: Color(0xff1d77de), end: Color(0xff431cb7)),
                  //         bubblesColor: BubblesColor(
                  //           dotPrimaryColor: Color(0xff0c38ea),
                  //           dotSecondaryColor: Color(0xff1c31b7),
                  //         ),
                  //         likeBuilder: (bool isLiked) {
                  //           return Icon(
                  //             FontAwesomeIcons.heart,
                  //             color: Colors.blue,
                  //             size: 20,
                  //           );
                  //         },
                  //         // likeCount:
                  //         //   _data!['likes'],
                  //         onTap: onDisLikeButtonTapped,
                  //       )
                  ///////////////////////////////////////////////////////////
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row CategoryColors(Map<dynamic, dynamic> data, customColor, customColor2,
      IconData? customIcon) {
    return Row(
      children: [
        Flexible(
          flex: 4,
          fit: FlexFit.loose,
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              '${' ' + data['category'].toUpperCase()} ',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                backgroundColor: customColor, //Colors.blue,
                color: customColor2,
                fontWeight: FontWeight.normal,
                fontSize: 12,
                fontFamily: 'Oswald',
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: CircleAvatar(
            radius: 10,
            backgroundColor: customColor,
            //radius: 30,
            child: Container(
              child: Icon(
                customIcon, //Icons.hotel,
                color: customColor2,
                size: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    /// send your request here
    // final bool success= await sendRequest();

    final user = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance.collection('Products').doc(dataid).update({
      'likes': FieldValue.increment(-1),
      'usersLike': FieldValue.arrayRemove([user!.uid]),
    });

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;

    return !isLiked;
  }

  Future<bool> onDisLikeButtonTapped(bool isLiked) async {
    /// send your request here
    // final bool success= await sendRequest();

    final user = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance.collection('Products').doc(dataid).update({
      'likes': FieldValue.increment(1),
      'usersLike': FieldValue.arrayUnion([user!.uid]),
    });

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;

    return !isLiked;
  }
}

// class IconButtonWidget1 extends StatelessWidget {
//   const IconButtonWidget1({
//     Key? key,
//     required this.likes,
//     required MaterialColor likecolor,
//     required this.IconVar,
//     required this.function,
//   })  : _likecolor = likecolor,
//         super(key: key);
//
//   final likes;
//   final MaterialColor _likecolor;
//   final IconData? IconVar;
//   final function;
//
//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       padding: const EdgeInsets.all(0.0),
//       // alignment: Alignment.centerRight,
//       icon: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           // Expanded(
//           //   flex: 3,
//           //   child: Align(
//           //     alignment: Alignment.centerRight,
//           //     child: Text(likes.toString(),
//           //       //.toUpperCase(),
//           //       overflow: TextOverflow.ellipsis,
//           //       style: TextStyle(
//           //         color: _likecolor, //Colors.grey,
//           //         fontWeight: FontWeight.normal,
//           //         fontSize: 14,
//           //         fontFamily: 'Oswald',
//           //       ),
//           //     ),
//           //   ),
//           // ),
//           Expanded(
//             flex: 1,
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
//               child: Icon(
//                 IconVar,
//                 size: 18,
//                 color: _likecolor, //Colors.grey
//               ),
//             ),
//           ),
//         ],
//       ),
//       onPressed: function,
//     );
//   }
// }

class CardTopShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool enabled = true;
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          enabled: enabled,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 2,
            semanticContainer: true,
            //color:, Colors.white70,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width * 0.30,
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(),
                        Container(),
                        Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          enabled: enabled,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 2,
            semanticContainer: true,
            //color: Colors.white70,
            child: SizedBox(
              height: MediaQuery.of(context).size.width * 0.15,
              width: MediaQuery.of(context).size.width * 0.30,
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(),
                        Container(),
                        Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          //period: Duration(milliseconds: 3000),
          enabled: enabled,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 2,
            semanticContainer: true,
            //color: Colors.white70,
            child: SizedBox(
              height: MediaQuery.of(context).size.width * 0.15,
              width: MediaQuery.of(context).size.width * 0.30,
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(),
                        Container(),
                        Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Card buildCardDetail(Map<dynamic, dynamic> data, dataid) {
  final docidd = data['userID'].toString();

  final DocumentReference userRefDocument =
      FirebaseFirestore.instance.collection('Users').doc(docidd.trim());

  final user = FirebaseAuth.instance.currentUser;
  return Card(
    child: Column(
      children: [
        Expanded(
          flex: 6,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ShaderMask(
                shaderCallback: (rect) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black],
                  ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                },
                blendMode: BlendMode.darken,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: data['themb'],
                  placeholder: (context, url) => const Center(
                      //child: CircularProgressIndicator(),
                      ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ), // image
              Column(
                children: [
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 35, 15, 0),
                        //alignment: Alignment.topLeft,
                        child: data['category'] == 'Hotel'
                            ? CategoryColors(
                                data, Colors.blue, Colors.white, Icons.hotel)
                            : data['category'] == 'Agence'
                                ? CategoryColors(data, Colors.red, Colors.white,
                                    Icons.account_balance)
                                : data['category'] == 'Residence'
                                    ? CategoryColors(data, Colors.green,
                                        Colors.white, Icons.apartment)
                                    : data['category'] == 'Autres'
                                        ? CategoryColors(
                                            data,
                                            Colors.deepPurple,
                                            Colors.white,
                                            Icons.category)
                                        : CategoryColors(data, Colors.black54,
                                            Colors.amber, Icons.attach_money)

                        // sponsors
                        ),
                  ), // category

                  // Container(
                  //   alignment: Alignment.bottomCenter,
                  //   child: ListTile(
                  //     dense: true,
                  //     leading:
                  //     // CachedNetworkImage(
                  //     //   fit: BoxFit.cover,
                  //     //   imageUrl: data_user['themb'],
                  //     //   placeholder: (context, url) => const Center(
                  //     //       //child: CircularProgressIndicator(),
                  //     //       ),
                  //     //   errorWidget: (context, url, error) =>
                  //     //       const Icon(Icons.error),
                  //     // ),
                  Text(
                    data['item'].toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 17,
                      fontFamily: 'Oswald',
                    ),
                  ),
                  Text(
                    data['code'].toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: 'Oswald',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder(
                      future: userRefDocument.get(),
                      //.where('userID', isEqualTo: userIDD).get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData) {
                          return User_SharingWidget(snapshot: snapshot);
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ), // picture
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '${data['price']}.00 DZD',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'Oswald',
                      ),
                    ),
                  ),
                ), // price
                Align(
                  alignment: Alignment.topRight,
                  child: data['usersLike'].toString().contains(user!.uid)
                      ? Row(
                          children: [
                            Text(
                              data['likes'].toString(),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                fontFamily: 'Oswald',
                              ),
                            ),
                            LikeButton(
                              size: 20,
                              circleColor: const CircleColor(
                                  start: Color(0xffdc1b4e),
                                  end: Color(0xffb71c1c)),
                              bubblesColor: const BubblesColor(
                                dotPrimaryColor: Color(0xffea0c0c),
                                dotSecondaryColor: Color(0xffb71c1c),
                              ),
                              likeBuilder: (bool isLiked) {
                                return const Icon(
                                  FontAwesomeIcons.solidHeart,
                                  color: Colors.redAccent,
                                  size: 20,
                                );
                              },
                              //likeCount: _data!['likes'],
                              onTap: onLikeButtonTapped(dataid),
                            ), // icon hearth
                          ],
                        )
                      : Row(
                          children: [
                            Text(
                              data['likes'].toString(),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                fontFamily: 'Oswald',
                              ),
                            ),
                            LikeButton(
                              size: 20,
                              circleColor: const CircleColor(
                                  start: Color(0xff1d77de),
                                  end: Color(0xff431cb7)),
                              bubblesColor: const BubblesColor(
                                dotPrimaryColor: Color(0xff0c38ea),
                                dotSecondaryColor: Color(0xff1c31b7),
                              ),
                              likeBuilder: (bool isLiked) {
                                return const Icon(
                                  FontAwesomeIcons.heart,
                                  color: Colors.blue,
                                  size: 20,
                                );
                              },
                              // likeCount:
                              //   _data!['likes'],
                              onTap: onDisLikeButtonTapped(dataid),
                            ), // icon hearth
                          ],
                        ),
                ), // likes
              ],
            ),
          ),
        ), // price & likes
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                data['createdAt'].toDate().toString(),
                //overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                  fontFamily: 'Oswald',
                ),
              ),
            ),
          ),
        ), // timesptamp
        Expanded(
          flex: 10,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                data['Description'],
                //overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  fontFamily: 'Oswald',
                ),
              ),
            ),
          ),
        ), // description// Description
      ],
    ),
  );
}

class User_SharingWidget extends StatelessWidget {
  const User_SharingWidget({
    Key? key,
    required this.snapshot,
  }) : super(key: key);

  final AsyncSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Chip(
          padding: const EdgeInsets.all(3),
          elevation: 0.5,
          avatar: CircleAvatar(
            backgroundImage:
                NetworkImage('${snapshot.data.data()['userAvatar']}'),
          ),
          label: Text(
            snapshot.data['userDisplayName'] ?? "inconnu",
            style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
                fontFamily: 'Oswald',
                fontWeight: FontWeight.normal,
                fontSize: 14),
          ),
          backgroundColor: Colors.blueGrey,
        ),
      ),
    );
  }
}

onDisLikeButtonTapped(dataid) async {
  final user = FirebaseAuth.instance.currentUser;
  await FirebaseFirestore.instance.collection('Products').doc(dataid).update({
    'likes': FieldValue.increment(1),
    'usersLike': FieldValue.arrayUnion([user!.uid]),
  });
}

onLikeButtonTapped(dataid) async {
  final user = FirebaseAuth.instance.currentUser;
  await FirebaseFirestore.instance.collection('Products').doc(dataid).update({
    'likes': FieldValue.increment(-1),
    'usersLike': FieldValue.arrayRemove([user!.uid]),
  });
}

Row CategoryColors(Map<dynamic, dynamic> data, customColor, customColor2,
    IconData? customIcon) {
  return Row(
    children: [
      Flexible(
        flex: 4,
        fit: FlexFit.loose,
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            '${' ' + data['category'].toUpperCase()} ',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              backgroundColor: customColor,
              //Colors.blue,
              color: customColor2,
              fontWeight: FontWeight.normal,
              fontSize: 12,
              fontFamily: 'Oswald',
            ),
          ),
        ),
      ),
      Align(
        alignment: Alignment.topRight,
        child: CircleAvatar(
          radius: 10,
          backgroundColor: customColor,
          //radius: 30,
          child: Container(
            child: Icon(
              customIcon, //Icons.hotel,
              color: customColor2,
              size: 12,
            ),
          ),
        ),
      ),
    ],
  );
}
