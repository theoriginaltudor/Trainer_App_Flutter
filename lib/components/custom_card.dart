import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String heading;
  final String body;

  CustomCard({this.heading, this.body});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(30, 10, 30, 0),
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          print('Card tapped.');
        },
        child: Container(
          padding: EdgeInsets.all(10),
          height: 100,
          child: Text('A card that can be tapped', textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
