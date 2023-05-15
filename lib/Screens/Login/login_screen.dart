import 'package:flutter/material.dart';

import '../../components/background.dart';
import '../../responsive.dart';
import 'components/login_form.dart';
import 'components/login_screen_top_image.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key, required this.context}) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height / 6;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: height),
        child: SingleChildScrollView(
          child: MobileLoginScreen(),
        ),
      ),
    );
  }
}

class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const LoginScreenTopImage(),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: LoginForm(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}
