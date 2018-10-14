import 'package:enis/api/imko_subject.dart';
import 'package:enis/pages/subjects/AssessmentWidget.dart';
import 'package:enis/pages/subjects/GoalsPage.dart';
import 'package:enis/pages/subjects/GradeWidget.dart';
import 'package:flutter/material.dart';

class IMKOSubjectWidget extends StatelessWidget {
  final IMKOSubject data;

  const IMKOSubjectWidget({Key key, this.data}) : super(key: key);

  openGoalsPage(BuildContext context) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (BuildContext context) {
          return GoalsPage(data: data);
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
          onTap: () => openGoalsPage(context),
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
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: AssessmentWidget(
                            assessment: data.formative, description: 'FA'),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.center,
                        child: AssessmentWidget(
                            assessment: data.summative, description: 'SA'),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: GradeWidget(
                          grade: (data.grade != '')
                              ? data.grade
                              : (data.summative.current != 0)
                                  ? data.getGrade()
                                  : 'NA',
                          predicted:
                              (data.grade == '' && data.summative.current != 0),
                        ),
                      ),
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
