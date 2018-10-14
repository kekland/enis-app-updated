import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class CaptchaDialog extends StatefulWidget {
  final String captcha;
  final Function(String) onSubmit;

  const CaptchaDialog({Key key, this.captcha, this.onSubmit}) : super(key: key);
  @override
  _CaptchaDialogState createState() => _CaptchaDialogState();
}

class _CaptchaDialogState extends State<CaptchaDialog> {
  TextEditingController controller;
  @override
  void initState() {
    controller = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Captcha',
              style: TextStyle(fontSize: 48.0, fontWeight: FontWeight.w700)),
          Text('We\'re sorry for this inconvenience',
              style: TextStyle(color: Colors.white70)),
          SizedBox(height: 16.0),
          Image.memory(base64.decode(widget.captcha),
              width: double.infinity, fit: BoxFit.cover),
          SizedBox(height: 8.0),
          TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Captcha'),
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: FlatButton.icon(
              label: Text('Submit'),
              icon: Icon(Icons.chevron_right),
              onPressed: () => widget.onSubmit(controller.text),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
