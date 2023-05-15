import 'package:flutter/material.dart';

class DomesticFlightPage extends StatelessWidget {
  const DomesticFlightPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset("assets/images/domestic_flight.jpg", height: 120, fit: BoxFit.fill),
        ],
      ),
    );
  }
}
