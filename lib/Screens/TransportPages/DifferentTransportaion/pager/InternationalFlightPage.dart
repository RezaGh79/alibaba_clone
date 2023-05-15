import 'package:flutter/material.dart';

class InternationalFlightPage extends StatelessWidget {
  const InternationalFlightPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset("assets/images/international_flight.jpg", height: 120, fit: BoxFit.fill),
        ],
      ),
    );
  }
}
