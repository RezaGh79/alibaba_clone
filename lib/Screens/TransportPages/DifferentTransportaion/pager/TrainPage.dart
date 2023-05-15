import 'package:flutter/material.dart';

class TrainPage extends StatelessWidget {
  const TrainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset("assets/images/train.jpg", height: 120, fit: BoxFit.fill),
        ],
      ),
    );
  }
}
