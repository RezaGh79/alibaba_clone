import 'dart:async';
import 'dart:convert';

import 'package:alibaba_clone/Screens/TransportPages/MainNavigationPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// import 'package:native_shared_preferences/native_shared_preferences.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  late SharedPreferences prefs;

  int _counter = 0;
  late StreamController<int> _events;
  bool sendingReq = false;

  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String buttonText = "";
  String otpText = "";

  @override
  void initState() {
    initSharedPref();
    _events = StreamController<int>();
    _events.add(60);
    super.initState();
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
                    suffixStyle: TextStyle(
                      fontFamily: 'font',
                    ),
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
                  style: TextStyle(
                    fontFamily: 'font',
                  ),
                  textInputAction: TextInputAction.next,
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
                  obscureText: true,
                  controller: doublePasswordController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  cursorColor: kPrimaryColor,
                  style: TextStyle(
                    fontFamily: 'font',
                  ),
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
                  signUpDataValid(usernameController.text, mobileNumberController.text,
                      passwordController.text, doublePasswordController.text);

                  // showOtpAlert(context);
                  // if (otpText == "") {
                  //   signUpDataValid(usernameController.text, mobileNumberController.text, passwordController.text,
                  //       doublePasswordController.text);
                  // } else {
                  //   // validateSignUp();
                  // }
                },
                child: Text(buttonText == "" ? Strings.registerButton.toUpperCase() : buttonText,
                    style: TextStyle(
                      fontFamily: 'font',
                    )),
              ),
              // const SizedBox(height: defaultPadding),
              // ElevatedButton(
              //     onPressed: () {
              //       _incrementCounter();
              //     },
              //     child: Text("here"))
            ],
          ),
        ),
        // Center(
        //   child: CircularProgressIndicator(),
        // )
        sendingReq
            ? Center(
                child: SizedBox(
                    width: 42, height: 42, child: CircularProgressIndicator(strokeWidth: 4.2)))
            : Container()
      ],
    );
  }

  late Timer _timer;

  // showOtpAlert(BuildContext context) {
  //   // _timer.
  //   // set up the buttons
  //   Widget cancelButton = TextButton(
  //     child: Text("تایید"),
  //     onPressed: () {},
  //   );
  //   // Widget continueButton = TextButton(
  //   //   child: Text("Continue"),
  //   //   onPressed: () {},
  //   // );
  //
  //   AlertDialog alert = AlertDialog(
  //     title: Directionality(
  //         textDirection: TextDirection.rtl, child: Text("رمز یکبار مصرف را وارد نمایید")),
  //     content: Container(
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           OTPTextField(
  //               controller: otpController,
  //               length: 6,
  //               width: MediaQuery.of(context).size.width,
  //               textFieldAlignment: MainAxisAlignment.spaceAround,
  //               fieldWidth: 42,
  //               fieldStyle: FieldStyle.box,
  //               outlineBorderRadius: 15,
  //               style: TextStyle(fontSize: 17),
  //               onCompleted: (pin) {
  //                 setState(() {});
  //                 setState(() {
  //                   buttonText = "تایید ورود دو مرحله ای";
  //                   otpText = pin;
  //                 });
  //               }),
  //           Text(_timeString),
  //         ],
  //       ),
  //     ),
  //     actions: [
  //       cancelButton,
  //       // continueButton,
  //     ],
  //   );
  //
  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

  signUpDataValid(String username, String mobile, String password, String doublePassword) async {
    if (username == "" || mobile == "" || password == "" || doublePassword == "") {
      showAlertDialog(context, "اطلاعات نادرست", "همه اطلاعات را وارد کنید و دوباره امتحان کنید");
    } else if (password != doublePassword) {
      showAlertDialog(context, "اطلاعات نادرست", "رمز عبور و تکرار رمز عبور با هم برابر نیست");
    } else {
      if (await signUp(username, mobile, password)) {
        setState(() {
          sendingReq = false;
        });
        _startTimer();
        alertD(context);
      }
    }
  }

  showAlertDialog(BuildContext context, String title, String message) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK",
          style: TextStyle(
            fontFamily: 'font',
          )),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Row(mainAxisAlignment: MainAxisAlignment.end, children: [Text(title,style: const TextStyle(
        fontFamily: 'font',
      ))]),
      content: Row(mainAxisAlignment: MainAxisAlignment.end, children: [Text(message,style: const TextStyle(
        fontFamily: 'font',
      ))]),
      actions: [okButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<bool> signUp(String username, String mobile, String password) async {
    setState(() {
      sendingReq = true;
    });
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

    final Map parsed = json.decode(response.body);

    if (response.statusCode < 400) {
      return true;
      // print(response.body);
      // var recentMessages = SignUpMessageModel.fromJson(json.decode(response.body));
      // (json.decode(response.body)).map((i) => SignUpMessageModel.fromJson(i));
    } else {
      showAlertDialog(context, "شماره تلفن تکراری", "با یک شماره دیگر مجدد امتحان کنید");
      return false;
      // throw Exception('Failed to load album');
    }
  }

  validateSignUp() async {
    setState(() {
      sendingReq = true;
    });
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

    // print(response.body);
    setState(() {
      sendingReq = false;
    });
    if (response.statusCode < 400) {
      final Map parsed = json.decode(response.body);
      prefs.setString("token", parsed['access_token']);
      toast('ثبت نام با موفقیت انجام شد');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return MainNavigatorPage(prefs: prefs);
          },
        ),
      );
      return true;
      var recentMessages =
          (json.decode(response.body) as List).map((i) => SignUpMessageModel.fromJson(i)).toList();
    } else {
      return false;
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
      // print(_counter);
      _events.add(_counter);
    });
  }

  void alertD(BuildContext ctx) {
    Widget okButton = TextButton(
      child: const Text("تایید",
          style: TextStyle(
            fontFamily: 'font',
          )),
      onPressed: () {
        Navigator.of(context).pop();
        validateSignUp();
      },
    );
    var alert = AlertDialog(
        actions: [okButton],
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
                    const Text("رمز دو مرحله ای که پیامک شده را وارد نمایید",style: const TextStyle(
                      fontFamily: 'font',
                    )),
                    const SizedBox(height: 10),
                    OTPTextField(
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
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text(formatTime(_counter),style: const TextStyle(
                          fontFamily: 'font',
                        ))]), //new column child
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

  formatTime(int timeInSecond) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }

  Future<void> initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    // await prefs.setInt('counter', 10);
    // final int? counter = prefs.getInt('counter');
    // print(counter);
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
}
