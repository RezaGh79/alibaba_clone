import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BusSeat extends StatefulWidget {
  const BusSeat(
      {Key? key, required this.reserved, required this.men, required this.number, required this.userChooseTicket})
      : super(key: key);
  final bool reserved;
  final bool men;
  final int number;
  final Function userChooseTicket;

  @override
  State<BusSeat> createState() => _BusSeatState();
}

class _BusSeatState extends State<BusSeat> {
  bool userTapSeat = false;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: getSeatColor(),
        elevation: 2,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey, width: 1, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(7)),
        child: InkWell(
          onTap: () {
            widget.userChooseTicket(!userTapSeat, widget.number);
            setState(() {
              userTapSeat = !userTapSeat;
            });
          },
          child: SizedBox(
            width: 46,
            height: 45,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(getSeatText())],
            ),
          ),
        ));
  }

  getSeatColor() {
    if (userTapSeat) {
      return Colors.blue;
    } else if (widget.reserved) {
      return Colors.blueGrey;
    } else {
      return Colors.white;
    }
  }

  String getSeatText() {
    if (widget.reserved) {
      if (widget.men) {
        return "آقا";
      } else {
        return "خانم";
      }
    } else {
      return widget.number.toString();
    }
  }
}
