import 'dart:convert';

import 'package:alibaba_clone/models/TicketsModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  double priceWithoutDiscount = 0.0;

  @override
  void initState() {
    priceWithoutDiscount = (widget.ticket.basePrice!).toDouble();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("اطلاعات نهایی بلیت",
                style: const TextStyle(
                  fontFamily: 'font',
                ))),
        body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: SingleChildScrollView(
              child: Column(children: [
            ticketData(),
            supervisorData(),
            disCount(),
            wallet(),
            finalConfirmation(),
          ])),
        ));
  }

  ticketData() {
    var ticket = widget.ticket;
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text("اطلاعات بلیت", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'font', fontSize: 16)),
            SizedBox(width: 10),
            Icon(Icons.people)
          ]),
          SizedBox(height: 10),
          tableData(<String, String>{
            "مبدا": ticket.source.toString(),
            "مقصد": ticket.destination.toString(),
            "تاریخ و ساعت حرکت": "${widget.dateJalali.day} ${monthList[widget.dateJalali.month - 1]}",
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
        child: Column(children: [
          Text(s1,
              style: const TextStyle(
                fontFamily: 'font',
              ))
        ]),
      ),
      Container(
        color: Colors.grey[300],
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(children: [
            Text(s2,
                style: const TextStyle(
                  fontFamily: 'font',
                ))
          ]),
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
            Text("مشخصات سرپرست", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'font', fontSize: 16)),
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
        child: Column(children: [
          Text("s1",
              style: const TextStyle(
                fontFamily: 'font',
              ))
        ]),
      ),
      Container(
        color: Colors.grey[300],
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(children: [
            Text("s2",
                style: const TextStyle(
                  fontFamily: 'font',
                ))
          ]),
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
          Row(mainAxisAlignment: MainAxisAlignment.end, children: const [
            Text("کد تخفیف", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'font', fontSize: 16)),
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
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            if (isDiscountDone) {
                              toast('کد تخفیف را استفاده کرده اید');
                              return;
                            }
                            discountDone();
                          },
                          child: const Text("اعمال کد", style: TextStyle(fontFamily: 'font'))))),
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
                        hintStyle: TextStyle(fontFamily: 'font'),
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

  bool isWinnerTakesAll = true;
  bool useWallet = true;

  wallet() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        useWallet = !useWallet;
                      });
                    },
                    child: Container(
                      height: 28,
                      width: 28,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: useWallet ? Colors.blue : Colors.white,
                          border: Border.all(width: 2, color: Colors.blue)),
                      child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: useWallet
                              ? Icon(
                                  Icons.check,
                                  size: 18.0,
                                  color: Colors.white,
                                )
                              : Container()),
                    ),
                  ),
                  Row(children: [
                    Text("استفاده از کیف پول",
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'font', fontSize: 16)),
                    SizedBox(width: 10),
                    Icon(Icons.wallet),
                  ]),
                ]),
                Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text("${widget.prefs.getInt('wallet')} ", style: const TextStyle(fontSize: 13, fontFamily: 'font')),
                    Text(":موجودی", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'font', fontSize: 13)),
                    SizedBox(width: 10),
                  ]),
                )
              ],
            ),
          ),
          SizedBox(height: 10),
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
          Row(mainAxisAlignment: MainAxisAlignment.end, children: const [
            Text("تایید نهایی", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'font', fontSize: 16)),
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
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            orderTicket();
                          },
                          child: Text("پرداخت",
                              style: const TextStyle(
                                fontFamily: 'font',
                              ))))),
              const SizedBox(width: 20),
              Expanded(
                  child: Directionality(
                textDirection: TextDirection.rtl,
                child: Text("مبلغ قابل پرداخت     " + "${widget.nationalCodes.length * priceWithoutDiscount} ریال",
                    style: const TextStyle(
                      fontFamily: 'font',
                    )),
              )),
            ],
          ),
          const SizedBox(height: 10)
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
    final uri = Uri.parse("${GlobalVariables.BASE_URL_TICKETS}/api/tickets/orderticket");
    Map<String, String> boughtTickets = getTicketsMap();
    Map<String, dynamic> body = {
      'travelId': widget.ticket.id,
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

    print(response.body);
    if (response.statusCode == 200) {
      toast('بلیت شما با موفقیت رزرو شد');

      // print(response.body);
      // tickets = (json.decode(response.body) as List).map((i) => TicketModel.fromJson(i)).toList();
      setState(() {
        if (useWallet) {
          int? current = widget.prefs.getInt('wallet');
          widget.prefs.setInt('wallet', current! - (boughtTickets.length * priceWithoutDiscount).toInt());
        } else {
          toast('موجودی کافی ندارید');
        }
      });
    } else {}
  }

  Map<String, String> getTicketsMap() {
    Map<String, String> boughtTickets = {};
    for (var i = 0; i < widget.nationalCodes.length; i++) {
      boughtTickets.putIfAbsent(widget.boughtSeats[i].toString(), () => widget.nationalCodes[i].toString());
    }
    return boughtTickets;
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

  var isDiscountDone = false;

  void discountDone() {
    isDiscountDone = true;
    setState(() {
      priceWithoutDiscount *= 0.8;
    });
    toast("کد تحفیف اعمال شد");
  }
}
