import 'package:enis/api/imko_subject.dart';
import 'package:enis/api/jko_subject.dart';
import 'package:enis/pages/subjects/IMKOSubjectWidget.dart';
import 'package:enis/pages/subjects/JKOSubjectWidget.dart';
import 'package:flutter/material.dart';

class TermPage<T> extends StatelessWidget {
  final Term term;
  final Function refresh;
  TermPage(this.term, this.refresh);
  @override
  Widget build(BuildContext context) {
    if (term.fail) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error,
              color: Colors.white54,
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              'Whoops, something went wrong',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Colors.white54,
              ),
            ),
            FlatButton.icon(
              label: Text('Refresh'),
              icon: Icon(Icons.refresh),
              textColor: Colors.white54,
              onPressed: refresh,
            ),
          ],
        ),
      );
    }
    if (term.loading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
        ),
      );
    }
    if (term.subjects.length == 0) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off,
              color: Colors.white54,
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              'No subjects',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: term.subjects.length,
      itemBuilder: (context, index) {
        if (term.subjects[index].runtimeType == IMKOSubject) {
          return IMKOSubjectWidget(data: term.subjects[index] as IMKOSubject);
        } else {
          return JKOSubjectWidget(data: term.subjects[index] as JKOSubject);
        }
      },
    );
  }
}
