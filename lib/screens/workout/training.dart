import 'package:flutter/material.dart';
import '../../components/custom_flat_button.dart';
import '../../components/custom_text_field.dart';

class Training extends StatelessWidget {
  final String _id;

  Training(this._id);

  @override
  Widget build(BuildContext context) {
    final cardTitles = ['Train1', 'Train2', 'Train3'];

    return Scaffold(
      body: ListView(
        children: [
          CustomFlatButton(labelTitle: 'Finish workout'),
          CustomFlatButton(labelTitle: 'Cancel workout'),
          ...cards(cardTitles)
        ],
      ),
    );
  }

  List<Widget> cards(List<String> cardTitles) {
    return cardTitles.map((title) => CustomTextField(labelTitle: title)).toList();
  }
}
