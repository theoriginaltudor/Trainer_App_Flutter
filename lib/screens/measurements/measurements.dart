import 'package:flutter/material.dart';
import '../../components/custom_flat_button.dart';
import '../../components/custom_text_field.dart';

class Measurements extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final labelTitles = ['Weight', 'Chest', 'Calfs', 'Arms', 'Waist'];

    return Scaffold(
      body: ListView(
        children: [
          ...textFields(labelTitles),
          CustomFlatButton(
            labelTitle: 'Save',
            horizontalPadding: 10.0,
          ),
          CustomFlatButton(
            labelTitle: 'See graphs',
            horizontalPadding: 10.0,
          )
        ],
      ),
    );
  }

  List<Widget> textFields(List<String> labelTitles) {
    return labelTitles
        .map((labelTitle) => CustomTextField(labelTitle: labelTitle))
        .toList();
  }
}
