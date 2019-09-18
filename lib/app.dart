import 'package:flutter/material.dart';
import 'screens/workout/workout_routes.dart';
import 'screens/diet/diet.dart';
import 'screens/more/more.dart';
import 'screens/measurements/measurements.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.fitness_center)),
                Tab(icon: Icon(Icons.restaurant)),
                Tab(icon: Icon(Icons.assessment)),
                Tab(icon: Icon(Icons.settings)),
              ],
            ),
            title: Text('Workout App'),
          ),
          body: TabBarView(
            children: [
              WorkoutRoutes(),
              Diet(),
              Measurements(),
              More(),
            ],
          ),
        ),
      ),
    );
  }
}
