import 'package:flutter/material.dart';
import 'package:trainer_app_flutter/models/history.dart';
import 'package:trainer_app_flutter/models/history_dao.dart';
import 'package:trainer_app_flutter/models/workout.dart';
import 'package:trainer_app_flutter/models/workout_dao.dart';
import '../../components/custom_flat_button.dart';

class AccountInfo extends StatelessWidget {
  final String email;
  final String trainer;

  AccountInfo({this.email, this.trainer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Info'),
      ),
      body: ListView(
        children: [
          //TODO: Turn the texts in (textfields with values) so they can be changed
          Text('Your email is : ${this.email}'),
          Text('Your trainer is : ${this.trainer}'),
          CustomFlatButton(
            labelTitle: 'Update',
            onTap: () async {
              // await WorkoutDao().delete("-Lu7K1jjSXJQA4Qk3th5");
              // await HistoryDao().delete("-Lu7K1lEm3hUcRV_QI_J");
              List<Workout> workouts = await WorkoutDao().getAllSortedByName();
              for (var item in workouts) {
                if (item.name == "New workout") {
                  print(item.toJson(withId: true));
                }
              }
              List<History> histories = await HistoryDao().getAllSortedByName();
              for (var item in histories) {
                print(item.toJson(withIds: true));
              }
            },
          ),
        ],
      ),
    );
  }
}
