import 'package:flutter/material.dart';
import 'package:update_project/components/custom_text_field.dart';
import 'package:update_project/models/exercise.dart';
import 'package:update_project/models/exercise_dao.dart';
import '../../models/history.dart';
import '../../models/history_dao.dart';
import '../../models/workout.dart';
import '../../models/workout_dao.dart';
import '../../components/custom_flat_button.dart';

class AccountInfo extends StatelessWidget {
  final String email;
  final String trainer;
  final TextEditingController _textfieldData = TextEditingController();

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
            labelTitle: 'Print local history (console)',
            onTap: () async {
              // await WorkoutDao().delete('5e1b197bcd89241f84ff9d80');
              // await HistoryDao().delete("-LxBCtDlv6GAb7nKPc8c");
              List<Workout> workouts = await WorkoutDao().getAllData();
              for (var item in workouts) {
                print(item.toJson(withId: true));
              }
              List<History> histories = await HistoryDao().getAllData();
              for (var item in histories) {
                print(item.toJson(withIds: true));
              }
            },
          ),
          CustomTextField(
            labelTitle: 'Exercise Name',
            controller: _textfieldData,
          ),
          CustomFlatButton(
            labelTitle: 'Add exercise to local list',
            onTap: () async {
              Exercise e = Exercise(
                  name: _textfieldData.text, description: _textfieldData.text);
              await ExerciseDao().insert(e);
              _textfieldData.clear();
            },
          )
        ],
      ),
    );
  }
}
