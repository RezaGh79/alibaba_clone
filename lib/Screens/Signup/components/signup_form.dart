import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:native_shared_preferences/native_shared_preferences.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import '../../../GlobalVariables.dart';
import '../../../Strings.dart';
import '../../../constants.dart';
import '../../../models/SignUpMessageModel.dart';
import '../../Login/login_screen.dart';
import 'package:http/http.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController doublePasswordController = TextEditingController();
  OtpFieldController otpController = OtpFieldController();

  int _counter = 0;
  late StreamController<int> _events;

  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String buttonText = "";
  String otpText = "";

  @override
  void initState() {
    _events = new StreamController<int>();
    _events.add(60);
    super.initState();
  }

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
          const SizedBox(height: defaultPadding / 2),
          Directionality(
            textDirection: TextDirection.rtl,
            child: TextFormField(
              controller: mobileNumberController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (email) {},
              decoration: const InputDecoration(
                hintText: Strings.mobile,
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          Directionality(
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
          const SizedBox(height: defaultPadding / 2),
          Directionality(
            textDirection: TextDirection.rtl,
            child: TextFormField(
              controller: doublePasswordController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (email) {},
              decoration: const InputDecoration(
                hintText: Strings.repeatPassword,
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding / 2),

          const SizedBox(height: defaultPadding / 2),
          ElevatedButton(
            onPressed: () {
              _startTimer();
              alertD(context);
              // showOtpAlert(context);
              // if (otpText == "") {
              //   signUpDataValid(usernameController.text, mobileNumberController.text, passwordController.text,
              //       doublePasswordController.text);
              // } else {
              //   // validateSignUp();
              // }
            },
            child: Text(buttonText == "" ? Strings.registerButton.toUpperCase() : buttonText),
          ),
          // const SizedBox(height: defaultPadding),
          // ElevatedButton(
          //     onPressed: () {
          //       _incrementCounter();
          //     },
          //     child: Text("here"))
        ],
      ),
    );
  }

  late Timer _timer;
  String _timeString = "";

  showOtpAlert(BuildContext context) {
    // _timer.
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("تایید"),
      onPressed: () {},
    );
    // Widget continueButton = TextButton(
    //   child: Text("Continue"),
    //   onPressed: () {},
    // );

    AlertDialog alert = AlertDialog(
      title: Directionality(textDirection: TextDirection.rtl, child: Text("رمز یکبار مصرف را وارد نمایید")),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OTPTextField(
                controller: otpController,
                length: 6,
                width: MediaQuery.of(context).size.width,
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldWidth: 42,
                fieldStyle: FieldStyle.box,
                outlineBorderRadius: 15,
                style: TextStyle(fontSize: 17),
                onCompleted: (pin) {
                  setState(() {});
                  setState(() {
                    buttonText = "تایید ورود دو مرحله ای";
                    otpText = pin;
                  });
                }),
            Text(_timeString),
          ],
        ),
      ),
      actions: [
        cancelButton,
        // continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  signUpDataValid(String username, String mobile, String password, String doublePassword) {
    if (username == "" || mobile == "" || password == "" || doublePassword == "") {
      showAlertDialog(context, "اطلاعات نادرست", "همه اطلاعات را وارد کنید و دوباره امتحان کنید");
    } else if (password != doublePassword) {
      showAlertDialog(context, "اطلاعات نادرست", "رمز عبور و تکرار رمز عبور با هم برابر نیست");
    } else {
      signUp(username, mobile, password);
    }
  }

  showAlertDialog(BuildContext context, String title, String message) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [okButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void signUp(String username, String mobile, String password) async {
    final uri = Uri.parse("${GlobalVariables.BASE_URL}/api/register");
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {'username': username, 'password': password, 'phoneNumber': mobile};
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    print(response.body);

    if (response.statusCode < 400) {
      // print(response.body);
      var recentMessages = SignUpMessageModel.fromJson(json.decode(response.body));
      // (json.decode(response.body)).map((i) => SignUpMessageModel.fromJson(i));
    } else {
      throw Exception('Failed to load album');
    }
  }

  validateSignUp() async {
    var username = usernameController.text;
    var password = passwordController.text;
    var otp = otpText;
    final uri = Uri.parse("${GlobalVariables.BASE_URL}/api/verifyOTP");
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {"username": username, "password": password, "otp": otp};
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    print(response.body);

    if (response.statusCode < 400) {
      // print(response.body);
      var recentMessages = (json.decode(response.body) as List).map((i) => SignUpMessageModel.fromJson(i)).toList();
    } else {
      // throw Exception('Failed to load album');
    }
  }

  void _startTimer() {
    _counter = 180;
    // if (_timer != null) {
    //   _timer.cancel();
    // }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      //setState(() {
      (_counter > 0) ? _counter-- : _timer.cancel();
      //});
      print(_counter);
      _events.add(_counter);
    });
  }

  void alertD(BuildContext ctx) {
    var alert = AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        backgroundColor: Colors.grey[100],
        elevation: 0.0,
        content: StreamBuilder<int>(
            stream: _events.stream,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              print(snapshot.data.toString());
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    OTPTextField(
                        controller: otpController,
                        length: 6,
                        width: MediaQuery.of(context).size.width,
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldWidth: 42,
                        fieldStyle: FieldStyle.box,
                        outlineBorderRadius: 15,
                        style: TextStyle(fontSize: 17),
                        onCompleted: (pin) {
                          setState(() {});
                          setState(() {
                            buttonText = "تایید ورود دو مرحله ای";
                            otpText = pin;
                          });
                        }),
                    SizedBox(height: 15),
                    Text(formatedTime(_counter)), //new column child
                  ],
                ),
              );
            }));
    showDialog(
        barrierDismissible: false,
        context: ctx,
        builder: (BuildContext c) {
          return alert;
        });
  }

  formatedTime(int timeInSecond) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }
}