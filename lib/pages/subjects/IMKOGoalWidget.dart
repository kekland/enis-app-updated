import 'package:enis/api/imko_subject.dart';
import 'package:flutter/material.dart';

class IMKOGoalWidget extends StatelessWidget {
  final IMKOGoal data;

  const IMKOGoalWidget({Key key, this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Widget> columnChildren = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(data.name),
          Chip(
            label: Text(data.getStatusString()),
            backgroundColor: (data.status == GoalStatus.Achieved)
                ? Colors.green
                : (data.status == GoalStatus.WorkingTowards)
                    ? Colors.amber
                    : Colors.transparent,
          ),
        ],
      ),
      Text(data.description),
    ];

    if (data.status == GoalStatus.WorkingTowards) {
      columnChildren.add(SizedBox(height: 8.0));
      columnChildren.add(
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(data.comment),
        ),
      );
    }
    return Padding(
      padding:
          const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: columnChildren,
      ),
    );
  }
}
