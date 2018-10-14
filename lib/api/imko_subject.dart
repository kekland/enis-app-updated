import 'package:dio/dio.dart';
import 'package:enis/api/subject.dart';
import 'dart:async';

import 'package:enis/api/utils.dart';
import 'package:enis/classes/globals.dart';

class Term {
  int id;
  List<Subject> subjects;
  bool fail = false;
  bool loading = true;

  Term({this.subjects, this.id, this.fail, this.loading});
}

class IMKOSubject extends Subject {
  String name;
  Assessment formative;
  Assessment summative;
  int id;
  int termID;
  String grade;

  IMKOSubject(
      {this.name,
      this.formative,
      this.summative,
      this.id,
      this.grade,
      this.termID});
  factory IMKOSubject.fromAPIJson(Map json, int termID) {
    return IMKOSubject(
        name: json['Name'],
        formative: Assessment(
          current: json['ApproveCnt'],
          maximum: json['Cnt'],
        ),
        summative: Assessment(
          current: (json['ApproveISA'] as double).toInt(),
          maximum: (json['MaxISA'] as double).toInt(),
        ),
        id: json['Id'],
        grade: json['Period'],
        termID: termID);
  }
  String getGrade() {
    double points =
        (formative.getPercentage() * 18.0) + (summative.getPercentage() * 42.0);
    points = points.roundToDouble() / 60.0;
    if (points >= 0.8) {
      return '5';
    } else if (points >= 0.6) {
      return '4';
    } else if (points >= 0.4) {
      return '3';
    } else {
      return '2';
    }
  }

  Future<List<IMKOGoalGroup>> getGoals() async {
    Globals.user.updateCookies();
    Dio dio = await Utils.createDioInstance(Globals.user.schoolURL);

    Response goalsResponse = await dio.post('/ImkoDiary/Goals', data: {
      "periodId": termID,
      "subjectId": id,
      "studentId": Globals.user.identifier.studentID
    });

    if (!goalsResponse.data['success']) {
      throw Exception(
          'Error occurred while fetching goals for subject ID ${id}');
    }

    List goals = goalsResponse.data['data']['goals'];

    int lastGoalGroupIndex = -1;
    List<IMKOGoalGroup> goalsResult = [];
    for (Map goal in goals) {
      if (goal['GroupIndex'] != lastGoalGroupIndex) {
        goalsResult.add(new IMKOGoalGroup(title: goal['GroupName'], goals: []));
        lastGoalGroupIndex = goal['GroupIndex'];
      }
      goalsResult.last.goals.add(IMKOGoal.fromAPIJSON(goal));
    }
    return goalsResult;
  }
}

class IMKOGoalGroup {
  String title;
  List<IMKOGoal> goals;

  IMKOGoalGroup({this.title, this.goals});
}

class IMKOGoal {
  String description;
  String name;
  GoalStatus status;
  String comment;

  IMKOGoal({this.name, this.description, this.comment, this.status});
  factory IMKOGoal.fromAPIJSON(Map json) {
    IMKOGoal goal = new IMKOGoal(
      name: json['Name'],
      description: json['Description'],
      comment: 'Нет комментария',
      status: GoalStatus.NotAssessed,
    );
    if (json['Value'] == 'Достиг' ||
        json['Value'] == 'Achieved' ||
        json['Value'] == 'Жетті') {
      goal.status = GoalStatus.Achieved;
    } else if (json['Value'] == 'Стремится' ||
        json['Value'] == 'Working Towards' ||
        json['Value'] == 'Тырысады') {
      goal.status = GoalStatus.WorkingTowards;
      goal.comment = json['Comment'];
      if (goal.comment.length == 0) {
        goal.comment = 'Нет комментария';
      }
    } else {
      goal.status = GoalStatus.NotAssessed;
    }

    return goal;
  }

  String getStatusString() {
    if(status == GoalStatus.Achieved) {
      return 'Achieved';
    }
    else if(status == GoalStatus.NotAssessed) {
      return 'N/A';
    }
    return 'Working Towards';
  }
}

enum GoalStatus {
  Achieved,
  WorkingTowards,
  NotAssessed
}

class Assessment {
  int current;
  int maximum;

  double getPercentage() {
    return current.toDouble() / maximum.toDouble();
  }

  Assessment({this.current, this.maximum});
}
