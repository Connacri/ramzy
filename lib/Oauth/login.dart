import 'dart:ui';

import '../Oauth/reset_password.dart';
import '../Oauth/verifi_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'AuthPage.dart';
import 'Ogoogle/googleSignInProvider.dart';
import 'SignUpWidget.dart';

class LoginWidget extends StatefulWidget {
  // const login({Key? key}) : super(key: key);
  final VoidCallback onClickedSignUp;

  const LoginWidget({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool visible = true;

  loadProgress() {
    if (visible == true) {
      setState(() {
        visible = false;
      });
    } else {
      setState(() {
        visible = true;
      });
    }
  }

  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: [
            Form(
                key: formKey,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaY: 25, sigmaX: 25),
                      child: SizedBox(
                        width: size.width * .9,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/ic_launcher/1024.png',
                              // #Image Url: https://unsplash.com/photos/bOBM8CB4ZC4
                              fit: BoxFit.cover, //.fitHeight,
                              height: 150, width: 150,
                            ),
                            // Lottie.asset(
                            //   'assets/lotties/59152-time-to-break-the-fast-in-the-month-of-ramadan-2021-animation.json',
                            //   repeat: true,
                            //   // reverse: true,
                            //   animate: true,
                            //   height: 130,
                            //   width: 200,
                            // ),

                            const SizedBox(height: 10),
                            Text(
                              'Connexion'
                                  // 'J\'ai Déja un Compte' //S\'Identifier'
                                  .toUpperCase(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.black45,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Oswald'),
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  children: [
                                    Text(
                                      'J\'ai Déja un Compte' //S\'Identifier'
                                          .toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.black45,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Oswald'),
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      showCursor: true,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 25,
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      controller: emailController,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        fillColor: Colors.blue.shade50,
                                        hintText: 'Email',
                                        border: InputBorder.none,
                                        filled: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 5),
                                        hintStyle:
                                            TextStyle(color: Colors.black12),
                                      ),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (email) => email != null &&
                                              !EmailValidator.validate(email)
                                          ? 'Entrer a Valide E-Mail'
                                          : null,
                                    ),
                                    const SizedBox(height: 12), // ti
                                    TextFormField(
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 25,
                                      ),
                                      controller: passwordController,
                                      textInputAction: TextInputAction.next,
                                      obscureText: _obscureText,
                                      decoration: InputDecoration(
                                        fillColor: Colors.blue.shade50,
                                        hintText: 'Mot De Passe',
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscureText
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscureText = !_obscureText;
                                            });
                                          },
                                        ),
                                        border: InputBorder.none,
                                        filled: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 5),
                                        hintStyle:
                                            TextStyle(color: Colors.black12),
                                      ),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) =>
                                          value != null && value.length < 6
                                              ? 'Entrer min 6 characteres.'
                                              : null,
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          elevation: 4.0,
                                          minimumSize:
                                              const Size.fromHeight(50)),
                                      icon: const Icon(Icons.lock_open,
                                          size: 32, color: Colors.white),
                                      label: const Text(
                                        'Entrer',
                                        style: TextStyle(
                                            fontSize: 24, color: Colors.white),
                                      ),
                                      onPressed: () async {
                                        signIn().then((value) =>
                                            Navigator.of(context).popUntil(
                                                (route) => route.isFirst));
                                        // .whenComplete(() => Navigator.of(context)
                                        //             .push(MaterialPageRoute(
                                        //           builder: (context) =>
                                        //               verifi_auth(),
                                        //         ))

                                        //     .whenComplete(
                                        //   () => Navigator.of(context)
                                        //       .popUntil((route) => route.isFirst),
                                        //  );
                                      },
                                    ), // Entrer
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  children: [
                                    Text(
                                      'J\'ai Pas Encore un Compte'
                                          .toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.black45,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Oswald'),
                                    ),
                                    Text(
                                      'Utilisant Ton Compte Google'
                                          .toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.black45,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Oswald'),
                                    ),
                                    const SizedBox(height: 10),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.black54,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          elevation: 4.0,
                                          minimumSize:
                                              const Size.fromHeight(50)),
                                      icon: Icon(
                                        FontAwesomeIcons.google,
                                        color: Colors.red,
                                      ),
                                      label: const Text(
                                        'Google',
                                        style: TextStyle(
                                            fontSize: 24, color: Colors.white),
                                      ),
                                      onPressed: () async {
                                        final provider = await Provider.of<
                                                googleSignInProvider>(context,
                                            listen: false);

                                        //  if (user != null) {
                                        provider.googleLogin().whenComplete(
                                              () => Navigator.of(context)
                                                  .popUntil(
                                                      (route) => route.isFirst),
                                            );
                                      },
                                    ), // Google
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              child: const Text(
                                'Mot de Passe Oublié',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontFamily: 'Oswald',
                                ),
                              ),
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const reset_password())),
                            ), //Forgot Password
                            const SizedBox(
                              height: 10,
                            ),
                            RichText(
                                text: TextSpan(
                                    style: const TextStyle(
                                      fontFamily: 'Oswald',
                                      color: Colors.black54,
                                    ),
                                    text: 'J\'ai pas Encore de Compte? ',
                                    children: [
                                  TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = widget.onClickedSignUp,
                                      text: 'S\'Enregistrer',
                                      style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                          // color: Theme.of(context)
                                          //     .colorScheme
                                          //     .secondary,
                                          fontFamily: 'Oswald',
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold))
                                ])),
                          ],
                        ),
                      ),
                    ))),
          ],
        ),
      ),
    );
  }

  Future signIn() async {
    showDialog<void>(
        context: context,
        barrierDismissible: true,
        //false = user must tap button, true = tap outside dialog
        builder: (context) => const Center(child: CircularProgressIndicator()));

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim());

      checkIfDocExists(FirebaseAuth.instance.currentUser!.uid);
    } on FirebaseException catch (e) {
      if (e.code == 'invalid-email') {
        Navigator.of(context).pop();
        //navigatorKey.currentState!.popUntil((route) => route.isFirst);

        return Fluttertoast.showToast(
          msg: 'E-mail Invalide',
        );
      } else if (e.code == 'user-disabled') {
        Navigator.of(context).pop();
        //navigatorKey.currentState!.popUntil((route) => route.isFirst);
        return Fluttertoast.showToast(
            msg: 'Utlisateur Désactivé',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 14.0);
      } else if (e.code == 'user-not-found') {
        // Navigator.of(context).pop();
        //navigatorKey.currentState!.popUntil((route) => route.isFirst);
        bool isLogin = true;
        void toggle() => setState(() => isLogin = !isLogin);

        return Fluttertoast.showToast(
                msg: 'Utilisateur Non Trouvé',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 14.0)
            .whenComplete(() => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SignUpWidget(
                    onClickedSignIn: toggle,
                  ),
                )));
      } else {
        //Navigator.of(context).pop();
        //navigatorKey.currentState!.popUntil((route) => route.isFirst);

        return Fluttertoast.showToast(
            msg: 'Mot de passe incorrect',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 14.0);
      }
    }
    //navigatorKey.currentState!.popUntil((route) => route.isFirst);
    //Navigator.of(context, rootNavigator: true).pop((route) => route.isFirst);
  }
}

