import 'package:flutter/material.dart';
import '../../components/custom_text_field.dart';
import '../../components/custom_flat_button.dart';

class Diet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final labelTitles = ['Protein', 'Fat', 'Carbs'];

    return Scaffold(
        body: ListView(children: [
      ...textFields(labelTitles),
      CustomFlatButton(
        labelTitle: 'Save',
        horizontalPadding: 10.0,
      )
    ]));
  }

  List<Widget> textFields(List<String> labelTitles) {
    return labelTitles
        .map((labelTitle) => CustomTextField(labelTitle: labelTitle))
        .toList();
  }
}
