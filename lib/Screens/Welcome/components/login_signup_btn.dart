import 'package:alibaba_clone/Strings.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../Login/login_screen.dart';
import '../../Signup/signup_screen.dart';

class LoginAndSignupBtn extends StatelessWidget {
  const LoginAndSignupBtn({
    required this.context,
    Key? key,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Hero(
          tag: "login_btn",
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen(context: context);
                  },
                ),
              );
            },
            child: Text(
              Strings.signIn.toUpperCase(),
              style: TextStyle(
                fontFamily: 'font',
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return SignUpScreen(context: context);
                },
              ),
            );
          },
          style: ElevatedButton.styleFrom(primary: kPrimaryLightColor, elevation: 0),
          child: Text(
            Strings.signUp.toUpperCase(),
            style: const TextStyle(color: Colors.black, fontFamily: 'font'),
          ),
        ),
      ],
    );
  }
}
