import 'package:enis/api/jko_subject.dart';
import 'package:enis/pages/subjects/AssessmentWidget.dart';
import 'package:flutter/material.dart';

class JKOEvaluationWidget extends StatelessWidget {
  final JKOAssessment data;

  JKOEvaluationWidget(this.data);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(child: Text(data.title)),
            AssessmentWidget(
              assessment: data.data,
              description: 'Points',
            )
          ],
        ),
      ),
    );
  }
}
