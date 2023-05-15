import 'package:alibaba_clone/Screens/TransportPages/DifferentTransportaion/EnterTravelersData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'BusSeat.dart';

class BusSeatView extends StatefulWidget {
  const BusSeatView({Key? key}) : super(key: key);

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
        body: Column(
      children: [
        Container(
          // height: MediaQuery.of(context).size.height ,
          // width: MediaQuery.of(context).size.width ,
          margin: const EdgeInsets.only(right: 60, left: 60, top: 60, bottom: 20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: Colors.grey, // Set border color
                  width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(10.0)), // Set rounded corner radius
              boxShadow: [BoxShadow(blurRadius: 3)]),
          child: Column(children: [
            SizedBox(height: 10),
            Text("جلوی اتوبوس", style: TextStyle(fontWeight: FontWeight.bold)),
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
            SizedBox(height: 50),
          ]),
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width - 100,
            height: 50,
            child: ElevatedButton(
                onPressed: () {
                  if (userTicketsToBuy.isNotEmpty) {
                    showAlertForCheckSeats(context, userTicketsToBuy.length * 100, userTicketsToBuy.length);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("باید حداقل یک صندلی انتخاب کنید"),
                    ));
                  }
                },
                child: Text("تایید و ادامه")))
      ],
    ));
  }

  showAlertForCheckSeats(BuildContext context, double price, int number) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("تایید"),
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => EnterTravelersData(travelersCount: userTicketsToBuy.length)));
      },
    );
    Widget continueButton = TextButton(
      child: const Text("بازبینی صندلی ها"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      // title: Text("AlertDialog"),
      content: Directionality(
          textDirection: TextDirection.rtl,
          child: Text("شما $number بلیط به مبلغ $price تهیه کرده اید در صورت تایید ادامه فرآیند خرید را انجام دهید. ")),
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
          travelerSeat(++number, false, true),
          Row(children: [
            travelerSeat(++number, false, true),
            travelerSeat(++number, false, true),
          ])
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          travelerSeat(++number, false, true),
          Row(children: [
            travelerSeat(++number, false, true),
            travelerSeat(++number, false, true),
          ])
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          travelerSeat(++number, false, true),
          Row(children: [
            travelerSeat(++number, false, true),
            travelerSeat(++number, false, true),
          ])
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          travelerSeat(++number, false, true),
          Row(children: [
            travelerSeat(++number, false, true),
            travelerSeat(++number, false, true),
          ])
        ],
      ),
      Row(
        children: [
          travelerSeat(++number, false, true),
        ],
      ),
      Row(
        children: [
          travelerSeat(++number, false, true),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          travelerSeat(++number, false, true),
          Row(children: [
            travelerSeat(++number, false, true),
            travelerSeat(++number, false, true),
          ])
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          travelerSeat(++number, false, true),
          Row(children: [
            travelerSeat(++number, false, true),
            travelerSeat(++number, false, true),
          ])
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          travelerSeat(++number, false, true),
          Row(children: [
            travelerSeat(++number, false, true),
            travelerSeat(++number, false, true),
          ])
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          travelerSeat(++number, false, true),
          Row(children: [
            travelerSeat(++number, false, true),
            travelerSeat(++number, false, true),
          ])
        ],
      ),
    ]);
  }

  travelerSeat(int number, bool reserved, bool men) {
    return BusSeat(reserved: reserved, men: men, number: number, userChooseTicket: userChooseTicket);
  }

  List<int> userTicketsToBuy = [];

  void userChooseTicket(bool reserved, int number) {
    if (reserved) {
      userTicketsToBuy.add(number);
    } else {
      userTicketsToBuy.remove(userTicketsToBuy.firstWhere((element) => (element == number)));
    }
  }

// void generateBusSeatArray() {
//   for (var i = 0; i <= 18; i++) {
//     if (i % 3 == 0) {
//       // seatList.add(BusSeat(true, false, false, reserved: null, men: null,));
//     } else if (i % 3 == 1) {
//       seatList.add(BusSeat(false, true, false));
//     } else {
//       seatList.add(BusSeat(false, false, true));
//     }
//   }
}