Future<bool> checkIfDocExists(String uid) async {
  try {
    final userGoo = FirebaseAuth.instance.currentUser;
    var collectionRef = FirebaseFirestore.instance.collection('Users');
    var doc = await collectionRef.doc(uid).get();
    print(doc.exists);
    doc.exists ? updateUserDoc(userGoo!) : setUserDoc(userGoo!);
    return doc.exists;
  } catch (e) {
    throw e;
  }
}

Future setUserDoc(User userGoo) async {
  CollectionReference userRef = FirebaseFirestore.instance.collection('Users');

  String userID = userGoo.uid;
  String? userEmail = userGoo.email;
  String? userAvatar = userGoo.photoURL;
  String? userDisplayName = userGoo.displayName;
  //String? userPhone = userGoo.phoneNumber;
  //int? phone = int.parse(userPhone!);
  String? userRole = 'public';
  bool userState = true;

  userRef.doc(userGoo.uid).set({
    'lastActive': Timestamp.now(),
    'id': userID,
    'phone': 0, // attention hna
    'email': userEmail,
    'avatar': userAvatar ??
        'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/wall%2Fwall%20(2).jpg?alt=media&token=c5c01dca-4b32-4b9d-88fe-717e976ac2f5',
    'timeline': userAvatar ??
        'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/wall%2Fwall%20(1).jpg?alt=media&token=c5c01dca-4b32-4b9d-88fe-717e976ac2f5',
    'createdAt': Timestamp.now(),
    'displayName': userDisplayName ?? 'Profil',
    'state': userState,
    'role': userRole,
    'plan': 'free',
    'coins': 0.0,
    'levelUser': 'begin',
    'stars': 0.0,
    'userItemsNbr': 0,
  }, SetOptions(merge: true));
}

Future updateUserDoc(User userGoo) async {
  CollectionReference userRef = FirebaseFirestore.instance.collection('Users');

  userRef.doc(userGoo.uid).update(
    {
      'lastActive': Timestamp.now(),
    },
  );
}
