import 'dart:math';

import 'package:enis/classes/globals.dart';
import 'package:enis/pages/subjects/GradesPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  final GradesPage gradesPage = new GradesPage();
  AnimationController controller;
  Animation<double> animation;
  String popupText;
  initState() {
    super.initState();
    DateTime now = DateTime.now();

    if (now.hour >= 0 && now.hour < 12) {
      popupText =
          'Good morning, ${Globals.user.identifier.studentName.split(' ')[1]}!';
    } else if (now.hour >= 12 && now.hour < 17) {
      popupText =
          'Good afternoon, ${Globals.user.identifier.studentName.split(' ')[1]}!';
    } else {
      popupText =
          'Good evening, ${Globals.user.identifier.studentName.split(' ')[1]}!';
    }
    controller = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 300));

    animation =
        new CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    controller.addListener(() {
      setState(() {});
    });
    launchAnimation();
  }
  GravitySimulation simulation = GravitySimulation(9.81, 0.0, 300.0, 50.0);
  launchAnimation() async {
    controller.forward(from: 0.0);
    new Future.delayed(Duration(seconds: 2), () {
      controller.reverse(from: 1.0);
    });
  }

  bool launchPopup = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          gradesPage,
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Transform(
                transform: new Matrix4.translationValues(
                    0.0, 50.0 * (1.0 - animation.value), 0.0),
                child: Opacity(
                  opacity: animation.value,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    width: double.infinity,
                    child: Text(
                      popupText,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
