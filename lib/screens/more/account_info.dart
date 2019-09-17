import 'package:flutter/material.dart';
import '../../components/custom_flat_button.dart';

class AccountInfo extends StatelessWidget {
  final String email;
  final String trainer;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ListView(
        children: [
        // Turn the texts in textfields with values so they can be changed
          Text(`Your email is : ${this.email}`),
          Text(`Your trainer is : ${this.trainer}`),
          CustomFlatButton(labelTitle: 'Update')
        ]
      ),
    );
  }
}
