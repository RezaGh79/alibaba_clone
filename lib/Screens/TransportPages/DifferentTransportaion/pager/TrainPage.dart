import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../../../Strings.dart';
import '../../../../constants.dart';
import '../utils/OriginsDestinations.dart';

class TrainPage extends StatefulWidget {
  const TrainPage({Key? key}) : super(key: key);

  @override
  State<TrainPage> createState() => _TrainPageState();
}

class _TrainPageState extends State<TrainPage> {
  var origin = "";
  var destination = "";
  String? travelDate = "";
  bool hideChoosingOriginAndDestination = false;

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
          title: Text(travelDate == "" ? "بلیت قطار" : "$origin به $destination در ${travelDate!}",
              style: const TextStyle(
                fontFamily: 'font',
              )),
          centerTitle: true,
        ),
        body: Column(
          children: [
            !hideChoosingOriginAndDestination
                ? Column(children: [
                    Image.asset("assets/images/train.jpg", height: 120, fit: BoxFit.fill),
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
                                    style: TextStyle(
                                      fontFamily: 'font',
                                    ))),
                          ]),
                    ),
                    Row(children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ElevatedButton(
                            onPressed: () {},
                            child: Text(Strings.search,
                                style: TextStyle(
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
                                style: TextStyle(
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
                              child: Text(
                                  travelDate == "" ? Strings.ticketDate : travelDate.toString(),
                                  style: TextStyle(
                                    fontFamily: 'font',
                                  )))),
                    ]),
                  ])
                : Container(),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, i) {
                  // return BusTicketCard(ticket: );
                  return Container();
                },
              ),
            )
          ],
        ));
  }

  void showOriginDestinationAlert(String originOrDestination) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Directionality(
              textDirection: TextDirection.rtl,
              child: Text("لیست شهرها",
                  style: TextStyle(
                    fontFamily: 'font',
                  )),
            ),
            content: setupAlertDialogContainer(originOrDestination),
          );
        });
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
                        style: TextStyle(
                          fontFamily: 'font',
                        )),
                  ),
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
          style: TextStyle(
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
                            style: TextStyle(
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
                            style: TextStyle(
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
                        Text("نوزاد    ")
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
}
