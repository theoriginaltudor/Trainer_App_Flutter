import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trainer_app_flutter/components/all_exercises.dart';
import 'package:trainer_app_flutter/components/exercise_card.dart';
import 'package:trainer_app_flutter/models/workout.dart';
import 'package:trainer_app_flutter/models/workout_request.dart';
import '../../components/custom_flat_button.dart';

class Training extends StatefulWidget {
  final Workout workout;

  Training(this.workout);

  @override
  State<StatefulWidget> createState() {
    return new _TrainingState();
  }
}

class _TrainingState extends State<Training> {
  bool _timerRunning = false;
  String _sTimer = '00:00';
  int _iTimer = 0;
  List<ExerciseCard> cardsList = [];

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
          CustomFlatButton(labelTitle: 'Finish workout', onTap: () => {onFinishWorkout()},),
          CustomFlatButton(labelTitle: 'Cancel workout', onTap: () => {Navigator.pop(context)},),
          ...cards(widget.workout.exerciseList, widget.workout.recomendationsList),
          CustomFlatButton(labelTitle: 'Add exercise', onTap: () => {addExercise()},),
        ],
      ),
    );
  }

  Future onFinishWorkout() async {
    if (widget.workout.name == 'New workout') {
      WorkoutRequest.createWorkout(widget.workout).then(((response) => {
        // print(jsonEncode(response.toJson()))
        for (var card in this.cardsList) {
          card.saveData(workoutId: response.data.first.sId)
        }
      }));
    } else {
      for (var card in this.cardsList) {
        card.saveData();
      }
    }
    
    Navigator.pop(context);
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

  void addExercise() async {
    await showDialog(context: context, builder: (BuildContext context) {
      return AllExercises();
    }).then((response) => {
      setState(() {
        if (widget.workout.exerciseList == null) {
          widget.workout.exerciseList = response;
          widget.workout.recomendationsList = [];
        } else {
          widget.workout.exerciseList.addAll(response);
        }
        for (var item in response) {
          widget.workout.recomendationsList.add('Not defined');
        }
      })
    });
  }

  List<ExerciseCard> cards(List<String> exerciseIds, List<String> recomendations) {
    if (exerciseIds == null) {
      return <ExerciseCard>[];
    }
    this.cardsList = exerciseIds.asMap().map((index, id) => MapEntry(index, ExerciseCard(workoutId: widget.workout.sId ,exerciseId: id,recomendation: recomendations[index]))).values.toList();
    return this.cardsList;
  }
}
