import 'package:enis/classes/diary.dart';
import 'package:enis/classes/school.dart';
import 'package:enis/pages/login/CredentialsPage.dart';
import 'package:enis/pages/login/DiarySelectionPage.dart';
import 'package:enis/pages/login/SchoolSelectionPage.dart';
import 'package:flutter/material.dart';
import 'package:enis/pages/login/AnimatedPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  int currentPage = 0;
  int nextPage = -1;
  bool firstLaunch = true;
  AnimationController controller;
  Animation<double> animation;

  String school;
  Diary diary;

  @override
  initState() {
    super.initState();
    controller = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 500));

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (firstLaunch) {
          firstLaunch = false;
          return;
        }
        currentPage = nextPage;
        controller.value = 0.0;
      }
    });
    animation =
        new CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.reverse(from: 1.0);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      new SchoolSelectionPage(
        school: school,
        onSelected: (String selected) {
          setState(() {
            nextPage = 1;
            school = selected;
            controller.forward();
          });
        },
      ),
      new DiarySelectionPage(
        diary: diary,
        onSelected: (Diary selected) {
          setState(() {
            nextPage = 2;
            diary = selected;
            controller.forward();
          });
        },
        onDismissed: () {
          setState(() {
            nextPage = 0;
            controller.forward();
          });
        },
      ),
      new CredentialsPage(
        school: school,
        diary: diary,
        onDismissed: () {
          setState(() {
            nextPage = 1;
            controller.forward();
          });
        },
      ),
    ];
    return Scaffold(
      body: Stack(
        children: [
          AnimatedPageWidget(
            child: pages[currentPage],
            visible: true,
            animationReversed: true,
            animation: animation,
          ),
          IgnorePointer(
            child: AnimatedPageWidget(
              child: (nextPage != -1) ? pages[nextPage] : Container(),
              visible: (currentPage != nextPage),
              animationReversed: false,
              animation: animation,
            ),
          )
        ],
      ),
    );
  }
}
