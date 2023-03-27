import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:flutterflow_paginate_firestore/widgets/bottom_loader.dart';
import 'package:flutterflow_paginate_firestore/widgets/empty_display.dart';
import 'package:flutterflow_paginate_firestore/widgets/empty_separator.dart';
import 'package:flutterflow_paginate_firestore/widgets/initial_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:ramzy/pages/profile_edit.dart';
import 'package:path/path.dart' as Path;
import '../Oauth/Ogoogle/googleSignInProvider.dart';
import '../Oauth/Privacy_Policy.dart';
import '../services/upload_random.dart';
import 'ProfileOthers.dart';
import 'itemDetails.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  late TabController _tabController;
  final userGoo = FirebaseAuth.instance.currentUser;
  late firebase_storage.Reference ref;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final picker = ImagePicker();

  PickedFile? _imageFile;
  String? _imageUrl;

  Future pickImage(ImageSource source) async {
    final pickedFile = await picker.getImage(
      source: source,
      maxHeight: 1080,
      maxWidth: 1920,
      imageQuality: 40,
    );
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Future uploadOneImage(String field) async {
    if (_imageFile == null) {
      return;
    }
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('Users/${Path.basename(_imageFile!.path)}');
    final uploadTask = firebaseStorageRef.putFile(File(_imageFile!.path));
    final snapshot = await uploadTask.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      _imageUrl = downloadUrl;
      saveImage(field);
    });
  }

  Future saveImage(String field) async {
    if (_imageUrl == null) {
      return;
    }
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final firestoreRef =
        FirebaseFirestore.instance.collection('Users').doc(userGoo!.uid);
    await firestoreRef.update({field: _imageUrl});
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 2, vsync: this);
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('Users')
            .doc(userGoo!.uid)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Icon(Icons.error);
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Icon(Icons.account_box);
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            return CustomScrollView(slivers: <Widget>[
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
                          data['displayName'] ?? '',
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        child: Text(
                          data['email'],
                          style: TextStyle(fontSize: 8),
                        ),
                      ),
                    ],
                  ),
                  background: Stack(
                    fit: StackFit.expand,
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
                          fit: BoxFit.cover,
                          imageUrl: data['timeline'] ??
                              'https://source.unsplash.com/random?sig=20*3+1',
                          errorWidget: (context, url, error) => const Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 36,
                        bottom: 36,
                        child: IconButton(
                          icon: Icon(Icons.add_a_photo),
                          color: Colors.black,
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return SafeArea(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        leading: Icon(Icons.camera_alt),
                                        title: Text('Camera'),
                                        onTap: () {
                                          pickImage(ImageSource.camera).then(
                                            (value) =>
                                                uploadOneImage('timeline'),
                                          );
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.photo_album),
                                        title: Text('Gallery'),
                                        onTap: () {
                                          pickImage(ImageSource.gallery).then(
                                            (value) =>
                                                uploadOneImage('timeline'),
                                          );
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                Column(
                  children: [
                    Stack(
                      children: [
                        AvatarGlow(
                          glowColor: Colors.black54,
                          endRadius: 60.0,
                          child: Material(
                            elevation: 8.0,
                            shape: CircleBorder(),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(data['avatar']),
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
                        ),
                        Positioned(
                          right: 36,
                          bottom: 36,
                          child: IconButton(
                            icon: Icon(Icons.add_a_photo),
                            color: Colors.black,
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return SafeArea(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ListTile(
                                          leading: Icon(Icons.camera_alt),
                                          title: Text('Camera'),
                                          onTap: () {
                                            pickImage(ImageSource.camera).then(
                                              (value) =>
                                                  uploadOneImage('avatar'),
                                            );
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.photo_album),
                                          title: Text('Gallery'),
                                          onTap: () {
                                            pickImage(ImageSource.gallery).then(
                                              (value) =>
                                                  uploadOneImage('avatar'),
                                            );
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    // Column(
                    //   children: [
                    //     if (_imageFile != null)
                    //       Container(
                    //         height: 200,
                    //         child: Image.file(File(_imageFile!.path)),
                    //       ),
                    //     ElevatedButton(
                    //       onPressed: () {
                    //         showModalBottomSheet(
                    //           context: context,
                    //           builder: (BuildContext context) {
                    //             return SafeArea(
                    //               child: Column(
                    //                 mainAxisSize: MainAxisSize.min,
                    //                 children: <Widget>[
                    //                   ListTile(
                    //                     leading: Icon(Icons.camera_alt),
                    //                     title: Text('Camera'),
                    //                     onTap: () {
                    //                       pickImage(ImageSource.camera);
                    //                       Navigator.of(context).pop();
                    //                     },
                    //                   ),
                    //                   ListTile(
                    //                     leading: Icon(Icons.photo_album),
                    //                     title: Text('Gallery'),
                    //                     onTap: () {
                    //                       pickImage(ImageSource.gallery);
                    //                       Navigator.of(context).pop();
                    //                     },
                    //                   ),
                    //                 ],
                    //               ),
                    //             );
                    //           },
                    //         );
                    //       },
                    //       child: Text('Choose Image'),
                    //     ),
                    //     ElevatedButton(
                    //       onPressed: uploadOneImage,
                    //       child: Text('Upload Image'),
                    //     ),
                    //     if (_imageUrl != null)
                    //       Container(
                    //         height: 200,
                    //         child: Image.network(_imageUrl!),
                    //       ),
                    //     ElevatedButton(
                    //       onPressed: saveImage,
                    //       child: Text('Save Image'),
                    //     ),
                    //   ],
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => profile_edit(
                                  userDoc: data,
                                ), //MainPageAuth(),
                                //  AuthPage(),
                              ));
                            },
                            icon: Icon(
                              Icons.mode_edit,
                              size: 16,
                            )),
                        Text(data['displayName'].toUpperCase()),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        userGoo?.emailVerified == true
                            ? Icon(
                                Icons.check_circle,
                                color: Colors.blue,
                              )
                            : Icon(
                                Icons.not_interested_outlined,
                                color: Colors.red,
                              ),
                        Text(userGoo!.email.toString().toUpperCase()),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(userGoo?.emailVerified != true
                      ? 'Email Not Verified'
                      : ''),
                ),
                Center(
                  child: data['phone'] == null
                      ? Text('${userGoo!.phoneNumber ?? ' '.toUpperCase()}',
                          style: const TextStyle())
                      : Text('+213 ${data['phone']}'),
                ),

                // Text(userGoo.phoneNumber != null
                //     ? userGoo.phoneNumber.toString()
                //     : ' '.toUpperCase()),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 38),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.black54,
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
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      FirebaseAuth.instance.signOut();
                      final provider = Provider.of<googleSignInProvider>(
                          context,
                          listen: false);
                      await provider.logouta();
// Navigator.of(context).pop();
                      Navigator.pop(context, true);
                    },
                  ),
                ),
                data['email'] == 'forslog@gmail.com'
                    ? Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 50),
                        child: IconButton(
                          icon: Icon(
                            Icons.add_box_rounded,
                            color: Colors.blue,
                          ),
                          onPressed: () async {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => upload_random()));
                          },
                        ),
                      )
                    : Container(),
              ])),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    TabBar(controller: _tabController, tabs: [
                      Tab(
                          text: 'Items',
                          icon: Icon(Icons.production_quantity_limits)),
                      Tab(text: 'Posts', icon: Icon(Icons.post_add)),
                    ]),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          PostListOfMyProfil(
                            userID: userGoo!.uid,
                            collection: 'Products',
                          ),
                          PostListOfMyProfil(
                            userID: userGoo!.uid,
                            collection: 'Instalives',
                          ),
                        ],
                        //),
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              Privacy_Policy(), //MainPageAuth(),
                          //  AuthPage(),
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Privacy Policy'),
                      ),
                    ),
                  ),
                ),
              )
            ]);
          }

          return Text("loading");
        },
      ),
    );
  }
}

class PostListOfMyProfil extends StatelessWidget {
  const PostListOfMyProfil({
    Key? key,
    required this.userID,
    required this.collection,
  }) : super(key: key);

  final userID;
  final String collection;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection(collection)
          .where('userID', isEqualTo: userID)
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
                  trailing: userm!.uid != userID
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
                                .doc(userID)
                                .update({
                              'userItemsNbr': FieldValue.increment(-1)
                            }).whenComplete(() => FirebaseFirestore.instance
                                    .collection(
                                        'Products') //.collection('cart')
                                    .doc(document.id)
                                    .delete());

                            //Navigator.pop(context, true);
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

Future<bool?> showConfirmationDialog(BuildContext context, String documentID) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirmation'),
        content: Text('Etes Vous Sur De Proceder à La Supression?'),
        actions: <Widget>[
          ElevatedButton(
            child: Text('No'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          ElevatedButton(
            child: Text('Yes'),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('Products')
                  .doc(documentID)
                  .delete()
                  .whenComplete(
                    () => Navigator.of(context).pop(),
                  );
            },
          ),
        ],
      );
    },
  );
}
