import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trainer_app_flutter/models/exercise.dart';
import '../models/workout.dart';
import '../models/exercise_request.dart';

class CustomCard extends StatelessWidget {
  final Workout workout;
  final Function onTap;

  CustomCard({this.workout, this.onTap});

  @override
  Widget build(BuildContext context) {
    // var exercises = fetchExercises(this.workout.exerciseList);

    return FutureBuilder(
      future: ExerciseRequest.fetchExercises(this.workout.exerciseList),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Card(
            margin: EdgeInsets.fromLTRB(30, 10, 30, 0),
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: this.onTap,
              child: Container(
                padding: EdgeInsets.all(10),
                height: 100,
                child: ListView(
                  children: [
                    Text(this.workout.name),
                    ...fields(snapshot.data.data)
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return SpinKitCubeGrid(
          color: Colors.white,
        );
      },
    );
  }

  List<Widget> fields(List<Exercise> exercises) {
    try {
      return exercises
          .asMap()
          .map((index, exercise) => MapEntry(index,
              Text(exercise.name + ' ' + workout.recomendationsList[index])))
          .values
          .toList();
    } catch (e) {
      print(e);
      return <Widget>[];
    }
  }
}
