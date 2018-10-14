import 'package:date_format/date_format.dart';
import 'package:enis/api/user_birthday_data.dart';

class BirthdayUtils {

  static bool isBirthdayToday(UserBirthdayData data) {
    return (data.birthday.day == DateTime.now().day) && (data.birthday.month == DateTime.now().month);
  }

  static String birthdayToString(UserBirthdayData data) {
    return formatDate(data.birthday, [dd, '.', mm, '.', yyyy]);
  }
}