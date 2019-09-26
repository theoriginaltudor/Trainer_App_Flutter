import 'package:flutter/material.dart';
import '../../models/workout.dart';
import '../../models/workout_request.dart';
import '../../components/custom_flat_button.dart';
import '../../components/custom_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Workouts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: 
      FutureBuilder(
        future: fetchWorkouts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: [
                CustomFlatButton(labelTitle: 'New Workout', onTap: () => openTraining(context, new Workout())),
                CustomFlatButton(labelTitle: 'Copy previous', onTap: () => openCalendar(context)),
                ...cards(context, snapshot.data.data)
              ],
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      ),    
    );
  }

  openTraining(BuildContext context, Workout workout) {
    Navigator.pushNamed(context, '/training', arguments: {'workout': workout});
  }
  
  openCalendar(BuildContext context) {
    Navigator.pushNamed(context, '/calendar');
  }
  List<Widget> cards(BuildContext context, List<Workout> workoutsList) {
    return workoutsList.map((workout) => CustomCard(workout: workout,onTap: () => openTraining(context, workout))).toList();
  }

  Future<WorkoutRequest> fetchWorkouts() async {
    final response = await http.get('http://195.249.188.75:2000/api/workouts-for-client/5cd409f31c9d44000033363d');
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return WorkoutRequest.fromJson(jsonDecode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load Workouts');
    }
  }
}
