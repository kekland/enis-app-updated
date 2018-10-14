import 'package:enis/api/user_data.dart';
import 'package:enis/classes/globals.dart';
import 'package:enis/pages/birthdays/UserBirthdayWidget.dart';
import 'package:flutter/material.dart';

class BirthdaysPage extends StatefulWidget {
  @override
  _BirthdaysPageState createState() => _BirthdaysPageState();
}

class _BirthdaysPageState extends State<BirthdaysPage> {
  List<UserBirthday> birthdays = [];
  bool loading = false;
  bool fail = false;
  TextEditingController controller;
  initState() {
    super.initState();
    fetchBirthdays();
    controller = new TextEditingController();
    controller.addListener(() {
      setState(() {});
    });
  }

  fetchBirthdays() async {
    if (!mounted) return;
    setState(() {
      birthdays = [];
      loading = true;
      fail = false;
    });
    try {
      List<UserBirthday> data = await Globals.user.getBirthdays();
      if (!mounted) return;
      setState(() {
        birthdays = data;
        loading = false;
        fail = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        birthdays = [];
        loading = false;
        fail = true;
      });
      if (scaffoldKey.currentState != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(e.toString()),
        ));
      }
    }
  }

  getVisibleBirthdays() {
    birthdays.sort((b1, b2) {
      if (sortBy == 'name') {
        return b1.name.compareTo(b2.name);
      } else if (sortBy == 'birthday') {
        DateTime b1Time = DateTime.utc(0, b1.birthday.month, b1.birthday.day);
        DateTime b2Time = DateTime.utc(0, b2.birthday.month, b2.birthday.day);
        return b1Time.compareTo(b2Time);
      } else if (sortBy == 'age') {
        return b1.birthday.compareTo(b2.birthday);
      }
    });

    List<UserBirthday> toDisplay = [];
    for (UserBirthday bday in birthdays) {
      if (bday.name.toLowerCase().contains(controller.text.toLowerCase())) {
        toDisplay.add(bday);
      } else if (bday.getDate().contains(controller.text)) {
        toDisplay.add(bday);
      }
      else if(bday.role.toLowerCase().contains(controller.text.toLowerCase())) {
        toDisplay.add(bday);
      }
    }
    return toDisplay;
  }

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  String sortBy = 'name';
  @override
  Widget build(BuildContext context) {
    Widget body;
    if (fail) {
      body = Center(
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
              onPressed: fetchBirthdays,
            ),
          ],
        ),
      );
    } else if (loading) {
      body = Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
        ),
      );
    } else {
      List<UserBirthday> bdays = getVisibleBirthdays();
      if (bdays.length == 0) {
        body = Center(
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
                'Nothing found :/',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        );
      } else {
        body = Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemBuilder: (context, index) =>
                UserBirthdayWidget(data: bdays[index]),
            itemCount: bdays.length,
          ),
        );
      }
    }
    return Scaffold(
      key: scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 64.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Container(
                  height: 48.0,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  padding: const EdgeInsets.only(left: 12.0, right: 24.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.search),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            border: InputBorder.none,
                          ),
                          controller: controller,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text('Сортировать'),
                        enabled: false,
                      ),
                      PopupMenuItem(
                        child: Text('По имени'),
                        value: 'name',
                        enabled: !loading,
                      ),
                      PopupMenuItem(
                        child: Text('По дню рожения'),
                        value: 'birthday',
                      ),
                      PopupMenuItem(
                        child: Text('По возрасту'),
                        value: 'age',
                      ),
                    ],
                onSelected: (value) {
                  setState(() {
                    sortBy = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      body: body,
    );
  }
}
