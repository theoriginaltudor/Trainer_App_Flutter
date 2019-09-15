import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelTitle;

  CustomTextField({@required this.labelTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: TextField(
          obscureText: false,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: labelTitle,
          ),
        ));
  }
}
