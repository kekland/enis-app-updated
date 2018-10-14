import 'dart:convert';

import 'package:enis/api/user_data.dart';
import 'package:enis/classes/globals.dart';
import 'package:enis/classes/scroll_behavior.dart';
import 'package:enis/pages/MainPage.dart';
import 'package:enis/pages/login/LoginPage.dart';
import 'package:enis/pages/subjects/GradesPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userData = prefs.getString('user_data');
  if (userData != null) {
    print(prefs.getString('user_data'));
    Globals.user =
        new UserData.fromJSON(json.decode(prefs.getString('user_data')));
  }
  runApp(new MyApp());
} 

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(new SystemUiOverlayStyle(
        statusBarColor: const Color(0x00FFFFFF),
        statusBarIconBrightness: Brightness.light));
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        brightness: Brightness.dark,
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        accentColor: Colors.blue.shade500,
      ),
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: ScrollWithoutGlow(),
          child: child,
        );
      },
      initialRoute: (Globals.user != null)? 'main' : 'login',
      routes: {
        'login': (context) => LoginPage(),
        'main': (context) => MainPage()
      }
    );
  }
}
