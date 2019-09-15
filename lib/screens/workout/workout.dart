import 'package:flutter/material.dart';
import '../../components/custom_flat_button.dart';
import '../../components/custom_card.dart';

class Workout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cardTitles = ['Protein', 'Fat', 'Carbs'];

    return Scaffold(
      body: ListView(
        children: [
          CustomFlatButton(labelTitle: 'New Workout'),
          CustomFlatButton(labelTitle: 'Copy previous'),
          ...cards(cardTitles)
        ],
      ),
    );
  }

  List<Widget> cards(List<String> cardTitles) {
    return cardTitles.map((title) => CustomCard()).toList();
  }
}
