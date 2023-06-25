import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../GlobalVariables.dart';
import '../../../Strings.dart';
import '../../../constants.dart';
import 'package:http/http.dart';

import '../../TransportPages/MainNavigationPage.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late SharedPreferences prefs;

  // final BuildContext context;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool sendingReq = false;

  @override
  void initState() {
    initSharedPref();
    super.initState();
  }

  Future<void> initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    setWalletBudget();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          child: Column(
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: TextFormField(
                  controller: usernameController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  cursorColor: kPrimaryColor,
                  style: TextStyle(
                    fontFamily: 'font',
                  ),
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
                    style: TextStyle(
                      fontFamily: 'font',
                    ),
                    cursorColor: kPrimaryColor,
                    decoration: const InputDecoration(
                      hintText: Strings.password,
                      helperStyle: TextStyle(
                        fontFamily: 'font',
                      ),
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
                    style: TextStyle(
                      fontFamily: 'font',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
            ],
          ),
        ),
        sendingReq
            ? Center(
                child: SizedBox(
                    width: 42, height: 42, child: CircularProgressIndicator(strokeWidth: 4.2)))
            : Container()
      ],
    );
  }

  Future<void> loginRequest() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MainNavigatorPage(prefs: prefs);
        },
      ),
    );
    return;
    setState(() {
      sendingReq = true;
    });
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) {
    //       return MainNavigatorPage();
    //     },
    //   ),
    // );
    // return;

    var username = usernameController.text;
    var password = passwordController.text;
    // var response = sendGet();
    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MainNavigatorPage()));

    final uri = Uri.parse("${GlobalVariables.BASE_URL}/api/login");
    final headers = {'Content-Type': 'application/json'};
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
    if (response.statusCode != 201) {
      _showAlert(context);
    } else {
      // print(response.body);
      final Map parsed = json.decode(response.body);
      // print(parsed);
      prefs.setString('token', parsed['access_token']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return MainNavigatorPage(prefs: prefs);
          },
        ),
      );
    }
    setState(() {
      sendingReq = false;
    });
    // if (response.statusCode < 400) {
    //   // print(response.body);
    //   // Navigator.push(
    //   //   context,
    //   //   MaterialPageRoute(
    //   //     builder: (context) {
    //   //       return MainNavigatorPage();
    //   //     },
    //   //   ),
    //   // );
    //   // var recentMessages = (json.decode(response.body) as List).map((i) => SignUpMessageModel.fromJson(i)).toList();
    // } else {
    //   // throw Exception('Failed to load album');
    // }
  }

  void _showAlert(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("تایید",
          style: TextStyle(
            fontFamily: 'font',
          )),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actions: [cancelButton],
              title: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text("اطلاعات نادرست",
                      style: TextStyle(
                        fontFamily: 'font',
                      ))),
              content: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text("نام کاربری یا رمز عبور نادرست است. دوباره امتحان کنید",
                      style: TextStyle(
                        fontFamily: 'font',
                      ))),
            ));
  }

  void toast(String s) {
    Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.blueGrey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void setWalletBudget() {
    prefs.setInt('wallet', 500000);
  }
}
