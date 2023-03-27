import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Oauth/Ogoogle/googleSignInProvider.dart';

class adminLoggedPage extends StatefulWidget {
  const adminLoggedPage({Key? key}) : super(key: key);

  @override
  State<adminLoggedPage> createState() => _adminLoggedPageState();
}

class _adminLoggedPageState extends State<adminLoggedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ADMIN',
              style: TextStyle(fontSize: 40),
            ),
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
                // onPressed: () async {
                //   final provider =
                //       Provider.of<googleSignInProvider>(context, listen: false);
                //   await provider.logout().whenComplete(() =>
                //       Navigator.of(context).pushAndRemoveUntil(
                //           MaterialPageRoute(builder: (context) {
                //         return NavigationExample();
                //       }), ModalRoute.withName('/')));
                //   // (route) => true
                // },
                // onPressed: () {
                //   FirebaseAuth.instance.signOut();
                //   final provider =
                //       Provider.of<googleSignInProvider>(context, listen: false);
                //   provider.logout();
                //   // Navigator.of(context).pop();
                //
                //   // Navigator.of(context).push(MaterialPageRoute(
                //   //   builder: (context) => verifi_auth(),
                //   // ));
                // },
                onPressed: () async {
                  FirebaseAuth.instance.signOut();
                  final provider =
                      Provider.of<googleSignInProvider>(context, listen: false);
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
  }
}
