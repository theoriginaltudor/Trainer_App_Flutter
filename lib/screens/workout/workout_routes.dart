import 'package:flutter/material.dart';
import './workouts.dart';
import './training.dart';

const WorkoutsRoute = '/';
const TrainingRoute = '/training';

class WorkoutRoutes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Navigator(
      onGenerateRoute: _routes(),
    );
  }

  RouteFactory _routes() {
    return (settings) {
      final Map<String, dynamic> arguments = settings.arguments;
      Widget screen;
      switch (settings.name) {
        case WorkoutsRoute:
          screen = Workouts();
          break;
        case TrainingRoute:
          screen = Training(arguments['id']);
          break;
//         case CalendarRoute:
//           screen = Calendar();
//           break;
        default:
          return null;
      }
      return MaterialPageRoute(builder: (BuildContext context) => screen);
    };
  }
}