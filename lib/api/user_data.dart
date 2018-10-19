import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:enis/api/imko_subject.dart';
import 'package:enis/api/jko_subject.dart';
import 'package:enis/api/subject.dart';
import 'package:enis/api/utils.dart';
import 'package:enis/classes/diary.dart';
import 'package:enis/classes/globals.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class UserBirthday {
  String name;
  String role;
  DateTime birthday;
  UserBirthday({this.name, this.birthday, this.role});
  factory UserBirthday.fromAPIJSON(Map json, String role) {
    return UserBirthday(
      name: json['SecondName'] + ' ' + json['FirstName'],
      birthday: DateTime.parse(json['Birthday']),
      role: role,
    );
  }
  String getDate() {
    String day = birthday.day.toString().padLeft(2, '0');
    String month = birthday.month.toString().padLeft(2, '0');
    String year = birthday.year.toString();
    return day + '.' + month + '.' + year;
  }

  bool isToday() {
    DateTime now = DateTime.now();
    if (birthday.day == now.day && birthday.month == now.month) {
      return true;
    }
    return false;
  }
}

class Session {
  String base;
  Dio http;

  configureDioFirstTime() {
    Dio dio = new Dio();
    dio.cookieJar = new CookieJar();
    String authority = base.substring(base.indexOf('/', 6) + 1);
    authority = authority.substring(0, authority.indexOf('/'));
    dio.cookieJar.saveFromResponse(Uri.http(authority, ''), [
      Cookie('Locale', 'en-US'),
      Cookie('Culture', 'en-US'),
    ]);
    http = dio;
  }

  Session(base) {
    this.base = base;
    configureDioFirstTime();
  }

