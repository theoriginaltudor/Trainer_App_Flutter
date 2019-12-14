import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../app.dart';
import '../../models/workout.dart';
import '../../models/workout_request.dart';
import '../../components/custom_flat_button.dart';
import '../../components/custom_card.dart';
import '../../variables.dart' as global;

class Workouts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: WorkoutRequest.fetchWorkouts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Workout> workouts = List.from(snapshot.data.data);

            return ListView(
              children: [
                CustomFlatButton(
                  labelTitle: 'New Workout',
                  onTap: () => openTraining(
                    context,
                    new Workout(
                      name: 'New workout',
                      clientId: global.userId,
                    ),
                  ),
                ),
                CustomFlatButton(
                  labelTitle: 'Copy previous',
                  onTap: () => openCalendar(
                    context,
                    workouts,
                  ),
                ),
                ...cards(
                  context,
                  snapshot.data.data,
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return SpinKitPouringHourglass(color: Colors.white, size: 100.0,);
        },
      ),
    );
  }

  openTraining(BuildContext context, Workout workout) {
    Navigator.pushNamed(
      context,
      TrainingRoute,
      arguments: {'workout': workout},
    );
  }

  openCalendar(BuildContext context, List<Workout> workouts) {
    Navigator.pushNamed(
      context,
      CalendarRoute,
      arguments: {'workouts': workouts},
    );
  }

  List<Widget> cards(BuildContext context, List<Workout> workoutsList) {
    for (var i = 0; i < workoutsList.length; i++) {
      if (workoutsList[i].name == 'New workout') {
        workoutsList.remove(workoutsList[i]);
        i--;
      }
    }
    return workoutsList
        .map((workout) => CustomCard(
              workout: workout,
              onTap: () => openTraining(context, workout),
            ))
        .toList();
  }
}
