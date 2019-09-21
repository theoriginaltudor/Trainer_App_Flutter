import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String heading;
  final String body;
  final Function onTap;

  CustomCard({this.heading, this.body, this.onTap});

  @override
  Widget build(BuildContext context) {
    var exercises = ['Curls','PushUps', 'Deadlift'];

    return Card(
      margin: EdgeInsets.fromLTRB(30, 10, 30, 0),
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () => {
          this.onTap()
        },
        child: Container(
          padding: EdgeInsets.all(10),
          height: 100,
          child: ListView(
            children: [
              Text(this.heading),
              ...fields(exercises)
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> fields(List<String> exercises) {
    return exercises
        .map((exercise) => Text(exercise))
        .toList();
  }
}
