import 'package:flutter/material.dart';
import '../../components/custom_flat_button.dart';
import '../../components/custom_card.dart';

class Workouts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cardTitles = ['Protein', 'Fat', 'Carbs'];

    return Scaffold(
      body: ListView(
        children: [
          CustomFlatButton(labelTitle: 'New Workout', onTap: () => {openTraining(context)}),
          CustomFlatButton(labelTitle: 'Copy previous', onTap: () => {openCalendar(context)},),
          ...cards(cardTitles)
        ],
      ),
    );
  }

  openTraining(BuildContext context) {
    Navigator.pushNamed(context, '/training', arguments: {'id': 'new'});
  }
  
  openCalendar(BuildContext context) {
    Navigator.pushNamed(context, '/calendar');
  }
  List<Widget> cards(List<String> cardTitles) {
    return cardTitles.map((title) => CustomCard()).toList();
  }
}
