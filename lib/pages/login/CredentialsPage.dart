import 'package:enis/api/user_data.dart';
import 'package:enis/classes/diary.dart';
import 'package:enis/classes/globals.dart';
import 'package:enis/classes/school.dart';
import 'package:enis/pages/login/CaptchaDialog.dart';
import 'package:flutter/material.dart';

class CredentialsPage extends StatefulWidget {
  final Function onLoggedIn;
  final Function onDismissed;
  final String school;
  final Diary diary;

  const CredentialsPage(
      {Key key, this.onLoggedIn, this.onDismissed, this.school, this.diary})
      : super(key: key);
  @override
  _CredentialsPageState createState() => _CredentialsPageState();
}

class _CredentialsPageState extends State<CredentialsPage> {
  TextEditingController pinController;
  TextEditingController passController;
  String error;

  initState() {
    super.initState();
    pinController = new TextEditingController(text: '');
    passController = new TextEditingController(text: '');
    pinController.addListener(() {
      setState(() {
        error = null;
      });
    });
    passController.addListener(() {
      setState(() {
        error = null;
      });
    });
  }

  login(BuildContext context, [String captcha]) async {
    OverlayEntry loadingIndicator = new OverlayEntry(
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
          ),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
    Overlay.of(context).insert(loadingIndicator);
    try {
      UserData data = UserData.newUser(
        pin: pinController.text,
        password: passController.text,
        url: School.schools[widget.school],
        diary: widget.diary,
      );
      await data.login(saveToPrefs: true, captcha: captcha);
      Globals.user = data;
      loadingIndicator.remove();
      Navigator.pushReplacementNamed(context, 'main');
    } catch (e) {
      loadingIndicator.remove();
      print(e.toString());
      if (e.runtimeType == CaptchaException) {
        showDialog(
          builder: (BuildContext ctx) {
            return Dialog(
              child: CaptchaDialog(
                captcha: e.captcha,
                onSubmit: (submittedCaptcha) {
                  Navigator.pop(context);
                  login(context, submittedCaptcha);
                },
              ),
            );
          },
          barrierDismissible: true,
          context: context,
        );
      } else {
        String message = e.toString();
        setState(() {
          error = message;
        });
        Scaffold.of(context).showSnackBar(new SnackBar(content: Text(message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Login',
                  style:
                      TextStyle(fontSize: 48.0, fontWeight: FontWeight.w700)),
              Text('Log into your account',
                  style: TextStyle(color: Colors.white70)),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.face),
                    labelText: 'Your PIN',
                    border: OutlineInputBorder(),
                    errorText: error),
                keyboardType: TextInputType.numberWithOptions(
                    decimal: false, signed: false),
                controller: pinController,
              ),
              SizedBox(height: 8.0),
              TextField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Your password',
                    border: OutlineInputBorder(),
                    errorText: error),
                obscureText: true,
                controller: passController,
              ),
              SizedBox(height: 8.0),
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
                    label: Text('Log in'),
                    icon: Icon(Icons.chevron_right),
                    onPressed: () => login(context),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
