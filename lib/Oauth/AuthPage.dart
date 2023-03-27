import 'package:flutter/material.dart';

import 'SignUpWidget.dart';
import 'login.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? LoginWidget(onClickedSignUp: toggle)
      : SignUpWidget(
          onClickedSignIn: toggle,
        );

  void toggle() => setState(() => isLogin = !isLogin);
}
