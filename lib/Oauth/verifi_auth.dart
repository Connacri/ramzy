import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

import '../pages/homeList.dart';
import '../pages/unloggedHomeList.dart';
import '../pages/unloggerPublicPage.dart';
import 'CheckRole.dart';
import 'VerifyEmailPage.dart';

class verifi_auth extends StatefulWidget {
  const verifi_auth({Key? key}) : super(key: key);

  @override
  State<verifi_auth> createState() => _verifi_authState();
}

class _verifi_authState extends State<verifi_auth> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return const CircularProgressIndicator();
            // } else
            if (snapshot.hasError) {
              return const Center(child: Text('Probleme de Connexion'));
            }
            if (snapshot.hasData) {
              final userD = snapshot.data!.uid;
              User? user = snapshot.data;
              if (user!.emailVerified) {
                // Email is verified, navigate to home page
                return CheckRole(userD); //MultiProviderWidget();
              } else {
                // Email is not verified, navigate to resend email page
                return VerifyEmailPage();
              }
            } else {
              return unloggedHomeList(); //unloggedPublicPage();
            }
          },
        ),
      );
}
