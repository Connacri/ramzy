import 'dart:math';
import 'dart:ui';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/upload_random.dart';

import '../Oauth/Ogoogle/googleSignInProvider.dart';

class publicProfil extends StatelessWidget {
  const publicProfil({Key? key, required this.userRole}) : super(key: key);
  final userRole;

  @override
  Widget build(BuildContext context) {
    final userGoo = FirebaseAuth.instance.currentUser;
    //
    // final userDoc = Provider.of<SuperHero>(context, listen: false);
    // print(userDoc.userDisplayName);

    final double widthR = (MediaQuery.of(context).size.width -
            MediaQuery.of(context).size.width * 0.6) /
        2;

    Random random = new Random();
    var index = random.nextInt(15);

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          CarouselSlider.builder(
            itemCount: 15,
            itemBuilder: (BuildContext context, int index, int pageViewIndex) =>
                ShaderMask(
              shaderCallback: (rect) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomLeft,
                  colors: [Colors.transparent, Colors.black],
                ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
              },
              blendMode: BlendMode.darken,
              child: CachedNetworkImage(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
                imageUrl:
                    'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/mob%2Fmob%20(${index}).jpg?alt=media&token=9d17aa6e-0622-4d1f-bf78-97c0fe87da77',
                errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                  color: Colors.red,
                ),
              ),
            ),
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height,
              aspectRatio: 16 / 9,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 10),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0,
              //onPageChanged: callbackFunction,
              scrollDirection: Axis.horizontal,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  AvatarGlow(
                    glowColor: Colors.white,
                    endRadius: 60.0,
                    child: Material(
                      // Replace this child with your own
                      elevation: 8.0,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(userRole['userAvatar']),
                        radius: 30.0,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 27,
                    bottom: 27,
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.blue,
                    ),
                  )
                ],
              ),
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(15),
              //   child: BackdropFilter(
              //     filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              //     child: Container(
              //       padding: EdgeInsets.all(15),
              //       alignment: Alignment.center,
              //       color: Colors.grey.withOpacity(0.3),
              //       width: MediaQuery.of(context).size.width * 0.6,
              //       child: FittedBox(
              //         child: RatingBar.builder(
              //           initialRating:
              //               double.parse(userRole['userItemsNbr'].toString()),
              //           ignoreGestures: true,
              //           minRating: 1,
              //           direction: Axis.horizontal,
              //           allowHalfRating: true,
              //           itemCount: 5,
              //           itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              //           itemBuilder: (context, _) => Icon(
              //             Icons.star,
              //             color: Colors.amber,
              //           ),
              //           onRatingUpdate: (rating) {
              //             print(rating);
              //           },
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: FittedBox(
                    child: Text(
                      userRole['userDisplayName'].toString().toUpperCase(),
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                width: MediaQuery.of(context).size.width * 0.3,
                child: FittedBox(
                  child: userRole['userRole'] == 'admin'
                      ? ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (Rect bounds) => LinearGradient(
                                colors: <Color>[
                                  Colors.red,
                                  Colors.yellowAccent,
                                  Color.fromRGBO(246, 132, 2, 1.0),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds),
                          child: Text(
                            userRole['userRole'].toString().toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontWeight: FontWeight.bold),
                          ))
                      : Text(
                          userRole['userRole'].toString().toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 50,
                              fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.58,
                child: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      userGoo!.emailVerified == true
                          ? Icon(
                              Icons.check_circle,
                              color: Colors.blue,
                            )
                          : Icon(
                              Icons.not_interested_outlined,
                              color: Colors.red,
                            ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        userGoo.email.toString().toUpperCase(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              // Container(
              //   width: MediaQuery.of(context).size.width * 0.6,
              //   child: FittedBox(
              //     child: Text(
              //       userGoo.phoneNumber != null
              //           ? userGoo.phoneNumber.toString()
              //           : ' '.toUpperCase(),
              //       style: TextStyle(color: Colors.white),
              //     ),
              //   ),
              // ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthR, vertical: 50),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blueGrey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 4.0,
                      minimumSize: const Size.fromHeight(50)),
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                  label: const Text(
                    'Deconnexion',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  onPressed: () async {
                    FirebaseAuth.instance.signOut();
                    final provider = Provider.of<googleSignInProvider>(context,
                        listen: false);
                    await provider.logouta();

                    Navigator.pop(context, true);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
