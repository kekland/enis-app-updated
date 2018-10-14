import 'package:enis/pages/calculator/imko/IMKOTermPage.dart';
import 'package:flutter/material.dart';

class CalculatorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
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
                      Tab(text: 'IMKO Term'),
                      Tab(text: 'IMKO Year'),
                      Tab(text: 'JKO Term'),
                      Tab(text: 'JKO Year'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            IMKOTermPage(),
            Center(child: Text('WIP')),
            Center(child: Text('WIP')),
            Center(child: Text('WIP')),
          ],
        ),
      ),
    );
  }
}
