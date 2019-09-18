import 'package:flutter/material.dart';
import './screens/login/login.dart';
import './screens/more/account_info.dart';
import './screens/home/tabs_page.dart';
import './screens/workout/training.dart';

const LoginRoute = '/';
const TabsRoute = '/tabs';
const TrainingRoute = '/training';
const AccountInfoRoute = '/info';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      onGenerateRoute: _routes(),
    );
  }

  RouteFactory _routes() {
    return (settings) {
      final Map<String, dynamic> arguments = settings.arguments;
      Widget screen;
      switch (settings.name) {
        case LoginRoute:
          screen = Login();
          break;
        case TabsRoute:
          screen = TabsPage();
          break;
        case TrainingRoute:
          screen = Training(arguments['id']);
          break;
        case AccountInfoRoute:
          screen = AccountInfo();
          break;
        default:
          return null;
      }
      return MaterialPageRoute(builder: (BuildContext context) => screen);
    };
  }
}
