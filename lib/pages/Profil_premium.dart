import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ramzy/pages/ProfileOthers.dart';
import 'package:ramzy/pages/itemDetails.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class Profil_premium extends StatelessWidget {
  const Profil_premium({
    Key? key,
    required Map? data,
  })  : datauser = data,
        //**************
        super(key: key);

  final Map? datauser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
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
                    datauser!['timeline'],
                  ),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: AvatarGlow(
                  glowColor: Colors.white,
                  endRadius: 80.0,
                  child: Container(
                    width: 80.0,
                    height: 80.0,
                    child: CachedNetworkImage(
                      imageUrl: datauser!['avatar'],
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 4, color: Colors.white),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.no_accounts_rounded),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  datauser!['displayName'],
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      NumberFormat.compact().format(datauser!['views'] ?? 0),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.call,
                        color: Colors.green,
                        size: 30,
                      ),
                      onPressed: () async {
                        final Uri launchUrlR = Uri(
                            scheme: 'Tel', path: '+213${datauser!['phone']}');
                        if (await canLaunchUrl(launchUrlR)) {
                          await launchUrl(launchUrlR);
                        } else {
                          print('This Call Cant execute');
                        }
                      }),
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                      icon: Icon(
                        FontAwesomeIcons.whatsapp,
                        color: Colors.green,
                        size: 30,
                      ),
                      onPressed: () async {
                        //var phone = 00971566129156;
                        String msg = 'Hello Oran';
                        var whatsappUrl =
                            "whatsapp://send?phone=+213${datauser!['phone']}" +
                                "&text=${Uri.encodeComponent(msg)}";

                        final Uri launchUrlRW = Uri(
                            scheme: 'Tel',
                            path: "+213${datauser!['phone']}" +
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
              Padding(
                padding: const EdgeInsets.only(left: 5, bottom: 5),
                child: Text(
                    'Créer ' +
                        timeago.format(datauser!['createdAt'].toDate(),
                            locale: 'fr'),
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                      fontFamily: 'Oswald',
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, bottom: 5),
                child: Text(
                    'Dernière connexion ' +
                        timeago.format(datauser!['lastActive'].toDate(),
                            locale: 'fr'),
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                      fontFamily: 'Oswald',
                    )),
              ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
              //   child: Row(
              //     children: [
              //       Text(
              //         'Ses ',
              //         textAlign: TextAlign.start,
              //         style: TextStyle(
              //           fontStyle: FontStyle.italic,
              //           fontSize: 20,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.yellow, //Colors.yellow),
              //         ),
              //       ),
              //       Text(
              //         'Annonces',
              //         textAlign: TextAlign.start,
              //         style: TextStyle(
              //           fontStyle: FontStyle.italic,
              //           fontSize: 20,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.white70, //Colors.white70),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Expanded(
                child: PostListOfUserPremium(
                  datauser: datauser,
                  collection: 'Products',
                  size: 100,
                  text1: 'Ses',
                  text2: 'Annonces',
                  color1: Colors.yellow,
                  color2: Colors.white70,
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
              //   child: Row(
              //     children: [
              //       Text(
              //         'Ses ',
              //         textAlign: TextAlign.start,
              //         style: TextStyle(
              //           fontStyle: FontStyle.italic,
              //           fontSize: 20,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.white70, //Colors.yellow),
              //         ),
              //       ),
              //       Text(
              //         'Publications',
              //         textAlign: TextAlign.start,
              //         style: TextStyle(
              //           fontStyle: FontStyle.italic,
              //           fontSize: 20,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.blue, //Colors.white70),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Expanded(
                child: PostListOfUserPremium(
                  datauser: datauser,
                  collection: 'Instalives',
                  size: 200,
                  text1: 'Ses',
                  text2: 'Publications',
                  color1: Colors.white70,
                  color2: Colors.blue,
                ),
              ),
              SizedBox(
                height: 80,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PostListOfUserPremium extends StatelessWidget {
  const PostListOfUserPremium({
    super.key,
    required this.datauser,
    required this.collection,
    required this.size,
    required this.text1,
    required this.text2,
    required this.color1,
    required this.color2,
  });

  final Map? datauser;
  final String collection;
  final double size;
  final String text1;
  final String text2;
  final Color color1;
  final Color color2;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection(collection)
          .where('userID', isEqualTo: datauser!['id'])
          //.limit(3)
          //.orderBy('createdAt', descending: true)
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
          ),
          child: ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            // physics: const NeverScrollableScrollPhysics(),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              var dataid = document.id;
              if (data.length >= 6) {
                print('vous devez acheter premium');
              }

              final userm = FirebaseAuth.instance.currentUser;
              return GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SilverdetailItem(
                    data: data,
                    idDoc: dataid,
                    isLiked: data['usersLike'].toString().contains(userm!.uid),
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
                                colors: [Colors.transparent, Colors.black],
                              ).createShader(
                                  Rect.fromLTRB(0, 0, rect.width, rect.height));
                            },
                            blendMode: BlendMode.darken,
                            child: CachedNetworkImage(
                              alignment: Alignment.topCenter,
                              fadeInDuration: Duration(seconds: 2),
                              fit: BoxFit.cover,
                              width: size,
                              height: 80,
                              imageUrl: data['themb'],
                              //iitem.documents[index]['themb'],
                              // 'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/carre%2Fcarre%20(${index + 1}).jpg?alt=media&token=68e384f1-bb64-47cf-a245-9f7f12202443',
                              errorWidget: (context, url, error) => const Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  NumberFormat.compact().format(
                                    data['likes'],
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
                        width: size,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            data['item'],
                            // iitem.documents[index]['item'],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      Container(
                        width: size,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: data['price'] >= 1000

                              //   iitem.documents[index]['price'] >= 1000
                              ? Text(
                                  NumberFormat.compactCurrency(
                                          symbol: 'DZD ', decimalDigits: 2)
                                      .format(data['price']
                                          //iitem.documents[index]['price']
                                          ),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 14),
                                )
                              : Text(
                                  NumberFormat.currency(
                                          symbol: 'DZD ', decimalDigits: 2)
                                      .format(data['price']
                                          //iitem.documents[index]['price']
                                          ),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 14),
                                ),
                        ),
                      ),
                      Container(
                        width: size,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            '${data['category']}-${data['levelItem']}',
                            //   '${iitem.documents[index]['category']}  ${iitem.documents[index]['levelItem']}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      // Container(
                      //   width: size,
                      //   child: Padding(
                      //     padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      //     child: Text(
                      //       data['createdAt']
                      //           //iitem.documents[index]['createdAt']
                      //           .toDate()
                      //           .toString(),
                      //       overflow: TextOverflow.ellipsis,
                      //       style: TextStyle(fontSize: 9),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
