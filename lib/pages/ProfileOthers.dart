import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_date/dart_date.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'itemDetails.dart';
import 'item_details-statefull.dart';

class ProfileOthers extends StatefulWidget {
  const ProfileOthers({
    Key? key,
    required Map? data,
  })  : datauser = data,
        //**************
        super(key: key);

  final Map? datauser;

  @override
  State<ProfileOthers> createState() => _ProfileOthersState();
}

class _ProfileOthersState extends State<ProfileOthers>
    with TickerProviderStateMixin {
  final double coverHeight = 200;
  final double profileHeight = 90;
  final bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    final topPic = coverHeight - profileHeight - 35;
    timeago.setLocaleMessages('fr', timeago.FrMessages());
    TabController _tabController = TabController(length: 2, vsync: this);

    return Scaffold(
      body: ListView(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              BuildCoverImage(),
              // Positioned(top: topPic, child: Container(child: BuildProfileImage())),
              Positioned(
                top: topPic,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 4, color: Colors.white),
                      borderRadius: BorderRadius.circular(100)),
                  child: Stack(
                    //alignment : Alignment.center,
                    fit: StackFit.passthrough,
                    children: [
                      CircleAvatar(
                          radius: profileHeight / 2,
                          backgroundImage:
                              widget.datauser!['userAvatar'] != null
                                  ? NetworkImage(widget.datauser!['userAvatar'])
                                  : const NetworkImage(
                                      'https://source.unsplash.com/random/900×700/?fruit',
                                    )
                          //'https://source.unsplash.com/random?sig=8'),
                          ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                    'Créer Le ${DateTime.parse(widget.datauser!['createdAt'].toDate().toString()).format('dd MMMM yyyy', 'fr_FR')}',
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                      fontFamily: 'Oswald',
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                    'Dernière Connexion ${timeago.format(widget.datauser!['lastActive'].toDate(), locale: 'fr')}',
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                      fontFamily: 'Oswald',
                    )),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              widget.datauser!['displayName'].toUpperCase(),
              style: const TextStyle(
                  color: Colors.black54,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Oswald',
                  fontSize: 20),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 100,
            ),
            width: MediaQuery.of(context).size.width / 3,
            child: FittedBox(
              child: RatingBar.builder(
                initialRating: widget.datauser!['stars'],
                // double.parse(snapshot
                //     .data!.docs[index]['stars']
                //     .toString()),
                ignoreGestures: true,
                minRating: 1,
                direction: Axis.horizontal,

                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: widget.datauser!['plan'] == 'premium'
                  ? const Icon(
                      Icons.workspace_premium,
                      color: Colors.amber,
                      size: 40,
                    )
                  : const Icon(
                      Icons.workspace_premium,
                      color: Colors.blueGrey,
                      size: 40,
                    ),
              label: Text(
                widget.datauser!['plan'].toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Oswald',
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis,
                ),
              ), // <-- Text
            ),
          ),
          Center(
            child: Text(
              widget.datauser!['email'].toUpperCase(),
              style: const TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.normal,
                fontFamily: 'Oswald',
                fontSize: 10,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.call,
                    color: Colors.green,
                  ),
                  onPressed: () async {
                    final Uri launchUrlR = Uri(
                        scheme: 'Tel',
                        path: '+213${widget.datauser!['phone']}');
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
                        "whatsapp://send?phone=+213${widget.datauser!['phone']}" +
                            "&text=${Uri.encodeComponent(msg)}";

                    final Uri launchUrlRW = Uri(
                        scheme: 'Tel',
                        path: "+213${widget.datauser!['phone']}" +
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
          TabBar(controller: _tabController, tabs: [
            Tab(text: 'Items', icon: Icon(Icons.production_quantity_limits)),
            Tab(text: 'Posts', icon: Icon(Icons.post_add)),
          ]),
          Container(
            width: double.maxFinite, //MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: TabBarView(controller: _tabController, children: [
              PostListOfUserProfile(
                datauser: widget.datauser,
                collection: 'Products',
              ),
              PostListOfUserProfile(
                datauser: widget.datauser,
                collection: 'Instalives',
              ),
            ]),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  Widget BuildCoverImage() => Container(
        color: Colors.grey,
        child: CachedNetworkImage(
          imageUrl: 'https://source.unsplash.com/random/?city,night',
          //'https://source.unsplash.com/random',
          //'https://source.unsplash.com/random?sig=15',
          width: double.infinity,
          height: coverHeight,
          fit: BoxFit.cover,
        ),
      );

  Widget BuildProfileImage() => Stack(
        //alignment : Alignment.center,
        fit: StackFit.passthrough,
        children: [
          CircleAvatar(
              radius: profileHeight / 2,
              backgroundImage: widget.datauser != null
                  ? NetworkImage(widget.datauser!['userAvatar'])
                  : const NetworkImage(
                      'https://source.unsplash.com/random/900×700/?fruit',
                    )
              //'https://source.unsplash.com/random?sig=8'),
              ),
        ],
      );
}

class PostListOfUserProfile extends StatelessWidget {
  const PostListOfUserProfile({
    super.key,
    required this.datauser,
    required this.collection,
  });

  final Map? datauser;
  final String collection;

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
          return Container();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
          ),
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              if (data.length >= 6) {
                print('vous devez acheter premium');
              }
              final userm = FirebaseAuth.instance.currentUser;
              return Card(
                clipBehavior: Clip.antiAlias,
                elevation: 1,
                child: ListTile(
                  minLeadingWidth: 0,
                  visualDensity: VisualDensity.compact,
                  //contentPadding: EdgeInsets.zero,
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                        imageUrl: data['themb'],
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    data['Description'], //.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                      fontFamily: 'Oswald',
                    ),
                  ),
                  subtitle: Text(
                    '${data['price']}.00 DZD',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      fontFamily: 'Oswald',
                    ),
                  ),
                  isThreeLine: true,
                  dense: true,
                  trailing: userm!.uid != datauser!['userID']
                      ? Text('')
                      : IconButton(
                          icon: Icon(Icons.delete),
                          // onPressed: () {
                          //   FirebaseFirestore.instance
                          //       .collection('Products')
                          //       .doc(document.id)
                          //       .delete();
                          // },
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('Users')
                                .doc(datauser!['userID'])
                                .update({
                              'userItemsNbr': FieldValue.increment(-1)
                            }).whenComplete(() => FirebaseFirestore.instance
                                    .collection(
                                        'Products') //.collection('cart')
                                    .doc(document.id)
                                    .delete());

                            Navigator.pop(context, true);
                          },
                        ),
                  onTap: () async {
                    await Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext) {
                      return Hero(
                        tag: 'Hero_Items',
                        child: SilverdetailItem(
                          data: data,
                          idDoc: document.id,
                        ),

                        //
                        // item_details_statefull(
                        //   data: data,
                        //   user: userm,
                        //   isLiked: data['usersLike']
                        //       .toString()
                        //       .contains(userm.uid),
                        //   docid: document.id,
                        //   docidd: datauser!['userID'],
                        // ),
                      );
                    }));
                  },
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
