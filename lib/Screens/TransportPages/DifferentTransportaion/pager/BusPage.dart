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
  RangeValues _currentRangeValues = const RangeValues(0, 100);
  bool showSorted = false;

  @override
  void initState() {
    super.initState();
  }

  int defaultChoiceIndex = 2;
  final List<String> _choicesList = ['قیمت', 'زودترین', 'پیش فرض'];
  bool checkedValue = false;

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
                                  firstDate: Jalali(1402, 4),
                                  lastDate: Jalali(1402, 5),
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
                                child: Text(travelDate == "" ? Strings.ticketDate : travelDate.toString(),
                                    style: const TextStyle(
                                      fontFamily: 'font',
                                    )))),
                      ]),
                    ])
                  : Container(),
              // !showProgressBar && tickets.isNotEmpty
              //     ?
              Column(
                children: [
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 17, right: 10),
                          child: SizedBox(
                              height: 40,
                              width: 70,
                              child: ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(
                                          builder: (context, setState) {
                                            return AlertDialog(
                                              title: const Directionality(
                                                  textDirection: TextDirection.rtl,
                                                  child: Text("فیلتر مورد نظر را انتخاب کنید",
                                                      style: TextStyle(fontFamily: 'font'))),
                                              content: Directionality(
                                                textDirection: TextDirection.rtl,
                                                child: SizedBox(
                                                  height: 105,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: <Widget>[
                                                          RangeSlider(
                                                            values: _currentRangeValues,
                                                            min: 0,
                                                            max: 100,
                                                            divisions:
                                                                (_currentRangeValues.end - _currentRangeValues.start)
                                                                    .toInt(),
                                                            labels: RangeLabels(
                                                              _currentRangeValues.start.round().toString(),
                                                              _currentRangeValues.end.round().toString(),
                                                            ),
                                                            onChanged: (RangeValues values) {
                                                              setState(() {
                                                                _currentRangeValues = values;
                                                              });
                                                            },
                                                          )
                                                        ],
                                                      ),
                                                      CheckboxListTile(
                                                        title: const Text("فقط نمایش تخفیف دارها"),
                                                        value: checkedValue,
                                                        onChanged: (newValue) {
                                                          setState(() {
                                                            checkedValue = newValue!;
                                                          });
                                                        },
                                                        controlAffinity: ListTileControlAffinity.leading,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () => {Navigator.pop(context), filter()},
                                                  child: const Text(
                                                    "تایید",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold, fontSize: 15, fontFamily: 'font'),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: const Text("فیلتر", style: TextStyle(fontFamily: 'font')))),
                        ),
                        Column(
                          children: <Widget>[
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 3,
                              children: List.generate(_choicesList.length, (index) {
                                return ChoiceChip(
                                  labelPadding: const EdgeInsets.all(2.0),
                                  label: Text(
                                    _choicesList[index],
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(color: Colors.white, fontSize: 14),
                                  ),
                                  selected: defaultChoiceIndex == index,
                                  selectedColor: const Color.fromRGBO(34, 48, 80, 1),
                                  onSelected: (value) {
                                    setState(() {
                                      defaultChoiceIndex = value ? index : defaultChoiceIndex;
                                      sort(defaultChoiceIndex);
                                    });
                                  },
                                  // backgroundColor: color,
                                  elevation: 1,
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                );
                              }),
                            )
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text("   مرتب سازی", style: TextStyle(fontFamily: 'font')),
                        ),
                      ]),
                  SizedBox(
                    height: hideChoosingOriginAndDestination ? 590 : 320,
                    child: ListView.builder(
                      itemCount: showSorted ? sortedTicket.length : tickets.length,
                      itemBuilder: (context, i) {
                        return BusTicketCard(
                            ticket: showSorted ? sortedTicket[i] : tickets[i],
                            dateJalali: dateJalali,
                            prefs: widget.prefs);
                      },
                    ),
                  ),
                ],
              )
              // : Container()
            ],
          ),
          showProgressBar
              ? const Center(child: SizedBox(width: 42, height: 42, child: CircularProgressIndicator(strokeWidth: 4.2)))
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

  int _lowerValue = 80;
  int _upperValue = 150;

  Widget show123() {
    return SizedBox(
        height: 300.0,
        width: 300.0,
        child: Column(children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Text("Lower value: $_lowerValue"),
                // Text("Upper value: $_upperValue"),
                SizedBox(
                  height: 80,
                  width: 300,
                  child: RangeSlider(
                    min: 18,
                    max: 69,
                    divisions: 51,
                    values: RangeValues(_lowerValue.toDouble(), _upperValue.toDouble()),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _lowerValue = values.start.round();
                        _upperValue = values.end.round();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ]));
  }

  showAlertFilter() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Directionality(
                textDirection: TextDirection.rtl,
                child: Text("لیست شهرها",
                    style: TextStyle(
                      fontFamily: 'font',
                    ))),
            content: show123(),
          );
        });
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

    final headers = {'Content-Type': 'application/json', 'cookie': widget.prefs.getString('token')!};

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

  List<TicketModel> sortedTicket = [];

  filter() {
    setState(() {
      tickets.removeWhere((ticket) => ticket.basePrice! < _lowerValue || ticket.basePrice! > _upperValue);
    });
  }

  sort(int sortParam) {
    showSorted = true;
    print(sortParam);
    sortedTicket = tickets;
    if (sortParam == 0) {
      sortedTicket.sort((a, b) => a.basePrice!.compareTo(b.basePrice!));
    } else if (sortParam == 1) {
      sortedTicket.sort((a, b) => a.date!.compareTo(b.date!));
    } else {
      sortedTicket = tickets;
    }
  }
}
