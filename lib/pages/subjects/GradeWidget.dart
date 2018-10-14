import 'package:flutter/material.dart';

class GradeWidget extends StatelessWidget {
  final String grade;
  final bool predicted;

  const GradeWidget({Key key, this.grade, this.predicted}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          grade,
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
              (predicted) ? 'pred.' : ' ',
              style: TextStyle(fontSize: 12.0, color: Colors.white70),
            ),
            Text(
              'Grade',
              style: TextStyle(fontSize: 12.0, color: Colors.white70),
            ),
          ],
        ),
      ],
    );
  }
}
