import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/ProvidersPublic.dart';
import '../pages/adminLoggedPage.dart';
import 'Ogoogle/googleSignInProvider.dart';
import 'VerifyEmailPage.dart';

class CheckRole extends StatelessWidget {
  final String documentId;

  CheckRole(this.documentId);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Users")
          .doc(documentId)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          // Handle error
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        // Document exists, retrieve data
        var data = snapshot.data;
        if (data!.exists) {
          var userRole = data['role'];
          // Check user role
          if (userRole == "admin") {
            return adminLoggedPage(); // Normalement Tani Premium Page
          } else {
            return MyApp(
              userDoc: data,
            );
            // NavigationExample(
            //   userDoc: data,
            // );
            //     publicLoggerPage(
            //   datta: data,
            // );
          }
        } else
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Marhba Bik'),
                  // ElevatedButton(
                  //     onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  //         context, '/', (_) => false),
                  //     child: Text('aya nebdou')),
                  Padding(
                    padding: const EdgeInsets.all(28.0),
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
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      onPressed: () async {
                        FirebaseAuth.instance.signOut();
                        final provider = Provider.of<googleSignInProvider>(
                            context,
                            listen: false);
                        await provider.logouta();
                        // Navigator.of(context).pop();
                        // Navigator.pop(context, true);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
      },
    );

    ;

    // FutureBuilder<DocumentSnapshot>(
    //   future: users.doc(documentId).get(),
    //   builder:
    //       (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    //     if (snapshot.hasError) {
    //       return Text("Something went wrong");
    //     }
    //
    //     if (snapshot.hasData && !snapshot.data!.exists) {
    //       return Scaffold(
    //         backgroundColor: Colors.white,
    //         appBar: AppBar(
    //           title: FittedBox(
    //             child: Text('Bienvenue'),
    //           ),
    //           centerTitle: true,
    //         ),
    //         body: Center(
    //           child: Padding(
    //             padding:
    //                 const EdgeInsets.symmetric(vertical: 8, horizontal: 38),
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 Padding(
    //                   padding: const EdgeInsets.all(58.0),
    //                   child: ElevatedButton(
    //                     child: Text('Log Out'),
    //                     onPressed: () {
    //                       googleSignInProvider().logouta();
    //                     },
    //                   ),
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.all(58.0),
    //                   child: ElevatedButton(
    //                     child: Text('Start'),
    //                     onPressed: () {
    //                       Navigator.of(context).pushNamedAndRemoveUntil(
    //                           '/', (Route<dynamic> route) => false);
    //                     },
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       );
    //     }
    //
    //     if (snapshot.connectionState == ConnectionState.done) {
    //       Map<String, dynamic> userRole =
    //           snapshot.data!.data() as Map<String, dynamic>;
    //       if (userRole['Role'] == 'admin') {
    //         return adminLoggedPage();
    //       } else {
    //         return publicLoggerPage();
    //       }
    //     }
    //
    //     return Center(child: CircularProgressIndicator());
    //   },
    // );
  }
}
