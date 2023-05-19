import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BusSeat extends StatefulWidget {
  const BusSeat(
      {Key? key,
      required this.reserved,
      required this.men,
      required this.number,
      required this.userChooseTicket})
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
            side: const BorderSide(color: Colors.grey, width: 1, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(7)),
        child: InkWell(
          onTap: () {
            if (widget.reserved) {
              return;
            }
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
              children: [
                Text(getSeatText(), style: TextStyle(color: getTextColor(), fontFamily: 'font'))
              ],
            ),
          ),
        ));
  }

  getTextColor() {
    if (widget.reserved) {
      return Colors.white;
    } else if (userTapSeat) {
      return Colors.white;
    } else {
      return Colors.black;
    }
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
    Random random = Random();
    int randomNumber = random.nextInt(10);
    if (widget.reserved) {
      if (randomNumber > 5) {
        return "آقا";
      } else {
        return "خانم";
      }
    } else {
      return widget.number.toString();
    }
  }
}
