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
      appBar: AppBar(
        title: Text('Training'),
      ),
      body: ListView(
        children: [
          CustomFlatButton(labelTitle: 'Finish workout', onTap: () => {Navigator.pop(context)},),
          CustomFlatButton(labelTitle: 'Cancel workout', onTap: () => {Navigator.pop(context)},),
          ...cards(cardTitles)
        ],
      ),
    );
  }

  List<Widget> cards(List<String> cardTitles) {
    return cardTitles.map((title) => CustomTextField(labelTitle: title)).toList();
  }
}
