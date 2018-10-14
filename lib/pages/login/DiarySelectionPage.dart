import 'package:enis/classes/diary.dart';
import 'package:enis/classes/school.dart';
import 'package:flutter/material.dart';

class DiarySelectionPage extends StatefulWidget {
  final Function(Diary) onSelected;
  final Function onDismissed;
  final Diary diary;

  const DiarySelectionPage(
      {Key key, this.onSelected, this.onDismissed, this.diary})
      : super(key: key);
  @override
  _DiarySelectionPageState createState() => _DiarySelectionPageState();
}

class _DiarySelectionPageState extends State<DiarySelectionPage> {
  Diary selected = Diary.jko;
  List diaries = [
    ['IMKO', 'Формативки'],
    ['JKO', 'СОр и СОч']
  ];

  @override
  void initState() {
    selected = widget.diary;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Diary',
                style: TextStyle(fontSize: 48.0, fontWeight: FontWeight.w700)),
            Text('With which system are you studying?',
                style: TextStyle(color: Colors.white70)),
            SizedBox(height: 24.0),
            Row(
              children: diaries.map((value) {
                Diary diary = (value[0] == 'IMKO') ? Diary.imko : Diary.jko;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selected = diary;
                    });
                  },
                  child: Column(children: [
                    AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 100),
                      style: TextStyle(
                          color:
                              (selected == diary) ? Colors.blue : Colors.white),
                      child: Text(
                        value[0],
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.w700),
                      ),
                    ),
                    AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 100),
                      style: TextStyle(
                          color: (selected == diary)
                              ? Colors.blue.withOpacity(0.7)
                              : Colors.white70),
                      child: Text(
                        value[1],
                        style: TextStyle(),
                      ),
                    ),
                  ]),
                );
              }).toList(),
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
            SizedBox(height: 24.0),
            Row(
              children: [
                FlatButton.icon(
                  textColor: Colors.blue,
                  label: Text('Go back'),
                  icon: Icon(Icons.chevron_left),
                  onPressed: widget.onDismissed,
                ),
                FlatButton.icon(
                    textColor: Colors.blue,
                    label: Text('Select'),
                    icon: Icon(Icons.chevron_right),
                    onPressed: (selected == null)
                        ? selected
                        : () => widget.onSelected(selected)),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          ],
        ),
      ),
    );
  }
}
