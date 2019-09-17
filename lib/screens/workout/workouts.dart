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
          CustomFlatButton(labelTitle: 'New Workout'),
          CustomFlatButton(labelTitle: 'Copy previous', _onTap: openDatePicker),
          ...cards(cardTitles)
        ],
      ),
    );
  }
  
  openDatePicker() {
    DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2019, 9, 1),
                              maxTime: DateTime.now(), onChanged: (date) {
                            print('change $date');
                          }, onConfirm: (date) {
                                // navigate to training page with the workout from the chosen date
                            print('confirm $date');
                          }, currentTime: DateTime.now(), locale: LocaleType.zh);
  }
  List<Widget> cards(List<String> cardTitles) {
    return cardTitles.map((title) => CustomCard()).toList();
  }
}
