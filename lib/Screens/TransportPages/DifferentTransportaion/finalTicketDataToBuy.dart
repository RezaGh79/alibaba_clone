import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FinalTicketToBuy extends StatefulWidget {
  const FinalTicketToBuy({Key? key}) : super(key: key);

  @override
  State<FinalTicketToBuy> createState() => _FinalTicketToBuyState();
}

class _FinalTicketToBuyState extends State<FinalTicketToBuy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(children: [
            ticketData(),
        Center(
            child: Column(children: <Widget>[
              Container(
                margin: EdgeInsets.all(20),
                child: Table(
                  defaultColumnWidth: FixedColumnWidth(120.0),
                  border: TableBorder.all(
                      color: Colors.black,
                      style: BorderStyle.solid,
                      width: 2),
                  children: [
                    TableRow(children: [
                      Column(children: [Text('Website', style: TextStyle(fontSize: 20.0))]),
                      Column(children: [Text('Tutorial', style: TextStyle(fontSize: 20.0))]),
                      Column(children: [Text('Review', style: TextStyle(fontSize: 20.0))]),
                    ]),
                    TableRow(children: [
                      Column(children: [Text('Javatpoint')]),
                      Column(children: [Text('Flutter')]),
                      Column(children: [Text('5*')]),
                    ]),
                    TableRow(children: [
                      Column(children: [Text('Javatpoint')]),
                      Column(children: [Text('MySQL')]),
                      Column(children: [Text('5*')]),
                    ]),
                    TableRow(children: [
                      Column(children: [Text('Javatpoint')]),
                      Column(children: [Text('ReactJS')]),
                      Column(children: [Text('5*')]),
                    ]),
                  ],
                ),
              )]))]));
  }

  ticketData() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            // if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: const [
                Text("کد ملی مسافران را وارد نمایید", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 10),
                Icon(Icons.people)
              ]),
            );
            // } else {
            //   return nationalNumberTextField(index);
            // }
          }),
        ),
      ),
    );
  }
}
