import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../components/all_exercises.dart';
import '../../components/exercise_card.dart';
import '../../models/workout.dart';
import '../../models/workout_request.dart';
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
            CustomFlatButton(
              labelTitle: this._sTimer,
              onTap: changeTimerState,
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          CustomFlatButton(
            labelTitle: 'Finish workout',
            onTap: () => onFinishWorkout(context),
          ),
          CustomFlatButton(
            labelTitle: 'Cancel workout',
            onTap: () => Navigator.pop(context),
          ),
          ...cards(
            widget.workout.exerciseList,
            widget.workout.recomendationsList,
          ),
          CustomFlatButton(
            labelTitle: 'Add exercise',
            onTap: addExercise,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'video0',
        tooltip: 'Record Video',
        child: const Icon(Icons.videocam),
        onPressed: _openCamera,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  @override
  void initState() {
    super.initState();
    retrieveLostData();
  }

  void _openCamera() async {
    final File file = await ImagePicker.pickVideo(source: ImageSource.camera);
    final String path = (await getApplicationDocumentsDirectory()).path;
    // TODO: create the workout.sId before creating the file
    final File newVideo =
        await file.copy('$path/video_${widget.workout.sId}.mp4');
    print('We have a video file' + newVideo.toString());
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      if (response.type == RetrieveType.video) {
        print('We retrieved a video file' + response.file.toString());
      }
    } else {
      print(response.exception.code);
    }
  }

  onFinishWorkout(BuildContext context) {
    bool validData = true;
    if (this.cardsList.length > 0) {
      for (var card in this.cardsList) {
        if (!card.checkData()) validData = false;
      }
    } else {
      validData = false;
    }
    if (validData) {
      if (widget.workout.name == 'New workout') {
        WorkoutRequest.createWorkout(widget.workout).then((response) {
          print("onFinishWorkout new workout " + jsonEncode(response.toJson()));
          for (var card in this.cardsList) {
            card.saveData(workoutId: response.data.first.sId);
          }
        });
      } else {
        for (var card in this.cardsList) {
          card.saveData();
        }
      }

      Navigator.pop(context);
    } else {
      // Scaffold.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('Empty exercise detected'),
      //     ),
      //   );
    }
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
      _sTimer = (this._iTimer ~/ 60).toString().padLeft(2, '0') +
          ':' +
          (this._iTimer % 60).toString().padLeft(2, '0');
      _iTimer = _iTimer + 1;
    });
  }

  void addExercise() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AllExercises();
      },
    ).then((response) {
      if (response != null) {
        setState(() {
          if (widget.workout.exerciseList == null) {
            widget.workout.exerciseList = response;
            widget.workout.recomendationsList = [];
          } else {
            widget.workout.exerciseList.addAll(response);
          }
          for (var i = 0; i < response.length; i++) {
            widget.workout.recomendationsList.add('Not defined');
          }
        });
      }
    }, onError: (error) {
      print('Error on show dialog: ' + error.toString());
    });
  }

  List<ExerciseCard> cards(
    List<String> exerciseIds,
    List<String> recomendations,
  ) {
    if (exerciseIds == null) {
      return <ExerciseCard>[];
    }
    this.cardsList = exerciseIds
        .asMap()
        .map((index, id) => MapEntry(
              index,
              ExerciseCard(
                workoutId: widget.workout.sId,
                exerciseId: id,
                recomendation: recomendations[index],
              ),
            ))
        .values
        .toList();
    return this.cardsList;
  }
}
