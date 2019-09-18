import 'package:flutter/material.dart';
import '../workout/workouts.dart';
import '../diet/diet.dart';
import '../more/more.dart';
import '../measurements/measurements.dart';

class TabsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
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
              Workouts(),
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
