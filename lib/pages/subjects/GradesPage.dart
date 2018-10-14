import 'package:enis/api/imko_subject.dart';
import 'package:enis/classes/globals.dart';
import 'package:enis/pages/birthdays/BirthdaysPage.dart';
import 'package:enis/pages/settings/SettingsPage.dart';
import 'package:enis/pages/subjects/TermPage.dart';
import 'package:flutter/material.dart';

class GradesPage extends StatefulWidget {
  @override
  _GradesPageState createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage>
    with AutomaticKeepAliveClientMixin<GradesPage> {
  List<Term> termData;
  bool loading = false;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    termData = [
      Term(subjects: [], id: -1, fail: false, loading: true),
      Term(subjects: [], id: -1, fail: false, loading: true),
      Term(subjects: [], id: -1, fail: false, loading: true),
      Term(subjects: [], id: -1, fail: false, loading: true),
    ];

    loadTerms();
  }

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  loadTerms() async {
    try {
      if (loading || !mounted) {
        return;
      }
      setState(() {
        loading = true;
        termData = [
          Term(subjects: [], id: -1, fail: false, loading: true),
          Term(subjects: [], id: -1, fail: false, loading: true),
          Term(subjects: [], id: -1, fail: false, loading: true),
          Term(subjects: [], id: -1, fail: false, loading: true),
        ];
      });
      await Globals.user.getGradesForYear((int index, Term term) {
        if (mounted) {
          setState(() {
            termData[index] = term;
            if (index == 3) {
              loading = false;
            }
          });
        }
      });
    } catch (e) {
      for (int i = 0; i < 4; i++) {
        termData[i].fail = true;
      }
      setState(() {
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
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        key: scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 64.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 24.0, left: 16.0, right: 16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TabBar(
                    tabs: [
                      Tab(text: '1 term'),
                      Tab(text: '2 term'),
                      Tab(text: '3 term'),
                      Tab(text: '4 term'),
                    ],
                  ),
                ),
                PopupMenuButton(
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Text('Refresh'),
                          value: 'Refresh',
                          enabled: !loading,
                        ),
                        PopupMenuItem(
                          child: Text('Birthdays'),
                          value: 'Birthdays',
                        ),
                        PopupMenuItem(
                          child: Text('Settings (WIP)'),
                          value: 'Settings',
                        ),
                      ],
                  onSelected: (action) {
                    if (action == 'Refresh') {
                      loadTerms();
                    } else if (action == 'Settings') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return SettingsPage();
                          },
                        ),
                      );
                    } else if (action == 'Birthdays') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return BirthdaysPage();
                          },
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children:
              termData.map((Term term) => TermPage(term, loadTerms)).toList(),
        ),
      ),
    );
  }
}
