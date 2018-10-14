import 'package:flutter/material.dart';

class NumberInputWidget extends StatefulWidget {
  final String hint;
  final String defaultValue;
  final Function(int) onValueUpdate;

  const NumberInputWidget(
      {Key key, this.hint, this.onValueUpdate, this.defaultValue})
      : super(key: key);

  @override
  NumberInputWidgetState createState() {
    return new NumberInputWidgetState();
  }
}

class NumberInputWidgetState extends State<NumberInputWidget> {
  TextEditingController controller;
  @override
  void initState() {
    controller = new TextEditingController(text: widget.defaultValue);
    super.initState();
    controller.addListener(() {
      try {
        int n = int.parse(controller.text);
        widget.onValueUpdate(n);
      } catch (e) {
        widget.onValueUpdate(-1);
      }
    });
  }

  add(val) {
    try {
      int n = int.parse(controller.text);
      n += val;
      controller.text = n.toString();
      widget.onValueUpdate(n);
    } catch (e) {
      widget.onValueUpdate(-1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(64.0),
      ),
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Row(children: [
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () => add(-1),
        ),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
                hintText: widget.hint, border: InputBorder.none),
            keyboardType:
                TextInputType.numberWithOptions(signed: false, decimal: false),
            controller: controller,
          ),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => add(1),
        ),
      ]),
    );
  }
}
