import 'dart:convert';

import 'package:alibaba_clone/models/TicketsModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../GlobalVariables.dart';
import '../../../Strings.dart';
import '../../../constants.dart';
import 'package:http/http.dart';

class FinalTicketToBuy extends StatefulWidget {
  const FinalTicketToBuy(
      {Key? key,
      required this.ticket,
      required this.nationalCodes,
      required this.superVisorName,
      required this.superVisorLastName,
      required this.superVisorMobile,
      required this.menOrWomen,
      required this.boughtSeats,
      required this.dateJalali,
      required this.prefs})
      : super(key: key);

  final TicketModel ticket;
  final List<String> nationalCodes;
  final String superVisorName;
  final String superVisorLastName;
  final String superVisorMobile;
  final String menOrWomen;
  final List<int> boughtSeats;
  final Jalali dateJalali;
  final SharedPreferences prefs;

  @override
  State<FinalTicketToBuy> createState() => _FinalTicketToBuyState();
}

class _FinalTicketToBuyState extends State<FinalTicketToBuy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("اطلاعات نهایی بلیت",style: const TextStyle(
          fontFamily: 'font',
        ))),
        body: SingleChildScrollView(
            child: Column(
                children: [ticketData(), supervisorData(), disCount(), finalConfirmation()])));
  }

  ticketData() {
    var ticket = widget.ticket;
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text("اطلاعات بلیت", style: TextStyle(fontWeight: FontWeight.bold , fontFamily: 'font')),
            SizedBox(width: 10),
            Icon(Icons.people)
          ]),
          SizedBox(height: 10),
          tableData(<String, String>{
            "مبدا": ticket.source.toString(),
            "مقصد": ticket.destination.toString(),
            "تاریخ و ساعت حرکت":
                "${widget.dateJalali.day} ${monthList[widget.dateJalali.month - 1]}",
            'شرکت مسافربری': "پیک صبا",
            'نوع اتوبوس': 'VIP',
            'تعداد صندلی': widget.nationalCodes.length.toString(),
            'شماره صندلی ها': getFinalSeatsText(),
            'قیمت هر صندلی': ticket.basePrice.toString(),
            'مبلغ کل': (ticket.basePrice! * widget.nationalCodes.length).toString(),
          }),
        ]),
      ),
    );
  }

  tableData(Map<String, String> map) {
    List<TableRow> list = [];
    map.forEach((key, value) {
      list.add(tableRow(value, key));
    });
    return Table(
        defaultColumnWidth: FixedColumnWidth(170.0),
        border: TableBorder.all(color: Colors.black, style: BorderStyle.solid, width: 1),
        children: list);
  }

  tableRow(String s1, String s2) {
    return TableRow(children: [
      Padding(
        padding: EdgeInsets.all(5.0),
        child: Column(children: [Text(s1,style: const TextStyle(
          fontFamily: 'font',
        ))]),
      ),
      Container(
        color: Colors.grey[300],
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(children: [Text(s2, style: const TextStyle(
            fontFamily: 'font',
          ))]),
        ),
      ),
    ]);
  }

  supervisorData() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text("مشخصات سرپرست", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'font')),
            SizedBox(width: 10),
            Icon(Icons.people)
          ]),
          SizedBox(height: 10),
          tableData(<String, String>{
            "نام و نام خانوادگی": "${widget.superVisorName} ${widget.superVisorLastName}",
            "جنسیت": widget.menOrWomen,
            "شماره تلفن": widget.superVisorMobile
          })
          // tableRow("s1", "s2"),
          // superVisorTable(),
        ]),
      ),
    );
  }

  superVisorTable() {
    TableRow(children: [
      Padding(
        padding: EdgeInsets.all(5.0),
        child: Column(children: [Text("s1",style: const TextStyle(
          fontFamily: 'font',
        ))]),
      ),
      Container(
        color: Colors.grey[300],
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(children: [Text("s2",style: const TextStyle(
            fontFamily: 'font',
          ))]),
        ),
      ),
    ]);
  }

  disCount() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text("کد تخفیف", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'font')),
            SizedBox(width: 10),
            Icon(Icons.discount)
          ]),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                  child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), // <-- Radius
                            ),
                          ),
                          onPressed: () {},
                          child: Text("اعمال کد",style: const TextStyle(
                            fontFamily: 'font',
                          ))))),
              const SizedBox(width: 20),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      // controller: passwordController,
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                      cursorColor: kPrimaryColor,
                      decoration: InputDecoration(
                        hintText: 'کد تخفیف',
                        hintStyle: TextStyle(fontSize: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // more widgets
              )
            ],
          )
        ]),
      ),
    );
  }

  finalConfirmation() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text("تایید نهایی", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'font')),
            SizedBox(width: 10),
            Icon(Icons.payment)
          ]),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                  child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), // <-- Radius
                            ),
                          ),
                          onPressed: () {
                            orderTicket();
                          },
                          child: Text("پرداخت" , style: const TextStyle(
                            fontFamily: 'font',
                          ))))),
              const SizedBox(width: 20),
              Expanded(
                  child: Text("مبلغ قابل پرداخت     " +
                      "${widget.nationalCodes.length * widget.ticket.basePrice!} ریال",style: const TextStyle(
                    fontFamily: 'font',
                  ))),
            ],
          )
        ]),
      ),
    );
  }

  String getFinalSeatsText() {
    String text = "";
    for (var i = 0; i < widget.boughtSeats.length; i++) {
      if (i != widget.boughtSeats.length - 1) {
        text = "$text${widget.boughtSeats[i]}, ";
      } else {
        text = text + widget.boughtSeats[i].toString();
      }
    }
    return text;
  }

  Future<void> orderTicket() async {
    //2023-05-19
    //2023-05-20

    final uri = Uri.parse("${GlobalVariables.BASE_URL_TICKETS}/api/travels?");
    Map<String, String> boughtTickets = getTicketsMap();
    Map<String, dynamic> body = {
      'travelId': "15",
      'token': widget.prefs.getString('token'),
      "seat_reserved": boughtTickets
    };
    String jsonBody = json.encode(body);
    final headers = {'Content-Type': 'application/json'};

    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    if (response.statusCode < 400) {
      // print(response.body);
      // tickets = (json.decode(response.body) as List).map((i) => TicketModel.fromJson(i)).toList();
      setState(() {});
    } else {}
  }

  Map<String, String> getTicketsMap() {
    Map<String, String> boughtTickets = {};
    for (var i = 0; i < widget.nationalCodes.length; i++) {
      boughtTickets.putIfAbsent(
          widget.boughtSeats[i].toString(), () => widget.nationalCodes[i].toString());
    }
    return boughtTickets;
  }
}
