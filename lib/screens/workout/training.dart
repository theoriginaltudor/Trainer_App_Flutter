import 'dart:async';

import 'package:flutter/material.dart';
import '../../components/custom_flat_button.dart';
import '../../components/custom_text_field.dart';

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

  // Training(this._id);

  @override
  Widget build(BuildContext context) {
    final cardTitles = ['Train1', 'Train2', 'Train3'];

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
          ...cards(cardTitles)
        ],
      ),
    );
  }

  void changeTimerState() {
    if (this._timerRunning) {
      // stop and reset timer
      print(this._iTimer);
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

  List<Widget> cards(List<String> cardTitles) {
    return cardTitles.map((title) => CustomTextField(labelTitle: title)).toList();
  }
}
