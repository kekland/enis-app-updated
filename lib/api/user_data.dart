import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:enis/api/imko_subject.dart';
import 'package:enis/api/jko_subject.dart';
import 'package:enis/api/subject.dart';
import 'package:enis/api/utils.dart';
import 'package:enis/classes/diary.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CaptchaException {
  String captcha;
  CaptchaException({this.captcha});
}

class IDData {
  String studentID;
  String studentName;
  String classID;
  String className;

  IDData({this.studentID, this.classID, this.studentName, this.className});

  Map toJSON() {
    return <String, String>{
      'studentID': studentID,
      'classID': classID,
      'className': className,
      'studentName': studentName
    };
  }

  factory IDData.fromJSON(Map json) {
    return new IDData(
        studentID: json['studentID'],
        classID: json['classID'],
        studentName: json['studentName'],
        className: json['className']);
  }
}

class UserData {
  String pin;
  String password;
  String schoolURL;
  String role;
  List<IDData> identifiers;
  IDData identifier;
  Diary diary;

  Map toJSON() {
    return <String, dynamic>{
      'pin': pin,
      'password': password,
      'schoolURL': schoolURL,
      'role': role,
      'diary': diary.toString(),
      'identifiers': identifiers.map((id) => id.toJSON()).toList(),
      'identifier': identifier.toJSON(),
    };
  }

  UserData();

  factory UserData.newUser(
      {String pin,
      String password,
      String url,
      Diary diary,
      String role,
      List<IDData> identifiers}) {
    UserData data = new UserData();
    data.pin = pin;
    data.password = password;
    data.schoolURL = url;
    data.diary = diary;
    data.role = (role != null) ? role : '';
    data.identifiers = (identifiers != null) ? identifiers : [];
    data.identifier = (identifiers != null) ? identifiers[0] : null;
    return data;
  }

  factory UserData.fromJSON(Map json) {
    UserData data = UserData.newUser(
        pin: json['pin'],
        password: json['password'],
        url: json['schoolURL'],
        role: json['role'],
        diary: (json['diary'] == 'Diary.imko') ? Diary.imko : Diary.jko);
    for (Map identifier in json['identifiers']) {
      data.identifiers.add(new IDData.fromJSON(identifier));
    }

    if (json['identifier'] != null) {
      data.identifier = new IDData.fromJSON(json['identifier']);
    } else {
      data.identifier = data.identifiers[0];
    }
    return data;
  }

  login({bool saveToPrefs, String captcha}) async {
    Dio dio = await Utils.createDioInstance(schoolURL);

    Response loginResponse = await dio.post('/Account/Login', data: {
      'txtUsername': pin,
      'txtPassword': password,
      'captchaInput': captcha
    });

    if (!loginResponse.data['success']) {
      if (loginResponse.data['captchaImg'] != null &&
          loginResponse.data['captchaImg'] != '') {
        throw new CaptchaException(captcha: loginResponse.data['captchaImg']);
      } else {
        throw new Exception(loginResponse.data['ErrorMessage']);
      }
    }

    print('/Account/Login success');
    Response rolesResponse = await dio.post('/Account/GetRoles', data: {});

    if (!rolesResponse.data['success']) {
      throw new Exception('Failure while fetching roles');
    }
    print('/Account/GetRoles success');
    List roles = rolesResponse.data['listRole'];
    String selectedRoleValue;

    for (Map role in roles) {
      if (role['value'].toString() == 'Student') {
        selectedRoleValue = 'Student';
      } else if (role['value'].toString() == 'Parent') {
        selectedRoleValue = 'Parent';
      }
    }

    if (selectedRoleValue == null) {
      throw new Exception('Your role is unsupported');
    }
    role = selectedRoleValue;

    Response confirmationResponse = await dio.post('/Account/LoginWithRole',
        data: {"role": role, "password": password});

    if (!confirmationResponse.data['success']) {
      throw new Exception('Error while confirming login');
    }
    print('/Account/LoginWithRole success');

    Response classesResponse = await dio.post('/ImkoDiary/Klasses', data: {});
    if (!classesResponse.data['success']) {
      throw new Exception('Error while fetching classes');
    }
    print('/ImkoDiary/Klasses success');

    for (Map classData in (classesResponse.data['data'] as List)) {
      Response studentsResponse = await dio
          .post('/ImkoDiary/Students', data: {'klassId': classData['Id']});

      if (!studentsResponse.data['success']) {
        throw new Exception('Error while fetching students');
      }
      for (Map studentData in (studentsResponse.data['data'] as List)) {
        identifiers.add(new IDData(
          studentID: studentData['Id'].toString(),
          studentName: studentData['Name'],
          classID: classData['Id'].toString(),
          className: classData['Name'],
        ));
      }
    }

    identifier = identifiers[0];

    if (saveToPrefs) {
      await this.saveToPrefs();
    }
  }

