import 'package:enis/api/imko_subject.dart';
import 'package:enis/pages/subjects/IMKOGoalGroupWidget.dart';
import 'package:enis/pages/subjects/IMKOGoalWidget.dart';
import 'package:flutter/material.dart';

class GoalsPage extends StatefulWidget {
  final IMKOSubject data;

  const GoalsPage({Key key, this.data}) : super(key: key);
  @override
  _GoalsPageState createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  List<IMKOGoalGroup> data = [];
  bool loading = true;
  @override
  void initState() {
    super.initState();
    getGoals();
  }

  getGoals() async {
    if (!mounted) {
      return;
    }
    setState(() {
      loading = true;
      data = [];
    });
    List<IMKOGoalGroup> list = await widget.data.getGoals();
    if (mounted) {
      setState(() {
        data = list;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (loading) {
      body = Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white54)),
      );
    } else {
      body = SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                data.map((data) => IMKOGoalGroupWidget(data: data)).toList(),
          ),
        ),
      );
    }
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 64.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 24.0, left: 16.0, right: 16.0),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: TabBar(
                    tabs: [
                      Tab(text: 'Goals'),
                      Tab(text: 'Homework'),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: (loading) ? null : getGoals,
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            body,
            Container(
              child: Center(
                child: Text('Work In Progress'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
