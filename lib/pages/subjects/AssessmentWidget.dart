import 'package:enis/api/imko_subject.dart';
import 'package:flutter/material.dart';

class AssessmentWidget extends StatelessWidget {
  final Assessment assessment;
  final String description;

  const AssessmentWidget({Key key, this.assessment, this.description})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          assessment.current.toString(),
          style: TextStyle(
            fontSize: 36.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              description,
              style: TextStyle(fontSize: 12.0, color: Colors.white70),
            ),
            Text(
              assessment.maximum.toString(),
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}

class AssessmentPercentWidget extends StatelessWidget {
  final double value;
  final String description;

  const AssessmentPercentWidget({Key key, this.value, this.description})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value.floor().toString(),
          style: TextStyle(
            fontSize: 36.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '.${(value % 1).toStringAsFixed(2).split(".")[1]}',
              style: TextStyle(fontSize: 12.0, color: Colors.white70),
            ),
            Text(
              '%',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
