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
          }
        } else
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Text(
                      'Bienvenue à Oran Veuillez\nSe Deconnecter & Reconnecter avec ton  Email & ton Mot de passe ou ton Compte Google',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  // ElevatedButton(
                  //     onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  //         context, '/', (_) => false),
                  //     child: Text('aya nebdou')),
                  Padding(
                    padding: const EdgeInsets.all(80.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black38,
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
                        style: TextStyle(fontSize: 20, color: Colors.white),
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
  }
}
