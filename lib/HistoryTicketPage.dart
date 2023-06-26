import 'package:alibaba_clone/Ticket.dart';
import 'package:flutter/material.dart';

import 'GlobalVariables.dart';
import 'dart:convert';
import 'dart:math';

import 'package:alibaba_clone/Screens/TransportPages/DifferentTransportaion/utils/OriginsDestinations.dart';
import 'package:alibaba_clone/Screens/ui_helper/BusTicketCard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../GlobalVariables.dart';
import '../../../../Strings.dart';
import 'package:http/http.dart';

import '../../../../constants.dart';
import '../../../../models/TicketsModel.dart';

class HistoryTicketPage extends StatefulWidget {
  const HistoryTicketPage({Key? key}) : super(key: key);

  @override
  State<HistoryTicketPage> createState() => _HistoryTicketPageState();
}

class _HistoryTicketPageState extends State<HistoryTicketPage> {
  bool showProgressBar = true;
  List<TicketModel> tickets = [];

  @override
  void initState() {
    getTickets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("تاریخ چه بلیت ها", style: TextStyle(fontFamily: 'font'))),
      body: showProgressBar
          ? const Center(child: SizedBox(width: 42, height: 42, child: CircularProgressIndicator(strokeWidth: 4.2)))
          : ListView.builder(
            itemCount: tickets.length,
            itemBuilder: (context, i) {
              return Ticket(ticket: tickets[i]);
            },
          ),
    );
  }

  void getTickets() async {
    final uri = Uri.parse("${GlobalVariables.BASE_URL_TICKETS}/api/userTickets?token=${GlobalVariables.token}");

    print(uri);

    final headers = {
      'Content-Type': 'application/json',
    };

    // Map<String, dynamic> body = {"username": username, "password": password, "otp": otp};
    // String jsonBody = json.encode(body);
    // final encoding = Encoding.getByName('utf-8');
    print("here");

    Response response = await get(
      uri,
      headers: headers,
      // body: jsonBody,
      // encoding: encoding,
    );

    print(response.body);

    if (response.statusCode < 400) {
      tickets = (json.decode(response.body) as List).map((i) => TicketModel.fromJson1(i)).toList();
      setState(() {
        showProgressBar = false;
      });
    } else {}
  }
}
