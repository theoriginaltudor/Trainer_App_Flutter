import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelTitle;
  final TextEditingController controller;
  final Function onChange;

  CustomTextField({this.labelTitle, this.controller, this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: controller == null
          ? TextField(
              obscureText: false,
              onEditingComplete: this.onChange,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: labelTitle,
              ),
            )
          : TextField(
              obscureText: false,
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: labelTitle,
              ),
            ),
    );
  }
}
