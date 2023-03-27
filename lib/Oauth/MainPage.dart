import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'AuthPage.dart';
import 'VerifyEmailPage.dart';

class MainPageAuth extends StatelessWidget {
  //const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
          body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('some thig has errur'));
          }
          if (snapshot.hasData) {
            return VerifyEmailPage();
          } else {
            return const AuthPage();
          }
        },
      ));

  bool isEmailVerified() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user!.emailVerified) {
      return true;
    }
    return false;
  }
}
