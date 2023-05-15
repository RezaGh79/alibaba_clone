import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Strings.dart';
import '../../../constants.dart';

class FinalTicketToBuy extends StatefulWidget {
  FinalTicketToBuy({Key? key}) : super(key: key);

  @override
  State<FinalTicketToBuy> createState() => _FinalTicketToBuyState();
}

class _FinalTicketToBuyState extends State<FinalTicketToBuy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("اطلاعات نهایی بلیت")),
        body: SingleChildScrollView(
            child: Column(
                children: [ticketData(), supervisorData(), disCount(), finalConfirmation()])));
  }

  ticketData() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text("اطلاعات بلیت", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 10),
            Icon(Icons.people)
          ]),
          SizedBox(height: 10),
          tableData(<String, String>{
            "مبدا": '',
            "مقصد": '',
            "تاریخ و ساعت حرکت": '',
            'شرکت مسافربری': '',
            'نوع اتوبوس': '',
            'تعداد صندلی': '',
            'شماره صندلی ها': '',
            'قیمت هر صندلی': '',
            'مبلغ کل': '',
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
        padding: EdgeInsets.all(4.0),
        child: Column(children: [Text(s1)]),
      ),
      Container(
        color: Colors.grey[300],
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: Column(children: [Text(s2)]),
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
            Text("مشخصات سرپرست", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 10),
            Icon(Icons.people)
          ]),
          SizedBox(height: 10),
          tableData(<String, String>{"نام و نام خانوادگی": "", "جنسیت": "", "شماره تلفن": ""})
          // tableRow("s1", "s2"),
          // superVisorTable(),
        ]),
      ),
    );
  }

  superVisorTable() {
    TableRow(children: [
      Padding(
        padding: EdgeInsets.all(4.0),
        child: Column(children: [Text("s1")]),
      ),
      Container(
        color: Colors.grey[300],
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: Column(children: [Text("s2")]),
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
            Text("کد تخفیف", style: TextStyle(fontWeight: FontWeight.bold)),
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
                          child: Text("اعمال کد")))),
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
            Text("تایید نهایی", style: TextStyle(fontWeight: FontWeight.bold)),
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
                          onPressed: () {},
                          child: Text("پرداخت")))),
              const SizedBox(width: 20),
              Expanded(child: Text("مبلغ قابل پرداخت     " + "100 ریال")),
            ],
          )
        ]),
      ),
    );
  }
}
