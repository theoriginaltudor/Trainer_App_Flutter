import 'package:flutter/material.dart';
import 'package:trainer_app_flutter/app.dart';
import 'package:trainer_app_flutter/models/exercise.dart';
import 'package:trainer_app_flutter/models/exercise_dao.dart';
import 'package:trainer_app_flutter/models/exercise_request.dart';
import 'package:trainer_app_flutter/models/history.dart';
import 'package:trainer_app_flutter/models/history_dao.dart';
import 'package:trainer_app_flutter/models/history_request.dart';
import 'package:trainer_app_flutter/models/workout.dart';
import 'package:trainer_app_flutter/models/workout_dao.dart';
import 'package:trainer_app_flutter/models/workout_request.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Sync extends StatefulWidget {
  @override
  _SyncState createState() => _SyncState();
}

class _SyncState extends State<Sync> {
  @override
  void initState() {
    super.initState();
    this._syncData();
  }

  void _syncData() async {
    var results = await Future.wait([
      this._syncExercises(),
      this._syncWorkouts(),
    ]);
    results.map((result) => print(result));
    Navigator.pushNamed(context, TabsRoute);
    // Future.delayed(
    //   Duration(seconds: 2),
    //   () => Navigator.pushNamed(context, TabsRoute),
    // );
  }

  Future _syncExercises() async {
    List<Exercise> exercises = (await ExerciseRequest.fetchAllExercises()).data;

    return Future.forEach(
      exercises,
      (exercise) async => await ExerciseDao().insert(exercise),
    );
  }

  Future _syncWorkouts() async {
    List<Workout> workouts = (await WorkoutRequest.fetchWorkouts()).data;

    return Future.forEach(
      workouts,
      (workout) async {
        await WorkoutDao().insert(workout);
        await this._syncHistory(workout.sId);
      },
    );
  }

  Future _syncHistory(String workoutId) async {
    List<History> historyList =
        (await HistoryRequest.fetchHistoryWorkout(workoutId)).data;

    return Future.forEach(
      historyList,
      (history) async => await HistoryDao().insert(history),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SpinKitPouringHourglass(
              color: Colors.white,
              size: 100.0,
            ),
            SizedBox(
              height: 50,
            ),
            Text('The data is syncing online. Please wait a little'),
          ],
        ),
      ),
    );
  }
}
