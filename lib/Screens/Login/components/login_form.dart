import 'dart:convert';

import 'package:alibaba_clone/HttpRequests/requests.dart';
import 'package:alibaba_clone/Screens/TransportPages/MainNavigationPage.dart';
import 'package:flutter/material.dart';

import '../../../GlobalVariables.dart';
import '../../../Strings.dart';
import '../../../constants.dart';
import '../../Signup/components/signup_form.dart';
import '../../Signup/signup_screen.dart';
import 'package:http/http.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // final BuildContext context;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: TextFormField(
              controller: usernameController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (email) {},
              decoration: const InputDecoration(
                hintText: Strings.username,
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                obscureText: true,
                cursorColor: kPrimaryColor,
                decoration: const InputDecoration(
                  hintText: Strings.password,
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Icon(Icons.lock),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () {
                loginRequest();
              },
              child: Text(
                Strings.loginButton.toUpperCase(),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
        ],
      ),
    );
  }

  Future<void> loginRequest() async {
    var username = usernameController.text;
    var password = passwordController.text;
    // var response = sendGet();
    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MainNavigatorPage()));

    final uri = Uri.parse("${GlobalVariables.BASE_URL}/api/login");
    final headers = {
      'Content-Type': 'application/json',
      'cookie': GlobalVariables.cookie
    };
    Map<String, dynamic> body = {'username': username, 'password': password};
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    // print(response.body);
    // print(response.statusCode);

    if (response.statusCode < 400) {
      // print(response.body);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return MainNavigatorPage();
          },
        ),
      );
      // var recentMessages = (json.decode(response.body) as List).map((i) => SignUpMessageModel.fromJson(i)).toList();
    } else {
      // throw Exception('Failed to load album');
    }
  }
}
