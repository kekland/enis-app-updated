import 'package:enis/api/imko_subject.dart';
import 'package:enis/pages/calculator/NumberInputWidget.dart';
import 'package:flutter/material.dart';

class IMKOTermPage extends StatefulWidget {
  @override
  _IMKOTermPageState createState() => _IMKOTermPageState();
}

class _IMKOTermPageState extends State<IMKOTermPage> {
  Assessment formative = new Assessment(current: 0, maximum: 10);
  Assessment summative = new Assessment(current: 0, maximum: 40);
  String grade = '-';

  initState() {
    super.initState();
    calculate();
  }

  calculate() {
    String returningGrade = '-';
    if (formative.current < 0 ||
        summative.current < 0 ||
        formative.maximum < 0 ||
        summative.maximum < 0) {
      returningGrade = '-';
    } else if (formative.current > formative.maximum ||
        summative.current > summative.maximum) {
      returningGrade = '-';
    } else {
      double points =
          formative.getPercentage() * 18.0 + summative.getPercentage() * 42.0;
      points = points.roundToDouble() / 60.0;
      if (points >= 0.9) {
        returningGrade = 'A+';
      } else if (points >= 0.8) {
        returningGrade = 'A';
      } else if (points >= 0.7) {
        returningGrade = 'B';
      } else if (points >= 0.6) {
        returningGrade = 'C';
      } else if (points >= 0.5) {
        returningGrade = 'D';
      } else if (points >= 0.4) {
        returningGrade = 'E';
      } else {
        returningGrade = 'U';
      }
    }

    setState(() {
      grade = returningGrade;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                          formative.current = value;
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
                        formative.maximum = value;
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
                          summative.current = value;
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
                        summative.maximum = value;
                        calculate();
                      }(),
                )),
              ],
            ),
            SizedBox(height: 16.0),
            Align(
              alignment: AlignmentDirectional.center,
              child: Text(
                grade,
                style: TextStyle(
                  fontSize: 48.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
