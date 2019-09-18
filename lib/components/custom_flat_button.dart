import 'package:flutter/material.dart';

class CustomFlatButton extends StatelessWidget {
  final String labelTitle;
  final double horizontalPadding;
  final Function onTap;

  CustomFlatButton({@required this.labelTitle, this.horizontalPadding = 30.0, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(
            this.horizontalPadding, 10, this.horizontalPadding, 0),
        child: FlatButton(
          color: Colors.blue,
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black,
          padding: EdgeInsets.all(8.0),
          splashColor: Colors.blueAccent,
          onPressed: () => {
            this.onTap()
          },
          child: Text(
            labelTitle,
            style: TextStyle(fontSize: 20.0),
          ),
        ));
  }
}
