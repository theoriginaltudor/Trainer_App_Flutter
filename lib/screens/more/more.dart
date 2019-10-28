import 'package:flutter/material.dart';
import '../../components/custom_flat_button.dart';

class More extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          CustomFlatButton(labelTitle: 'Account Info', onTap: () => {
            Navigator.pushNamed(context, '/info')
          },), 
          CustomFlatButton(labelTitle: 'Logout', onTap: () => {
            Navigator.pushNamed(context, '/')
          },),
        ],
      ),
    );
  }
}
