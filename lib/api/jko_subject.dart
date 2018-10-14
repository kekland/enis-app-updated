import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:enis/api/imko_subject.dart';
import 'package:enis/api/subject.dart';
import 'package:enis/api/utils.dart';
import 'package:enis/classes/globals.dart';

class JKOAssessment {
  Assessment data;
  String title;

  JKOAssessment({this.data, this.title});
  factory JKOAssessment.fromAPIJson(Map json) {
    return new JKOAssessment(
      title: json['Name'],
      data: Assessment(
          current: (json['Score'] as double == -1) ? 0 : (json['Score'] as double).toInt(),
          maximum: json['MaxScore']),
    );
  }
}

class JKOSubject extends Subject {
  String name;
  String grade;
  String id;
  String journalID;
  List<String> evaluations;
  double score;

  JKOSubject(
      {this.name,
      this.grade,
      this.id,
      this.journalID,
      this.score,
      this.evaluations});
  factory JKOSubject.fromAPIJson(Map json) {
    JKOSubject subject = new JKOSubject(
      name: json['Name'],
      grade: json['Mark'].toString() == '0' ? 'NA' : json['Mark'].toString(),
      id: json['Id'],
      journalID: json['JournalId'],
      score: json['Score'],
      evaluations: [],
    );

    for (Map evaluation in json['Evalutions']) {
      subject.evaluations.add(evaluation['Id']);
    }

    return subject;
  }

  getAssessments(Function(int, List<JKOAssessment>) callback) async {
    Globals.user.updateCookies();
    Dio dio = await Utils.createDioInstance(Globals.user.schoolURL);
    int index = 0;
    for (String evaluationID in evaluations) {
      List<JKOAssessment> assessments = [];
      Response evalResponse =
          await dio.post('/Jce/Diary/GetResultByEvalution', data: {
        "journalId": journalID,
        "evalId": evaluationID,
        "page": 1,
        "start": 0,
        "limit": 25
      });

      evalResponse.data = json.decode(evalResponse.data);
      if (!evalResponse.data['success']) {
        throw Exception('Failure while fetching evaluation data');
      }

      for (Map assessment in evalResponse.data['data']) {
        JKOAssessment jkoAssessment = JKOAssessment.fromAPIJson(assessment);
        assessments.add(jkoAssessment);
      }

      callback(index, assessments);
      index++;
    }
  }
}
