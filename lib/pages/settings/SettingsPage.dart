import 'package:enis/classes/diary.dart';
import 'package:enis/classes/globals.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List diaries = [
    ['IMKO', 'Формативки'],
    ['JKO', 'СОр и СОч']
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: diaries.map((value) {
                  Diary diary = (value[0] == 'IMKO') ? Diary.imko : Diary.jko;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        Globals.user.diary = diary;
                        Globals.user.saveToPrefs();
                      });
                    },
                    child: Column(children: [
                      AnimatedDefaultTextStyle(
                        duration: Duration(milliseconds: 100),
                        style: TextStyle(
                            color: (Globals.user.diary == diary)
                                ? Colors.blue
                                : Colors.white),
                        child: Text(
                          value[0],
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.w700),
                        ),
                      ),
                      AnimatedDefaultTextStyle(
                        duration: Duration(milliseconds: 100),
                        style: TextStyle(
                            color: (Globals.user.diary == diary)
                                ? Colors.blue.withOpacity(0.7)
                                : Colors.white70),
                        child: Text(
                          value[1],
                          style: TextStyle(),
                        ),
                      ),
                    ]),
                  );
                }).toList(),
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
              ),

              FlatButton(
                child: Text('Log out'),
                onPressed: () async {
                  await Globals.user.logout();
                  Navigator.of(context).pushReplacementNamed('login');
                }
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
