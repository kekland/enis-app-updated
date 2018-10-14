import 'package:enis/classes/school.dart';
import 'package:flutter/material.dart';

class SchoolSelectionPage extends StatefulWidget {
  final Function(String) onSelected;
  final String school;
  SchoolSelectionPage({this.onSelected, this.school});
  @override
  _SchoolSelectionPageState createState() => _SchoolSelectionPageState();
}

class _SchoolSelectionPageState extends State<SchoolSelectionPage> {
  String selected;

  @override
  void initState() {
    selected = widget.school;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    School.schools.forEach((name, url) {
      children.add(
        GestureDetector(
          onTap: () {
            setState(() {
              selected = name;
            });
          },
          child: new Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
            child: Column(
              children: [
                AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: 100),
                  child: Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                    ),
                  ),
                  style: TextStyle(
                    color: (selected == name) ? Colors.blue : Colors.white,
                  ),
                ),
                AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: 100),
                  child: Text(url.split('/').last),
                  style: TextStyle(
                    color: (selected == name)
                        ? Colors.blue.withOpacity(0.7)
                        : Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('School',
                style: TextStyle(fontSize: 48.0, fontWeight: FontWeight.w700)),
            Text('Where are you from?',
                style: TextStyle(color: Colors.white70)),
            SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 2.0,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: children,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            FlatButton.icon(
                textColor: Colors.blue,
                label: Text('Select'),
                icon: Icon(Icons.chevron_right),
                onPressed: (selected == null)
                    ? null
                    : () => widget.onSelected(selected)),
          ],
        ),
      ),
    );
  }
}
