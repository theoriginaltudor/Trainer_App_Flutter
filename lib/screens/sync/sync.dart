import 'package:flutter/material.dart';
import '../../app.dart';
import '../../models/exercise.dart';
import '../../models/exercise_dao.dart';
import '../../models/exercise_request.dart';
import '../../models/history.dart';
import '../../models/history_dao.dart';
import '../../models/history_request.dart';
import '../../models/workout.dart';
import '../../models/workout_dao.dart';
import '../../models/workout_request.dart';
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

// TODO: what happens if user updates his workout
// TODO: when offline client id is null
  void _syncData() async {
    await Future.wait([
      this._syncExercises(),
      this._syncWorkouts(),
    ]);
    Navigator.pushNamed(context, TabsRoute);
    // Future.delayed(
    //   Duration(seconds: 2),
    //   () => Navigator.pushNamed(context, TabsRoute),
    // );
  }

  Future _syncExercises() async {
    List<Exercise> exercises = (await ExerciseRequest.fetchAllExercises()).data;

    return await Future.forEach(
      exercises,
      (exercise) async => await ExerciseDao().insert(exercise),
    );
  }

  Future _syncWorkouts() async {
    List<Workout> workouts = (await WorkoutRequest.fetchWorkouts()).data;
    List<Workout> offlineWorkouts = await WorkoutDao().getAllData();

    await Future.forEach(
      offlineWorkouts,
      (workout) async {
        if (workout.sId.length != 24) {
          await WorkoutDao().delete(workout.sId);
          Workout newWorkout = (await WorkoutRequest.createWorkout(workout)).data.first;
          await this._syncHistoryFromOffline(workout.sId, newWorkout.sId);
        }
      },
    );

    return await Future.forEach(
      workouts,
      (workout) async {
        await WorkoutDao().insert(workout);
        await this._syncHistoryFromOnline(workout.sId);
      },
    );
  }

  Future _syncHistoryFromOnline(String workoutId) async {
    List<History> historyList =
        (await HistoryRequest.fetchHistoryWorkout(workoutId)).data;

    return await Future.forEach(
      historyList,
      (history) async => await HistoryDao().insert(history),
    );
  }

  Future _syncHistoryFromOffline(String oldWorkoutId, String newWorkoutId) async {
    List<History> offlineHistoryList = await HistoryDao().getHistoryForWorkout(oldWorkoutId);

    return await Future.forEach(
      offlineHistoryList,
      (History history) async {
        if (history.sId.length != 24) {
          await HistoryDao().delete(history.sId);
          await HistoryRequest.postHistoryEntry(
              newWorkoutId, history.exerciseId, history);
        }
      },
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
