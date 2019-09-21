import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trainer_app_flutter/components/exercise_card.dart';
import '../../components/custom_flat_button.dart';

class Training extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _TrainingState();
  }
}

class _TrainingState extends State<Training> {
  // final String _id;
  bool _timerRunning = false;
  String _sTimer = '00:00';
  int _iTimer = 0;
  List<String> cardTitles = ['Train1', 'Train2', 'Train3'];

  // Training(this._id);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Training'),
            CustomFlatButton(labelTitle: this._sTimer, onTap: () => {
              changeTimerState()
            },)
          ]
        ),
      ),
      body: ListView(
        children: [
          CustomFlatButton(labelTitle: 'Finish workout', onTap: () => {Navigator.pop(context)},),
          CustomFlatButton(labelTitle: 'Cancel workout', onTap: () => {Navigator.pop(context)},),
          ...cards(this.cardTitles),
          CustomFlatButton(labelTitle: 'Add exercise', onTap: () => {addExercise()},),
        ],
      ),
    );
  }

  void changeTimerState() {
    if (this._timerRunning) {
      // stop and reset timer
      setState(() {
        _timerRunning = false;
        _sTimer = '00:00';
        _iTimer = 0;
      });
    } else {
      // start timer
      setState(() {
       _timerRunning = true;
      });
      startTimer();
    }
  }

  void startTimer() {
    Timer(Duration(seconds: 1), keepRunning);
  }

  void keepRunning() {
    if (this._timerRunning) {
      startTimer();
    }
    setState(() {
      _sTimer = (this._iTimer ~/ 60).toString().padLeft(2, '0') + ':' + (this._iTimer % 60).toString().padLeft(2, '0');
      _iTimer = _iTimer + 1;
    });
  }

  void addExercise() {
    setState(() {
      cardTitles.add('Test');
    });
  }

  List<Widget> cards(List<String> cardTitles) {
    return cardTitles.map((title) => ExerciseCard()).toList();
  }
}
