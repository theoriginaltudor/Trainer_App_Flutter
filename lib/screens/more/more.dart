import 'package:flutter/material.dart';
import '../../components/custom_flat_button.dart';

class More extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final labelTitles = ['Account Info', 'Logout'];

    return Scaffold(
      body: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) => _itemBuilder(labelTitles[index]),
      ),
    );
  }

  Widget _itemBuilder(String labelTitle) {
    return CustomFlatButton(labelTitle: labelTitle);
  }
}
