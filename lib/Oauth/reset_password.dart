import 'dart:ui';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

import '../main.dart';

class reset_password extends StatefulWidget {
  const reset_password({Key? key}) : super(key: key);

  @override
  State<reset_password> createState() => _reset_passwordState();
}

class _reset_passwordState extends State<reset_password> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: size.height,
              width: size.width,
              child: Image.network(
                'https://firebasestorage.googleapis.com/v0/b/oran-894b7.appspot.com/o/images%2Fscaled_190a1b437f2e6581eb704b8c18e1e72f.jpg?alt=media&token=642c7e54-a2c3-4031-8f61-4c360fa65005',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  // change 1
                  top: 200,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,

                  // change 2
                  left: 20,
                  right: 20),
              child: Form(
                  key: formKey,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaY: 25, sigmaX: 25),
                          child: SizedBox(
                              width: size.width * .9,
                              child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: Image.asset(
                                              'assets/images/ic_launcher/1024.png')),
                                      // Lottie.asset(
                                      //   'assets/lotties/59266-pray-in-the-month-of-ramadan.json',
                                      //   repeat: true,
                                      //   // reverse: true,
                                      //   animate: true,
                                      //   height: 150,
                                      //   width: 200,
                                      // ),
                                      const SizedBox(height: 20),
                                      const Text(
                                          'Recever un E-mail de \n Réinitialision Mot de Passe',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.amber,
                                            fontSize: 25,
                                            fontFamily: 'Oswald',
                                          )),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                        controller: emailController,
                                        cursorColor: Colors.white,
                                        textInputAction: TextInputAction.done,
                                        decoration: const InputDecoration(
                                            labelText: 'Votre E-mail',
                                            labelStyle: TextStyle(
                                                color: Colors.white70)),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (email) => email != null &&
                                                !EmailValidator.validate(email)
                                            ? 'enter a validate email'
                                            : null,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.black54,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              elevation: 4.0,
                                              minimumSize:
                                                  const Size.fromHeight(50)),
                                          onPressed: resetPassword,
                                          icon: const Icon(Icons.email_outlined,
                                              color: Colors.amber),
                                          label: const Text(
                                            'Réinitialiser',
                                            style: TextStyle(
                                              color: Colors.amber,
                                              fontSize: 18,
                                              fontFamily: 'Oswald',
                                            ),
                                          ))
                                    ],
                                  )))))),
            ),
          ],
        ),
      ),
    );
  }

  Future resetPassword() async {
    showDialog<void>(
        context: context,
        barrierDismissible: true,
        //false = user must tap button, true = tap outside dialog
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      // Fluttertoast.showToast(
      //     msg: 'Mot de Passe à été Envoyer Vers Ton Email Verifier Votre Spam ou Courrier Indesirable :'+ emailController.text,
      //     toastLength: Toast.LENGTH_LONG,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 15.0);
      //navigatorKey.currentState!.popUntil((route) => route.isFirst);
      //Navigator.of(context).pop();
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            titleTextStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Oswald',
                fontSize: 15),
            alignment: Alignment.topCenter,
            title: const Text(
              'Votre Email',
              style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Oswald'),
            ),
            content: Text(
              'Un Liens de Reinitialisation de Mot de Passe à été Envoyer Vers Ton Email Verifier Votre Spam ou Courrier Indesirable : ${emailController.text}',
              maxLines: 6,
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  //Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                  navigatorKey.currentState!.popUntil((route) => route.isFirst);
                },
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: 'Error email virifih mlih',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 25.0);
      Navigator.of(context).pop();
    }
  }
}
