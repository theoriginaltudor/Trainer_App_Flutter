import 'package:flutter/material.dart';
import '../../components/custom_text_field.dart';
import '../../components/custom_flat_button.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final labelTitles = ['Email', 'Password'];

    return Scaffold(
        body: Center(
          child: 
        ListView(
          shrinkWrap: true,
          children: [
      ...textFields(labelTitles),
      CustomFlatButton(
        labelTitle: 'Login',
        horizontalPadding: 10.0,
        onTap: () => {
          _onLoginTap(context)
        },
      ),
      CustomFlatButton(
        labelTitle: 'Clear',
        horizontalPadding: 10.0,
      )
    ])));
  }

  _onLoginTap(BuildContext context) {
    Navigator.pushNamed(context, '/tabs');
  }

  List<Widget> textFields(List<String> labelTitles) {
    return labelTitles
        .map((labelTitle) => CustomTextField(labelTitle: labelTitle))
        .toList();
  }
}
