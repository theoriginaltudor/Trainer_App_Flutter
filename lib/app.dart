import 'package:flutter/material.dart';
import './screens/sync/sync.dart';
import './screens/workout/calendar.dart';
import './screens/login/login.dart';
import './screens/more/account_info.dart';
import './screens/home/tabs_page.dart';
import './screens/workout/training.dart';
import './variables.dart' as global;


const LoginRoute = '/';
const TabsRoute = '/tabs';
const TrainingRoute = '/training';
const AccountInfoRoute = '/info';
const CalendarRoute = '/calendar';
const SyncingRoute = '/syncing';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      onGenerateRoute: _routes(),
      theme: ThemeData.dark(),
    );
  }

  RouteFactory _routes() {
    return (settings) {
      final Map<String, dynamic> arguments = settings.arguments;
      Widget screen;
      switch (settings.name) {
        case LoginRoute:
          screen = Scaffold(body: Login());
          break;
        case TabsRoute:
          screen = TabsPage();
          break;
        case TrainingRoute:
          screen = Training(arguments['workout']);
          break;
        case AccountInfoRoute:
          screen = AccountInfo(email: global.email ,trainer: 'Trainer');
          break;
        case CalendarRoute:
          screen = CalendarPage(arguments['workouts']);
          break;
        case SyncingRoute:
          screen = Sync();
          break;
        default:
          return null;
      }
      return MaterialPageRoute(builder: (BuildContext context) => screen);
    };
  }
}