  Future<Map> post(String url, Map data,
      [Map<String, dynamic> headers, bool appendBase = true]) async {
    Response response;
    response = await http.post((appendBase) ? base + url : url,
        data: data, options: Options(headers: headers));
    if (response.data.runtimeType == String) {
      try {
        return json.decode(response.data);
      } catch (e) {
        return {"data": response.data};
      }
    }
    return response.data;
  }
}

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
  Session session;

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
    data.session = new Session(data.schoolURL);
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
    Map<dynamic, dynamic> loginResponse = await session.post('/Account/Login',
        {'txtUsername': pin, 'txtPassword': password, 'captchaInput': captcha});

    print('$pin, $password, $captcha');
    print(json.encode(loginResponse));
    if (!loginResponse['success']) {
      if (loginResponse['captchaImg'] != null &&
          loginResponse['captchaImg'] != '') {
        throw new CaptchaException(captcha: loginResponse['captchaImg']);
      } else {
        throw new Exception(loginResponse['ErrorMessage']);
      }
    }

    print('/Account/Login success');
    Map<dynamic, dynamic> rolesResponse =
        await session.post('/Account/GetRoles', {});

    if (!rolesResponse['success']) {
      throw new Exception('Failure while fetching roles');
    }
    print('/Account/GetRoles success');
    List roles = rolesResponse['listRole'];
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

    Map<dynamic, dynamic> confirmationResponse = await session
        .post('/Account/LoginWithRole', {"role": role, "password": password});

    if (!confirmationResponse['success']) {
      throw new Exception('Error while confirming login');
    }
    print('/Account/LoginWithRole success');

    Map<dynamic, dynamic> classesResponse =
        await session.post('/ImkoDiary/Klasses', {});
    if (!classesResponse['success']) {
      throw new Exception('Error while fetching classes');
    }
    print('/ImkoDiary/Klasses success');

    for (Map classData in (classesResponse['data'] as List)) {
      Map<dynamic, dynamic> studentsResponse = await session
          .post('/ImkoDiary/Students', {'klassId': classData['Id']});

      if (!studentsResponse['success']) {
        throw new Exception('Error while fetching students');
      }
      for (Map studentData in (studentsResponse['data'] as List)) {
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
    Map<dynamic, dynamic> loginResponse = await session
        .post('/Account/Login', {'txtUsername': pin, 'txtPassword': password});

    if (!loginResponse['success']) {
      if (loginResponse['captchaImg'] != null &&
          loginResponse['captchaImg'] != '') {
        throw new CaptchaException(captcha: loginResponse['captchaImg']);
      } else {
        throw new Exception(loginResponse['ErrorMessage']);
      }
    }

    print('/Account/Login success');

    Map<dynamic, dynamic> confirmationResponse = await session
        .post('/Account/LoginWithRole', {"role": role, "password": password});

    if (!confirmationResponse['success']) {
      throw new Exception('Error while confirming login');
    }
    print('/Account/LoginWithRole success');
  }

  Future<List<Term>> getGradesForYear(Function(int, Term) callback) async {
    await updateCookies();
    Map<dynamic, dynamic> termsResponse =
        await session.post('/JCEDiary/Periods', {});

    if (!termsResponse['success']) {
      throw Exception('Error occurred while fetching term IDs');
    }
    List<Term> data = [];
    int index = 0;
    for (Map term in termsResponse['data']) {
      List<Subject> subjects = await getGradesForTerm(termID: term['Id']);
      Term termData = new Term(
          subjects: subjects, id: term['Id'], fail: false, loading: false);
      callback(index, termData);
      data.add(termData);
      index++;
    }
    return data;
  }

  Future<List<Subject>> getGradesForTerm({int termID}) async {
    if (diary == Diary.imko) {
      Map<dynamic, dynamic> subjectsResponse =
          await session.post('/ImkoDiary/Subjects', {
        'periodId': termID,
        'studentId': identifier.studentID,
      });
      if (!subjectsResponse['success']) {
        throw Exception('Error occurred while fetching subjects on term ' +
            termID.toString());
      }

      List<IMKOSubject> subjects = [];
      for (Map map in subjectsResponse['data']) {
        subjects.add(IMKOSubject.fromAPIJson(map, termID));
      }
      return subjects;
    } else {
      Map<dynamic, dynamic> diaryURLResponse =
          await session.post('/JCEDiary/GetDiaryUrl', {
        'klassId': identifier.classID,
        'periodId': termID,
        'studentId': identifier.studentID
      });

      if (!diaryURLResponse['success']) {
        throw Exception('Error occurred while fetching diary URL');
      }

      String diaryURL = diaryURLResponse['data'];
      await session.post(diaryURL, {}, null, false);

      Map<dynamic, dynamic> subjectsResponse = await session.post(
          '/jce/Diary/GetSubjects',
          {"page": 1, "start": 0, "limit": 25},
          {"referer": diaryURL});

      if (!subjectsResponse['success']) {
        throw 'Error occurred while fetching subjects';
      }

      List<JKOSubject> subjects = [];
      for (Map map in subjectsResponse['data']) {
        subjects.add(JKOSubject.fromAPIJson(map));
      }
      return subjects;
    }
  }

  Future<List<UserBirthday>> getBirthdays() async {
    await updateCookies();
    Map data = await session.post('/Management/GetPersons', {
      'sort': 'SecondName',
      'dir': 'ASC',
      'start': 0,
      'limit': 10000,
      'role': 'Student'
    });

    if (data['total'] == null) {
      throw 'Error while fetching birthdays';
    }
    List<UserBirthday> birthdays = [];

    for (Map user in data['data']) {
      birthdays.add(UserBirthday.fromAPIJSON(user, 'Student'));
    }

    data = await session.post('/Management/GetPersons', {
      'sort': 'SecondName',
      'dir': 'ASC',
      'start': 0,
      'limit': 10000,
      'role': 'Teacher'
    });

    if (data['total'] == null) {
      throw 'Error while fetching birthdays';
    }

    for (Map user in data['data']) {
      birthdays.add(UserBirthday.fromAPIJSON(user, 'Teacher'));
    }
    data = await session.post('/Management/GetPersons', {
      'sort': 'SecondName',
      'dir': 'ASC',
      'start': 0,
      'limit': 10000,
      'role': 'SchoolDirector'
    });

    if (data['total'] == null) {
      throw 'Error while fetching birthdays';
    }

    for (Map user in data['data']) {
      birthdays.add(UserBirthday.fromAPIJSON(user, 'Principal'));
    }
    return birthdays;
  }

  saveToPrefs() async {
    Globals.prefs.setString('user_data', json.encode(this.toJSON()));
    print(json.encode(this.toJSON()));
  }

  logout() async {
    Globals.prefs.setString('user_data', null);
  }
}
