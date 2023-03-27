import 'dart:async';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({
    Key? key,
    // required this.email
  }) : super(key: key);
  //final String email;
  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
  }

  Future verification() async {
    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(
          const Duration(seconds: 5), (_) => checkEmailVerified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    // call after email verified
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);

      await Future.delayed(const Duration(seconds: 5));

      setState(() => canResendEmail = true);
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.deepOrange,
          textColor: Colors.white,
          fontSize: 15.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isEmailVerified
        ? Scaffold(
            body: Center(
              child: Text('Profil verified'),
            ),
          )
        : Scaffold(
            // appBar: AppBar(
            //   title: Text('Verify Email'),
            // ),
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  SizedBox(
                    height: size.height,
                    child: Image.asset(
                      'assets/images/ic_launcher/1024.png',
                      fit: BoxFit.fitHeight,
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
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaY: 25, sigmaX: 25),
                              child: SizedBox(
                                  width: size.width * .9,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 20),
                                        const FlutterLogo(size: 80),
                                        const SizedBox(height: 20),
                                        const Text(
                                          'Un Lien de Vérificaton a été Envoyer dans ton Email ',
                                          style: TextStyle(
                                            color: Colors.amber,
                                            fontSize: 25,
                                            fontFamily: 'Oswald',
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        //const Text(widget.email??''),
                                        const SizedBox(
                                          height: 24,
                                        ),
                                        ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                                minimumSize:
                                                    const Size.fromHeight(50)),
                                            onPressed: canResendEmail
                                                ? verification
                                                : null,
                                            icon: const Icon(
                                              Icons.email,
                                              size: 32,
                                            ),
                                            label: const Text(
                                              'Réenvoyer Email',
                                              style: TextStyle(
                                                color: Colors.amber,
                                                fontSize: 18,
                                                fontFamily: 'Oswald',
                                              ),
                                            )),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        TextButton(
                                            style: ElevatedButton.styleFrom(
                                                minimumSize:
                                                    const Size.fromHeight(50)),
                                            onPressed: () =>
                                                FirebaseAuth.instance.signOut(),
                                            child: const Text(
                                              'Annuler',
                                              style: TextStyle(
                                                color: Colors.amber,
                                                fontSize: 18,
                                                fontFamily: 'Oswald',
                                              ),
                                            ))
                                      ],
                                    ),
                                  ))))),
                ],
              ),
            ),
          );
  }
}
