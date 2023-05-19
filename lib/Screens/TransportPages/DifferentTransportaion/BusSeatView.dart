import 'package:alibaba_clone/Screens/TransportPages/DifferentTransportaion/EnterTravelersData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/TicketsModel.dart';
import 'BusSeat.dart';

class BusSeatView extends StatefulWidget {
  const BusSeatView({Key? key, required this.ticket, required this.dateJalali, required this.prefs})
      : super(key: key);
  final TicketModel ticket;
  final Jalali dateJalali;
  final SharedPreferences prefs;

  @override
  State<BusSeatView> createState() => _BusSeatViewState();
}

class _BusSeatViewState extends State<BusSeatView> {
  List<BusSeat> seatList = [];

  @override
  void initState() {
    // generateBusSeatArray();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => {Navigator.of(context).pop()},
          ),
          title: const Text("انتخاب صندلی",
              style: TextStyle(
                fontFamily: 'font',
              )),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              // height: MediaQuery.of(context).size.height ,
              // width: MediaQuery.of(context).size.width ,
              margin: const EdgeInsets.only(right: 60, left: 60, top: 15, bottom: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: Colors.grey, // Set border color
                      width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  // Set rounded corner radius
                  boxShadow: [BoxShadow(blurRadius: 3)]),
              child: Column(children: [
                SizedBox(height: 10),
                Text("جلوی اتوبوس",
                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'font')),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Container(
                    color: Colors.grey,
                    height: 1.1,
                    width: double.infinity,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: wholeTravelerSeat(),
                ),
                SizedBox(height: 30),
              ]),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width - 100,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      if (userTicketsToBuy.isNotEmpty) {
                        showAlertForCheckSeats(
                            context,
                            userTicketsToBuy.length * widget.ticket.basePrice!,
                            userTicketsToBuy.length);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("باید حداقل یک صندلی انتخاب کنید",
                              style: const TextStyle(
                                fontFamily: 'font',
                              )),
                        ));
                      }
                    },
                    child: Text("تایید و ادامه",
                        style: const TextStyle(
                          fontFamily: 'font',
                        ))))
          ],
        ));
  }

  showAlertForCheckSeats(BuildContext context, int price, int number) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("تایید",
          style: const TextStyle(
            fontFamily: 'font',
          )),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EnterTravelersData(
                  travelersCount: userTicketsToBuy.length,
                  ticket: widget.ticket,
                  boughtSeats: userTicketsToBuy,
                  dateJalali: widget.dateJalali,
                  prefs: widget.prefs,
                )));
      },
    );
    Widget continueButton = TextButton(
      child: const Text("بازبینی صندلی ها",
          style: const TextStyle(
            fontFamily: 'font',
          )),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      // title: Text("AlertDialog"),
      content: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
              "شما $number بلیط به مبلغ $price تومان تهیه کرده اید در صورت تایید ادامه فرآیند خرید را انجام دهید. ",
              style: const TextStyle(
                fontFamily: 'font',
              ))),
      actions: [
        continueButton,
        cancelButton,
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

  Widget wholeTravelerSeat() {
    int number = 0;
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          travelerSeat(++number, false),
          Row(children: [
            travelerSeat(++number, false),
            travelerSeat(++number, false),
          ])
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          travelerSeat(++number, false),
          Row(children: [
            travelerSeat(++number, false),
            travelerSeat(++number, false),
          ])
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          travelerSeat(++number, false),
          Row(children: [
            travelerSeat(++number, false),
            travelerSeat(++number, false),
          ])
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          travelerSeat(++number, false),
          Row(children: [
            travelerSeat(++number, false),
            travelerSeat(++number, false),
          ])
        ],
      ),
      Row(
        children: [
          travelerSeat(++number, false),
        ],
      ),
      Row(
        children: [
          travelerSeat(++number, false),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          travelerSeat(++number, false),
          Row(children: [
            travelerSeat(++number, false),
            travelerSeat(++number, false),
          ])
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          travelerSeat(++number, false),
          Row(children: [
            travelerSeat(++number, false),
            travelerSeat(++number, false),
          ])
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          travelerSeat(++number, false),
          Row(children: [
            travelerSeat(++number, false),
            travelerSeat(++number, false),
          ])
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          travelerSeat(++number, false),
          Row(children: [
            travelerSeat(++number, false),
            travelerSeat(++number, false),
          ])
        ],
      ),
    ]);
  }

  travelerSeat(int number, bool men) {
    bool reserved;
    if (widget.ticket.occupiedSeats.contains(number)) {
      reserved = true;
    } else {
      reserved = false;
    }
    return BusSeat(
        reserved: reserved, men: men, number: number, userChooseTicket: userChooseTicket);
  }

  List<int> userTicketsToBuy = [];

  void userChooseTicket(bool reserved, int number) {
    if (reserved) {
      userTicketsToBuy.add(number);
    } else {
      userTicketsToBuy.remove(userTicketsToBuy.firstWhere((element) => (element == number)));
    }
  }
}
