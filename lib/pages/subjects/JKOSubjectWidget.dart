import 'package:enis/api/imko_subject.dart';
import 'package:enis/api/jko_subject.dart';
import 'package:enis/pages/subjects/AssessmentWidget.dart';
import 'package:enis/pages/subjects/EvaluationsPage.dart';
import 'package:enis/pages/subjects/GoalsPage.dart';
import 'package:enis/pages/subjects/GradeWidget.dart';
import 'package:flutter/material.dart';

class JKOSubjectWidget extends StatelessWidget {
  final JKOSubject data;

  const JKOSubjectWidget({Key key, this.data}) : super(key: key);

  openEvaluationsPage(BuildContext context) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (BuildContext context) {
          return EvaluationsPage(data: data);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          onTap: (data.evaluations.length > 0)? () => openEvaluationsPage(context) : null,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AssessmentPercentWidget(
                      value: data.score,
                    ),
                    GradeWidget(
                      grade: data.grade,
                      predicted: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
