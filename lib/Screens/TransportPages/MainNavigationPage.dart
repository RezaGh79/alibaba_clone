import 'package:alibaba_clone/Screens/TransportPages/DifferentTransportaion/pager/BusPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Strings.dart';
import '../ui_helper/BottomNav.dart';
import 'DifferentTransportaion/pager/DomesticFlightPage.dart';
import 'DifferentTransportaion/pager/InternationalFlightPage.dart';
import 'DifferentTransportaion/pager/TrainPage.dart';

class MainNavigatorPage extends StatefulWidget {
  const MainNavigatorPage({Key? key}) : super(key: key);

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
      // appBar: AppBar(
      //   brightness: Brightness.dark,
      //   title: const Text(Strings.appname),
      //   actions: [
      //     IconButton(
      //         onPressed: () {
      //           setState(() {
      //             // searchClicked = true;
      //           });
      //         },
      //         icon: Icon(Icons.search)),
      //     PopupMenuButton<String>(onSelected: (value) {
      //       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //       //   content: Text(value),
      //       // ));
      //       // handleActionsClick(value);
      //     }, itemBuilder: (BuildContext context) {
      //       return [
      //         PopupMenuItem(child: Text("New Group"), value: "new group"),
      //         PopupMenuItem(child: Text("Settings"), value: "Settings"),
      //       ];
      //     })
      //   ],
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.history),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNav(controller: pageController),
      body: PageView(
        controller: pageController,
        children: const [
          BusPage(),
          TrainPage(),
          DomesticFlightPage(),
          InternationalFlightPage(),
        ],
      ),
    );
  }
}
