import 'package:flutter/material.dart';
import '../../components/custom_flat_button.dart';
import '../../components/custom_card.dart';

class Workouts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cardIDs = ['C011', 'A02', 'K444'];

    return Scaffold(
      body: ListView(
        children: [
          CustomFlatButton(labelTitle: 'New Workout', onTap: () => openTraining(context, 'new')),
          CustomFlatButton(labelTitle: 'Copy previous', onTap: () => openCalendar(context)),
          ...cards(context, cardIDs)
        ],
      ),
    );
  }

  openTraining(BuildContext context, String sID) {
    Navigator.pushNamed(context, '/training'/*, arguments: {'id': sID}*/);
  }
  
  openCalendar(BuildContext context) {
    Navigator.pushNamed(context, '/calendar');
  }
  List<Widget> cards(BuildContext context, List<String> cardIDs) {
    return cardIDs.map((sID) => CustomCard(onTap: () => openTraining(context, sID))).toList();
  }
}
