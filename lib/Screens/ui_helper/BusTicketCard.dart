import 'package:alibaba_clone/Screens/TransportPages/DifferentTransportaion/BusSeatView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BusTicketCard extends StatelessWidget {
  const BusTicketCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, left: 15, top: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        elevation: 4,
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => BusSeatView()));
          },
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(children: [
                  SizedBox(width: 20),
                  Text("VIP"),
                  Spacer(),
                  Text("پیک صبا", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 20)
                ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // use whichever suits your need
                    children: [
                      Text("تهران پایانه آزادی"),
                      Container(
                        width: 80,
                        height: 1,
                        color: Colors.grey,
                      ),
                      Text("اصفهان پایانه کاوه"),
                      Text("23:45", style: TextStyle(fontWeight: FontWeight.bold))
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end, // use whichever suits your need
                    children: [
                      TextButton(onPressed: () {}, child: Text("قوانین جریمه و استرداد")),
                      SizedBox(width: 20),
                      TextButton(onPressed: () {}, child: Text("نقشه صندلی‌ها")),
                      SizedBox(width: 5)
                    ]),
                Container(
                  width: double.infinity,
                  height: 0.5,
                  color: Colors.grey,
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // use whichever suits your need
                      children: [
                        Text("6 ظرفیت خالی"),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                              "${'12345'.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ریال"),
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
}
