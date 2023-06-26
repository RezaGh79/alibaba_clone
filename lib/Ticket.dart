import 'dart:math';

import 'package:alibaba_clone/Screens/TransportPages/DifferentTransportaion/BusSeatView.dart';
import 'package:alibaba_clone/models/TicketsModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Ticket extends StatelessWidget {
  const Ticket({Key? key, required this.ticket}) : super(key: key);
  final TicketModel ticket;

  // final Jalali dateJalali;
  // final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 13, left: 13, top: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        elevation: 4,
        child: InkWell(
          onTap: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => BusSeatView(ticket: ticket, dateJalali: dateJalali, prefs: prefs)));
          },
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(children: const [
                  SizedBox(width: 20),
                  Text("VIP",
                      style: TextStyle(
                        fontFamily: 'font',
                      )),
                  Spacer(),
                  Text("ایران ایر", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'font', fontSize: 15)),
                  SizedBox(width: 10)
                ]),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  Text(ticket.destination.toString(),
                      style: const TextStyle(
                        fontFamily: 'font',
                      )),
                  Container(
                    width: 80,
                    height: 1,
                    color: Colors.grey,
                  ),
                  Text(ticket.source.toString(),
                      style: const TextStyle(
                        fontFamily: 'font',
                      )),
                  Text(
                    convertUtcToLocal().toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'font'),
                  )
                ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end, // use whichever suits your need
                    children: [
                      TextButton(
                          onPressed: () {},
                          child: const Text("قوانین جریمه و استرداد",
                              style: TextStyle(
                                fontFamily: 'font',
                              ))),
                      // SizedBox(width: 20),
                      // TextButton(
                      //     onPressed: () {},
                      //     child: Text("نقشه صندلی‌ها",
                      //         style: TextStyle(
                      //           fontFamily: 'font',
                      //         )),
                      // ),
                      const SizedBox(width: 5)
                    ]),
                Container(
                  width: double.infinity,
                  height: 0.5,
                  color: Colors.grey,
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // use whichever suits your need
                      children: [
                        Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text("${108 - Random().nextInt(15) - ticket.occupiedSeats.length} صندلی خالی",
                                style: TextStyle(
                                  fontFamily: 'font',
                                ))),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                              "${ticket.basePrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} تومان",
                              style: const TextStyle(
                                fontFamily: 'font',
                              )),
                        )
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String convertUtcToLocal() {
    return (ticket.date.toString().split("T")[1]).substring(0, 5);
  }
}
