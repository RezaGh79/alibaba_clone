import 'package:alibaba_clone/Screens/TransportPages/DifferentTransportaion/pager/BusPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Strings.dart';
import '../ui_helper/BottomNav.dart';
import 'DifferentTransportaion/pager/DomesticFlightPage.dart';
import 'DifferentTransportaion/pager/InternationalFlightPage.dart';
import 'DifferentTransportaion/pager/TrainPage.dart';

class MainNavigatorPage extends StatefulWidget {
  MainNavigatorPage({Key? key, required this.prefs}) : super(key: key);
  final SharedPreferences prefs;

  @override
  State<MainNavigatorPage> createState() => _MainNavigatorPageState();
}

class _MainNavigatorPageState extends State<MainNavigatorPage> with SingleTickerProviderStateMixin {
  late TabController _controller;
  final PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    _controller = TabController(length: 4, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.history),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNav(controller: pageController),
      body: PageView(
        controller: pageController,
        children: [
          BusPage(prefs: widget.prefs),
          TrainPage(prefs: widget.prefs),
          DomesticFlightPage(),
          InternationalFlightPage(),
        ],
      ),
    );
  }
}
