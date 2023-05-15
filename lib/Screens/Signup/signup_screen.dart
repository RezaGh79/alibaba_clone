import 'package:flutter/material.dart';
import 'components/sign_up_top_image.dart';
import 'components/signup_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({required this.context, Key? key}) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 30),
        child: SingleChildScrollView(
          child: MobileSignupScreen(),
        ),
      ),
    );
  }
}

class MobileSignupScreen extends StatelessWidget {
  const MobileSignupScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SignUpScreenTopImage(),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: SignUpForm(),
            ),
            Spacer(),
          ],
        ),
        // const SocalSignUp()
      ],
    );
  }
}
