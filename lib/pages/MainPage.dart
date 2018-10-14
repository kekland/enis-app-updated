import 'package:enis/pages/subjects/GradesPage.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int navSelected = 0;
  final GradesPage gradesPage = new GradesPage();

  Widget getSelected() {
    if (navSelected == 0) {
      return gradesPage;
    } else if (navSelected == 1) {
      return new Container(color: Colors.red);
    } else if (navSelected == 2) {
      return new Container(color: Colors.blue);
    }
  }

  @override
  Widget build(BuildContext context) {/*
    return Scaffold(
      body: getSelected(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            title: Text('Grades'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            title: Text('Calculator'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
        currentIndex: navSelected,
        onTap: (index) => setState(
              () {
                navSelected = index;
              },
            ),
      ),
    );*/
    return gradesPage;
  }
}
