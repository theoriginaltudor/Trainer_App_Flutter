import 'package:flutter/material.dart';
import 'package:trainer_app_flutter/app.dart';
import '../../components/custom_flat_button.dart';

class More extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          CustomFlatButton(
            labelTitle: 'Account Info',
            onTap: () => Navigator.pushNamed(context, AccountInfoRoute),
          ),
          CustomFlatButton(
            labelTitle: 'Logout',
            onTap: () => Navigator.pushNamed(context, LoginRoute),
          ),
        ],
      ),
    );
  }
}
