import 'package:flutter/material.dart';
import 'package:trainer_app_flutter/models/exercise.dart';
import '../models/workout.dart';
import '../models/exercise_request.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomCard extends StatelessWidget {
  final Workout workout;
  final Function onTap;

  CustomCard({this.workout, this.onTap});

  @override
  Widget build(BuildContext context) {
    // var exercises = fetchExercises(this.workout.exerciseList);

    return FutureBuilder(
      future: fetchExercises(this.workout.exerciseList),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Card(
            margin: EdgeInsets.fromLTRB(30, 10, 30, 0),
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () => {
                this.onTap()
              },
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
        } else if(snapshot.hasError) {
            return Text('${snapshot.error}');
        }
        return CircularProgressIndicator();
      },
    );
  }

  List<Widget> fields(List<Exercise> exercises) {
    return exercises.asMap()
        .map((index, exercise) => MapEntry(index, Text(exercise.name + ' ' + workout.recomendationsList[index]))).
        values.toList();
  }

  Future<ExerciseRequest> fetchExercises(List<String> exerciseList) async {
    Map<String, String> headers = {'Content-type': 'application/json'};
    var body = listToJson(exerciseList);
    // print(body);
    final response = await http.post('http://195.249.188.75:2000/api/exercise-list/', headers: headers, body: body);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return ExerciseRequest.fromJson(jsonDecode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception(response.body);
    }
  }

  String listToJson (List<String> list) {
    String sList = '[';
    for (var i = 0; i < list.length-1; i++) {
      sList = sList + '"' + list[i] + '",';
    }
    sList += '"' + list.last + '"' + ']';
    return sList;
  }
}
