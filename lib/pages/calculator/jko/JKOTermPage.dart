import 'package:enis/api/imko_subject.dart';
import 'package:enis/api/jko_subject.dart';
import 'package:enis/pages/calculator/NumberInputWidget.dart';
import 'package:flutter/material.dart';

class JKOTermPage extends StatefulWidget {
  @override
  _JKOTermPageState createState() => _JKOTermPageState();
}

class _JKOTermPageState extends State<JKOTermPage> {
  List<JKOAssessment> evaluations = [];

  addEvaluation() {
    setState(() {
      evaluations.add(
        JKOAssessment(
          data: Assessment(current: 0, maximum: 10),
          title: 'Assessment',
        ),
      );
    });
  }

  removeEvaluation(JKOAssessment assessment) {
    setState(() {
      evaluations.remove(assessment);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<List<Widget>> children = evaluations.map((JKOAssessment assessment) {
      return [
        Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('СОр',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        )),
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () =>
                          removeEvaluation(assessment),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: NumberInputWidget(
                        defaultValue: '0',
                        hint: 'Current',
                        onValueUpdate: (index) {},
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: NumberInputWidget(
                        defaultValue: '20',
                        hint: 'Maximum',
                        onValueUpdate: (index) {},
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Text(
                  'СОч',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: NumberInputWidget(
                        defaultValue: '0',
                        hint: 'Current',
                        onValueUpdate: (index) {},
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: NumberInputWidget(
                        defaultValue: '20',
                        hint: 'Maximum',
                        onValueUpdate: (index) {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ];
    }).toList();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children.fold(
            [
              FlatButton.icon(
                icon: Icon(Icons.add),
                label: Text('Add evaluation'),
                onPressed: () {
                  addEvaluation();
                },
              ),
            ],
            (prev, item) {
              prev.addAll(item);
              return prev;
            },
          ),
        ),
      ),
    );
  }
}