  updateCookies() async {
    Dio dio = await Utils.createDioInstance(schoolURL);

    Response loginResponse = await dio.post('/Account/Login',
        data: {'txtUsername': pin, 'txtPassword': password});

    if (!loginResponse.data['success']) {
      if (loginResponse.data['captchaImg'] != null &&
          loginResponse.data['captchaImg'] != '') {
        throw new CaptchaException(captcha: loginResponse.data['captchaImg']);
      } else {
        throw new Exception(loginResponse.data['ErrorMessage']);
      }
    }

    print('/Account/Login success');

    Response confirmationResponse = await dio.post('/Account/LoginWithRole',
        data: {"role": role, "password": password});

    if (!confirmationResponse.data['success']) {
      throw new Exception('Error while confirming login');
    }
    print('/Account/LoginWithRole success');
  }

  Future<List<Term>> getGradesForYear(Function(int, Term) callback) async {
    await updateCookies();
    Dio dio = await Utils.createDioInstance(schoolURL);
    Response termsResponse = await dio.post('/JCEDiary/Periods', data: {});

    if (!termsResponse.data['success']) {
      throw Exception('Error occurred while fetching term IDs');
    }
    List<Term> data = [];
    int index = 0;
    for (Map term in termsResponse.data['data']) {
      List<Subject> subjects = await getGradesForTerm(termID: term['Id']);
      Term termData = new Term(subjects: subjects, id: term['Id'], fail: false, loading: false);
      callback(index, termData);
      data.add(termData);
      index++;
    }
    return data;
  }

  Future<List<Subject>> getGradesForTerm({int termID}) async {
    if (diary == Diary.imko) {
      Dio dio = await Utils.createDioInstance(schoolURL);
      Response subjectsResponse = await dio.post('/ImkoDiary/Subjects', data: {
        'periodId': termID,
        'studentId': identifier.studentID,
      });
      if (!subjectsResponse.data['success']) {
        throw Exception('Error occurred while fetching subjects on term ' +
            termID.toString());
      }

      List<IMKOSubject> subjects = [];
      for (Map map in subjectsResponse.data['data']) {
        subjects.add(IMKOSubject.fromAPIJson(map, termID));
      }
      return subjects;
    } else {
      Dio dio = await Utils.createDioInstance(schoolURL);
      Response diaryURLResponse = await dio.post('/JCEDiary/GetDiaryUrl', data: {
        'klassId': identifier.classID,
        'periodId': termID,
        'studentId': identifier.studentID
      });

      if(!diaryURLResponse.data['success']) {
        throw Exception('Error occurred while fetching diary URL');
      }

      String diaryURL = diaryURLResponse.data['data'];
      await dio.post(diaryURL);

      Response subjectsResponse = await dio.post('/jce/Diary/GetSubjects', data: {
        "page": 1,
        "start": 0,
        "limit": 25
      }, options: Options(headers: {
        'Referer': diaryURL
      }));

      subjectsResponse.data = json.decode(subjectsResponse.data);

      if(!subjectsResponse.data['success']) {
        throw 'Error occurred while fetching subjects';
      }
      
      List<JKOSubject> subjects = [];
      for (Map map in subjectsResponse.data['data']) {
        subjects.add(JKOSubject.fromAPIJson(map));
      }
      return subjects;
    }
  }

  saveToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_data', json.encode(this.toJSON()));
    print(json.encode(this.toJSON()));
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_data', null);
  }
}
