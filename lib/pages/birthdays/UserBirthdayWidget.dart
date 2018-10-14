import 'package:enis/api/user_data.dart';
import 'package:flutter/material.dart';

class UserBirthdayWidget extends StatelessWidget {
  final UserBirthday data;

  const UserBirthdayWidget({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
      child: Container(
        padding: const EdgeInsets.only(
            top: 16.0, bottom: 16.0, left: 24.0, right: 24.0),
        decoration: BoxDecoration(
          color: (data.isToday()) ? Colors.green : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(Icons.cake),
              ),
              visible: data.isToday(),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  data.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  data.role,
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            )),
            Text(data.getDate()),
          ],
        ),
      ),
    );
  }
}
