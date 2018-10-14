import 'package:enis/api/jko_subject.dart';
import 'package:enis/pages/subjects/JKOEvaluationWidget.dart';
import 'package:flutter/material.dart';

class EvaluationsPage extends StatefulWidget {
  final JKOSubject data;

  const EvaluationsPage({Key key, this.data}) : super(key: key);
  @override
  _EvaluationsPageState createState() => _EvaluationsPageState();
}

class _EvaluationsPageState extends State<EvaluationsPage> {
  List<JKOAssessment> section = [];
  List<JKOAssessment> term = [];
  bool loading = false;
  bool fail = false;
  @override
  void initState() {
    super.initState();
    getEvaluations();
  }

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  getEvaluations() async {
    try {
      if (!mounted) return;
      setState(() {
        loading = true;
        section = [];
        term = [];
      });
      widget.data.getAssessments((i, eval) {
        if (i == 0) {
          if (mounted) {
            setState(() {
              section = eval;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              term = eval;
              loading = false;
            });
          }
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        fail = true;
        loading = false;
      });
      if (scaffoldKey.currentState != null) {
        scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> body = [];
    if (fail) {
      Widget b = Center(
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
              onPressed: getEvaluations,
            ),
          ],
        ),
      );
      body = [b, b];
    } else if (loading) {
      Widget b = Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white54)),
      );
      body = [b, b];
    } else {
      body.add(SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: section.map((eval) => JKOEvaluationWidget(eval)).toList(),
          ),
        ),
      ));
      body.add(SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: term.map((eval) => JKOEvaluationWidget(eval)).toList(),
          ),
        ),
      ));
    }
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: scaffoldKey,
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
                      Tab(text: 'СОр'),
                      Tab(text: 'СОч'),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: (loading) ? null : getEvaluations,
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: body,
        ),
      ),
    );
  }
}
