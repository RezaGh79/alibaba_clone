import 'package:alibaba_clone/Screens/TransportPages/DifferentTransportaion/utils/OriginsDestinations.dart';
import 'package:alibaba_clone/Screens/ui_helper/BusTicketCard.dart';
import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../../../GlobalVariables.dart';
import '../../../../Strings.dart';
import 'package:http/http.dart';

class BusPage extends StatefulWidget {
  const BusPage({Key? key}) : super(key: key);

  @override
  State<BusPage> createState() => _BusPageState();
}

class _BusPageState extends State<BusPage> {
  var origin = "";
  var destination = "";
  String? travelDate = "";
  List<String> monthList = [
    "فروردین",
    "اردیبهشت",
    "خرداد",
    "تیر",
    "مرداد",
    "شهریور",
    "مهر",
    "آبان",
    "آذر",
    "دی",
    "بهمن",
    "اسفند"
  ];
  bool hideChoosingOriginAndDestination = false;

  @override
  void initState() {
    getTickets();
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
        title: Text(travelDate == "" ? "بلیت اتوبوس" : "$origin به $destination در ${travelDate!}"),
        centerTitle: true,
      ),
      body: Column(
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
                                showOriginDestinationAlert('origin');
                              },
                              child: Text(origin == "" ? Strings.origin : origin)),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  var temp = origin;
                                  origin = destination;
                                  destination = temp;
                                });
                              },
                              icon: const Icon(Icons.change_circle_outlined)),
                          TextButton(
                              onPressed: () {
                                showOriginDestinationAlert('destination');
                              },
                              child: Text(destination == "" ? Strings.destination : destination)),
                        ]),
                  ),
                  Row(children: [
                    Expanded(child: ElevatedButton(onPressed: () {}, child: Text(Strings.search))),
                    TextButton(
                        onPressed: () async {
                          if (origin == "" || destination == "") {
                            print("here");
                            //  Fluttertoast.showToast(
                            //   msg: 'Toast Message',
                            //   toastLength: Toast.LENGTH_SHORT,
                            //   gravity: ToastGravity.SNACKBAR,
                            //   backgroundColor: Colors.blueGrey,
                            //   textColor: Colors.white,
                            //   fontSize: 16.0,
                            // );
                          } else {
                            Jalali? picked = await showPersianDatePicker(
                              context: context,
                              initialDate: Jalali.now(),
                              firstDate: Jalali(1402, 2),
                              lastDate: Jalali(1402, 3),
                            );
                            setState(() {
                              try {
                                travelDate = "${picked!.day} ${monthList[picked.month - 1]}";
                                hideChoosingOriginAndDestination = true;
                              } catch (e) {}
                            });
                          }
                        },
                        child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(travelDate == "" ? Strings.ticketDate : travelDate.toString()))),
                  ]),
                ])
              : Container(),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, i) {
                return BusTicketCard();
              },
            ),
          )
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
                  title: Text(OriginsDestinations.originsDomestic[index]),
                ));
          },
        ));
  }

  void showOriginDestinationAlert(String originOrDestination) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("لیست شهرها"),
            content: setupAlertDialogContainer(originOrDestination),
          );
        });
  }

  getTickets() async {
    final uri = Uri.parse("${GlobalVariables.BASE_URL}/api/travels");
    final headers = {'Content-Type': 'application/json', 'cookie': GlobalVariables.cookie};
    // Map<String, dynamic> body = {"username": username, "password": password, "otp": otp};
    // String jsonBody = json.encode(body);
    // final encoding = Encoding.getByName('utf-8');

    Response response = await get(
      uri,
      headers: headers,
      // body: jsonBody,
      // encoding: encoding,
    );

    print(response.body);

    if (response.statusCode < 400) {
      // print(response.body);
      // var recentMessages = (json.decode(response.body) as List).map((i) => SignUpMessageModel.fromJson(i)).toList();
    } else {
      // throw Exception('Failed to load album');
    }
  }
}
