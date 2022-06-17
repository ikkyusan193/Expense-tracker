import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:eTracker/page/transcation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'create.dart';
import 'home.dart';

/// ROOT PAGE (We start from here)
/// 1. start from route '/'
/// 2. Navigation bar from main
/// 3. use body views and index to display the pages
/// (pages include, home, transaction and create pages)
class Launcher extends StatefulWidget {
  static const routeName = '/';

  const Launcher({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LauncherState();
  }
}

class _LauncherState extends State<Launcher> {
  int index = 0;
  final navigationKey = GlobalKey<CurvedNavigationBarState>();

  final screens = [
    const Home(),
    const TransactionPage(),
    const CreateTransactionPage(),
  ];

  final items = <Widget>[
    const Icon(Icons.home, size: 35),
    const Icon(FontAwesomeIcons.receipt, size: 35),
    const Icon(Icons.add_circle_outline, size: 35),
  ];

  /// Use curvedNavigationBar
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: screens[index],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        child: CurvedNavigationBar(
          color: Colors.blueAccent,
          buttonBackgroundColor: Colors.lightBlueAccent,
          items: items,
          height: 50,
          index: index,
          onTap: (index) => setState(() => this.index = index),
          backgroundColor: Colors.transparent,
          animationDuration: const Duration(milliseconds: 400),
        ),
    ),
    );
  }
}