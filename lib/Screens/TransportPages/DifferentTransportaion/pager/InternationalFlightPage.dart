import 'dart:convert';

import 'package:alibaba_clone/Ticket.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../../../GlobalVariables.dart';
import '../../../../Strings.dart';
import '../../../../constants.dart';
import '../../../../models/TicketsModel.dart';
import '../../../ui_helper/BusTicketCard.dart';
import '../utils/OriginsDestinations.dart';

import 'package:http/http.dart';

class InternationalFlightPage extends StatefulWidget {
  const InternationalFlightPage({Key? key}) : super(key: key);

  @override
  State<InternationalFlightPage> createState() => _InternationalFlightPageState();
}

class _InternationalFlightPageState extends State<InternationalFlightPage> {
  var origin = "";
  var destination = "";
  String? travelDate = "";
  late Jalali dateJalali;
  bool hideChoosingOriginAndDestination = false;
  late Gregorian dateGregorian;
  bool showProgressBar = false;
  bool showSorted = false;
  RangeValues _currentRangeValues = const RangeValues(90, 190);

  int defaultChoiceIndex = 2;
  final List<String> _choicesList = ['قیمت', 'زودترین', 'پیش فرض'];
  bool checkedValue = false;

  List<TicketModel> sortedTicket = [];
  List<TicketModel> tickets = [];

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
          title: Text(travelDate == "" ? "بلیت هواپیمای خارجی" : "$origin به $destination در ${travelDate!}",
              style: const TextStyle(
                fontFamily: 'font',
              )),
          centerTitle: true,
        ),
        body: Column(
          children: [
            !hideChoosingOriginAndDestination
                ? Column(children: [
                    Image.asset("assets/images/international_flight.jpg", height: 120, fit: BoxFit.fill),
                    Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    showOriginDestinationAlert('origin');
                                  },
                                  child: Text(origin == "" ? "مبدا" : origin,
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
                                    showOriginDestinationAlert('destination');
                                  },
                                  child: Text(destination == "" ? "مقصد" : destination,
                                      style: const TextStyle(
                                        fontFamily: 'font',
                                      ))),
                            ]),
                      ),
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
                            child: Text(Strings.search,
                                style: const TextStyle(
                                  fontFamily: 'font',
                                ))),
                      )),
                      TextButton(
                          onPressed: () {
                            showNumberOfTravelersDialog();
                          },
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                                numberOfTravelers
                                    ? "${numberOfKids + numberOfBabies + numberOfAdult} مسافر"
                                    : "تعداد مسافر",
                                style: const TextStyle(
                                  fontFamily: 'font',
                                )),
                          )),
                      TextButton(
                          onPressed: () async {
                            if (origin == "" || destination == "") {
                              Fluttertoast.showToast(
                                msg: 'مبدا و مقصد را به درستی پر کنید',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.SNACKBAR,
                                backgroundColor: Colors.blueGrey,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            } else {
                              Jalali? picked = await showPersianDatePicker(
                                context: context,
                                initialDate: Jalali.now(),
                                firstDate: Jalali(1402, 4),
                                lastDate: Jalali(1402, 5),
                              );
                              setState(() {
                                try {
                                  travelDate = "${picked!.day} ${monthList[picked.month - 1]}";
                                  dateJalali = picked;
                                  // print(travelDate);
                                  Jalali g1 = Jalali(picked.year, picked.month, picked.day);
                                  dateGregorian = g1.toGregorian();
                                } catch (e) {}
                              });
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
                                                          min: 90,
                                                          max: 190,
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
                      return Ticket(
                        ticket: showSorted ? sortedTicket[i] : tickets[i],
                        // dateJalali: dateJalali,
                        // prefs: widget.prefs
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ));
  }

  void showOriginDestinationAlert(String originOrDestination) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: const Text("لیست شهرها",
                  style: const TextStyle(
                    fontFamily: 'font',
                  )),
              content: setupAlertDialogContainer(originOrDestination),
            ),
          );
        });
  }

  Widget setupAlertDialogContainer(String originOrDestination) {
    return SizedBox(
        height: 300.0,
        width: 300.0,
        child: ListView.builder(
          itemCount: OriginsDestinations.originsInternational.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
                onTap: () {
                  setState(() {
                    if (originOrDestination == "origin") {
                      origin = OriginsDestinations.originsInternational[index];
                    } else {
                      destination = OriginsDestinations.originsInternational[index];
                    }
                  });
                  Navigator.pop(context);
                },
                child: ListTile(
                  title: Text(OriginsDestinations.originsInternational[index],
                      style: const TextStyle(
                        fontFamily: 'font',
                      )),
                ));
          },
        ));
  }

  var numberOfAdult = 1;
  var numberOfKids = 0;
  var numberOfBabies = 0;
  bool numberOfTravelers = false;

  void showNumberOfTravelersDialog() {
    Widget okButton = TextButton(
      child: const Text("تایید",
          style: const TextStyle(
            fontFamily: 'font',
          )),
      onPressed: () {
        setState(() {
          numberOfTravelers = true;
        });
        Navigator.of(context).pop();
      },
    );

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
                actions: [okButton],
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: kPrimaryColor,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                numberOfAdult = decNumber(numberOfAdult);
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Center(
                                child: Icon(Icons.remove, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Text(numberOfAdult.toString(),
                            style: const TextStyle(
                              fontFamily: 'font',
                            )),
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: kPrimaryColor,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                numberOfAdult = incNumber(numberOfAdult);
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Center(
                                child: Icon(Icons.add, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Text("بزرگسال",
                            style: const TextStyle(
                              fontFamily: 'font',
                            ))
                      ]),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: kPrimaryColor,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                numberOfKids = decNumber(numberOfKids);
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Center(
                                child: Icon(Icons.remove, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Text(numberOfKids.toString(),
                            style: const TextStyle(
                              fontFamily: 'font',
                            )),
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: kPrimaryColor,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                numberOfKids = incNumber(numberOfKids);
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Center(
                                child: Icon(Icons.add, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Text("کودک    ",
                            style: const TextStyle(
                              fontFamily: 'font',
                            ))
                      ]),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: kPrimaryColor,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                numberOfBabies = decNumber(numberOfBabies);
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Center(
                                child: Icon(Icons.remove, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Text(numberOfBabies.toString(),
                            style: const TextStyle(
                              fontFamily: 'font',
                            )),
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: kPrimaryColor,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                numberOfBabies = incNumber(numberOfBabies);
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Center(
                                child: Icon(Icons.add, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Text("نوزاد    ",
                            style: const TextStyle(
                              fontFamily: 'font',
                            ))
                      ]),
                ]));
          },
        );
      },
    );
  }

  int incNumber(int number) {
    if (number >= 10) {
      toast('بیشتر از ۱۰ بلیت نمی توانید انتخاب کنید');
      return number;
    } else {
      return ++number;
    }
  }

  int decNumber(int number) {
    if (number == 0) {
      toast('تعداد بلیت ها نمیتواند کمتر از ۰ باشد!');
      return 0;
    } else {
      return --number;
    }
  }

  void toast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.blueGrey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
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

    final headers = {'Content-Type': 'application/json'};

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
      tickets = (json.decode(response.body) as List).map((i) => TicketModel.fromJson(i)).toList();
      GlobalVariables.copyTicks = tickets;
      setState(() {
        showProgressBar = false;
      });
    } else {}
  }

  sort(int sortParam) {
    showSorted = true;
    sortedTicket = tickets;
    if (sortParam == 0) {
      sortedTicket.sort((a, b) => a.basePrice!.compareTo(b.basePrice!));
    } else if (sortParam == 1) {
      sortedTicket.sort((a, b) => a.date!.compareTo(b.date!));
    } else {
      setState(() {
        tickets = GlobalVariables.copyTicks;
        showSorted = false;
      });

      // sortedTicket = tickets;
    }
  }

  filter() {
    // print(_currentRangeValues.end.toInt());
    // print(_currentRangeValues.start.toInt());
    // tickets.forEach((element) {
    //   print(element.basePrice);
    // });
    // print(GlobalVariables.copyTicks.length);
    // print(_lowerValue);
    // print(_upperValue);
    setState(() {
      tickets.removeWhere((ticket) =>
          ticket.basePrice! / 1000 < _currentRangeValues.start.toInt() ||
          ticket.basePrice! / 1000 > _currentRangeValues.end.toInt());
    });
  }
}
