import 'package:enis/api/imko_subject.dart';
import 'package:enis/pages/calculator/NumberInputWidget.dart';
import 'package:flutter/material.dart';

class IMKOYearPage extends StatefulWidget {
  @override
  _IMKOYearPageState createState() => _IMKOYearPageState();
}

class _IMKOYearPageState extends State<IMKOYearPage> {
  List<Assessment> formative = [
    new Assessment(current: 0, maximum: 10),
    new Assessment(current: 0, maximum: 10),
    new Assessment(current: 0, maximum: 10),
    new Assessment(current: 0, maximum: 10),
  ];
  List<Assessment> summative = [
    new Assessment(current: 0, maximum: 40),
    new Assessment(current: 0, maximum: 40),
    new Assessment(current: 0, maximum: 40),
    new Assessment(current: 0, maximum: 40),
  ];

  List<String> terms = [
    'Term 1',
    'Term 2',
    'Term 3',
    'Term 4',
  ];

  calculate() {

  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    int index = 0;
    for (String term in terms) {
      children.add(Text(
        term,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 36.0),
      ));
      children.addAll([
            Text(
              'Formative',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24.0),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: NumberInputWidget(
                    hint: 'Current',
                    defaultValue: '0',
                    onValueUpdate: (value) => () {
                          formative[index].current = value;
                          calculate();
                        }(),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                    child: NumberInputWidget(
                  hint: 'Maximum',
                  defaultValue: '10',
                  onValueUpdate: (value) => () {
                        formative[index].maximum = value;
                        calculate();
                      }(),
                )),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              'Summative',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24.0),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: NumberInputWidget(
                    hint: 'Current',
                    defaultValue: '0',
                    onValueUpdate: (value) => () {
                          summative[index].current = value;
                          calculate();
                        }(),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                    child: NumberInputWidget(
                  hint: 'Maximum',
                  defaultValue: '40',
                  onValueUpdate: (value) => () {
                        summative[index].maximum = value;
                        calculate();
                      }(),
                )),
              ],
            ),
          ]);
      index++;
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(),
      ),
    );
  }
}
