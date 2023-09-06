import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/ProvidersPublic.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<UserRealTime> userList = [];

  Object? get currentUser => FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  Future<void> getUsers() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Users').get();
    List<QueryDocumentSnapshot> documents = snapshot.docs;
    setState(() {
      userList =
          documents.map((doc) => UserRealTime.fromSnapshot(doc)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: userList.length,
        itemBuilder: (context, index) {
          final user = userList[index];

          return ListTile(
            onTap: () async {
              print('////////////////////////////////////////////////');
              print('selectedUser : ' + user.id);
              print('currentUser: ' + currentUser.toString());
              // await Navigator.of(context).push(
              //   MaterialPageRoute(
              //       builder: (context) => ChatScreen(
              //             id: user.id,
              //           )),
              // );
            },
            leading: Badge(
              backgroundColor: Colors.blue,
              alignment: AlignmentDirectional.topStart,
              largeSize: 20,
              textStyle: TextStyle(fontSize: 10),
              textColor: Colors.yellow,
              label: user.isOnline ? Text("On") : Text("Off"),
              isLabelVisible: true,
              child: ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.circular(200),
                  child: CachedNetworkImage(
                    imageUrl: user.avatar,
                    fit: BoxFit.cover,
                    height: 40,
                    width: 40,
                  )),
            ),
            title: Text(user.name),
            // trailing: user.isOnline
            //     ? CircleAvatar(backgroundColor: Colors.green)
            //     : null,
          );
        },
      ),
    );
  }
}

class UserRealTime {
  final String id;
  final String name;
  final bool isOnline;
  final String avatar;
  final String email;

  UserRealTime({
    required this.id,
    required this.name,
    required this.isOnline,
    required this.avatar,
    required this.email,
  });

  factory UserRealTime.fromSnapshot(QueryDocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return UserRealTime(
      id: data['id'],
      name: data['displayName'] ?? '',
      isOnline: data['state'] ?? false,
      avatar: data['avatar'] ?? '',
      email: data['email'] ?? '',
    );
  }
}
