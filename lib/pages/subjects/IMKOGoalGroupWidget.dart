import 'package:enis/api/imko_subject.dart';
import 'package:enis/pages/subjects/IMKOGoalWidget.dart';
import 'package:flutter/material.dart';

class IMKOGoalGroupWidget extends StatelessWidget {
  final IMKOGoalGroup data;

  const IMKOGoalGroupWidget({Key key, this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    children.add(Text(
      data.title,
      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
    ));
    for(IMKOGoal goal in data.goals) {
      children.add(IMKOGoalWidget(data: goal));
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}
