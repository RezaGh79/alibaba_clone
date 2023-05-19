import 'dart:convert';
import 'dart:math';

import 'package:alibaba_clone/Screens/TransportPages/DifferentTransportaion/utils/OriginsDestinations.dart';
import 'package:alibaba_clone/Screens/ui_helper/BusTicketCard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../GlobalVariables.dart';
import '../../../../Strings.dart';
import 'package:http/http.dart';

import '../../../../constants.dart';
import '../../../../models/TicketsModel.dart';

class BusPage extends StatefulWidget {
  const BusPage({Key? key, required this.prefs}) : super(key: key);
  final SharedPreferences prefs;

  @override
  State<BusPage> createState() => _BusPageState();
}

class _BusPageState extends State<BusPage> {
  var origin = "";
  var destination = "";
  String? travelDate = "";
  bool hideChoosingOriginAndDestination = false;
  late Gregorian dateGregorian;
  late Jalali dateJalali;
  List<TicketModel> tickets = [];
  bool showProgressBar = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => {
            if (hideChoosingOriginAndDestination)
              {
                setState(() {
                  hideChoosingOriginAndDestination = !hideChoosingOriginAndDestination;
                })
              }
            else
              {Navigator.of(context).pop()}
          },
        ),
        title: Text(travelDate == "" ? "بلیت اتوبوس" : "$origin به $destination در ${travelDate!}",
            style: const TextStyle(
              fontFamily: 'font',
            )),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              !hideChoosingOriginAndDestination
                  ? Column(children: [
                      Image.asset("assets/images/bus.jpg", height: 120, fit: BoxFit.fill),
                      Container(
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    showOriginDestinationAlert('destination');
                                  },
                                  child: Text(destination == "" ? Strings.destination : destination,
                                      style: const TextStyle(
                                        fontFamily: 'font',
                                      ))),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      var temp = origin;
                                      origin = destination;
                                      destination = temp;
                                    });
                                  },
                                  icon: const Icon(Icons.change_circle_outlined, size: 27)),
                              TextButton(
                                  onPressed: () {
                                    showOriginDestinationAlert('origin');
                                  },
                                  child: Text(origin == "" ? Strings.origin : origin,
                                      style: const TextStyle(
                                        fontFamily: 'font',
                                      ))),
                            ]),
                      ),
                      Row(children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  hideChoosingOriginAndDestination = true;
                                  getTickets();
                                });
                              },
                              child: const Text(
                                Strings.search,
                                style: TextStyle(
                                  fontFamily: 'font',
                                ),
                              )),
                        )),
                        TextButton(
                            onPressed: () async {
                              if (origin == "" || destination == "") {
                                toast("مبدا و مقصد را به درستی وارد نکرده اید");
                              } else {
                                Jalali? picked = await showPersianDatePicker(
                                  context: context,
                                  initialDate: Jalali.now(),
                                  firstDate: Jalali(1402, 2),
                                  lastDate: Jalali(1402, 3),
                                );
                                // setState(() {
                                try {
                                  travelDate = "${picked!.day} ${monthList[picked.month - 1]}";
                                  dateJalali = picked;
                                  // print(travelDate);
                                  Jalali g1 = Jalali(picked.year, picked.month, picked.day);
                                  dateGregorian = g1.toGregorian();
                                  // print(j1);
                                } catch (e) {}
                                // });
                              }
                            },
                            child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(
                                    travelDate == "" ? Strings.ticketDate : travelDate.toString(),
                                    style: const TextStyle(
                                      fontFamily: 'font',
                                    )))),
                      ]),
                    ])
                  : Container(),
              !showProgressBar && tickets.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: tickets.length,
                        itemBuilder: (context, i) {
                          return BusTicketCard(
                              ticket: tickets[i], dateJalali: dateJalali, prefs: widget.prefs);
                        },
                      ),
                    )
                  : Container()
            ],
          ),
          showProgressBar
              ? Center(
                  child: SizedBox(
                      width: 42, height: 42, child: CircularProgressIndicator(strokeWidth: 4.2)))
              : Container()
        ],
      ),
    );
  }

  Widget setupAlertDialogContainer(String originOrDestination) {
    return SizedBox(
        height: 300.0,
        width: 300.0,
        child: ListView.builder(
          itemCount: OriginsDestinations.originsDomestic.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
                onTap: () {
                  setState(() {
                    if (originOrDestination == "origin") {
                      origin = OriginsDestinations.originsDomestic[index];
                    } else {
                      destination = OriginsDestinations.originsDomestic[index];
                    }
                  });
                  Navigator.pop(context);
                },
                child: ListTile(
                  title: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(OriginsDestinations.originsDomestic[index],
                          style: const TextStyle(
                            fontFamily: 'font',
                          ))),
                ));
          },
        ));
  }

  void showOriginDestinationAlert(String originOrDestination) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Directionality(
                textDirection: TextDirection.rtl,
                child: const Text("لیست شهرها",
                    style: TextStyle(
                      fontFamily: 'font',
                    ))),
            content: setupAlertDialogContainer(originOrDestination),
          );
        });
  }

  getTickets() async {
    setState(() {
      showProgressBar = true;
    });
    //2023-05-19
    //2023-05-20

    final uri = Uri.parse("${GlobalVariables.BASE_URL_TICKETS}/api/travels?"
        "source=$origin&destination=$destination&"
        "gte=${dateGregorian.year}-${dateGregorian.month}-${dateGregorian.day}&"
        "lt=${dateGregorian.year}-${dateGregorian.month}-${dateGregorian.day + 1}");

    final headers = {
      'Content-Type': 'application/json',
      'cookie': widget.prefs.getString('token')!
    };

    // Map<String, dynamic> body = {"username": username, "password": password, "otp": otp};
    // String jsonBody = json.encode(body);
    // final encoding = Encoding.getByName('utf-8');

    Response response = await get(
      uri,
      headers: headers,
      // body: jsonBody,
      // encoding: encoding,
    );

    if (response.statusCode < 400) {
      // print(response.body);
      tickets = (json.decode(response.body) as List).map((i) => TicketModel.fromJson(i)).toList();
      setState(() {
        showProgressBar = false;
      });
    } else {}
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
