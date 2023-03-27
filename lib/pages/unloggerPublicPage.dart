import 'package:flutter/material.dart';
import '../Oauth/AuthPage.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../Oauth/MainPage.dart';
import '../Oauth/Privacy_Policy.dart';

class unloggedPublicPage extends StatelessWidget {
  const unloggedPublicPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 80.0, vertical: 20),
              child: Image.asset('assets/images/ic_launcher/1024.png'),
            ),
            Text(
              'Welcome To Oran\nHabibi',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w300),
            ),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70.0),
                child: Card(
                  // margin: const EdgeInsets.all(5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 5,
                  child: Stack(
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
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/wall%2Fwall%20(1).jpg?alt=media&token=c5c01dca-4b32-4b9d-88fe-717e976ac2f5',
                              ),
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  AuthPage(), //MainPageAuth(),
                              //  AuthPage(),
                            ));
                          },
                          child: Text(
                            'Marhaba',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Privacy_Policy(), //MainPageAuth(),
                  //  AuthPage(),
                ));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Privacy Policy'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
