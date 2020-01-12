import 'package:http/http.dart' as http;
import '../models/workout_dao.dart';
import 'dart:convert';
import '../variables.dart' as global;
import '../models/workout.dart';

class WorkoutRequest {
  bool success;
  List<Workout> data;

  WorkoutRequest({this.success, this.data});

  WorkoutRequest.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<Workout>();

      try {
        json['data'].forEach((v) => data.add(new Workout.fromJson(v)));
      } catch (e) {
        //TODO: check if the data in a list is null (that throws exeption)
        data.add(new Workout.fromJson(json['data']));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static Future<WorkoutRequest> fetchWorkouts() async {
    try {
      final response = await http.get(
          'http://${global.serverIp}:2000/api/workouts-for-client/${global.userId}');
      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON.
        return WorkoutRequest.fromJson(jsonDecode(response.body));
      } else {
        // If that response was not OK, throw an error.
        print('Failed to load Workouts');
        return WorkoutRequest(
          success: false,
          data: null,
        );
      }
    } catch (e) {
      print(e);
      return WorkoutRequest(
        success: false,
        data: await WorkoutDao().getAllData(),
      );
    }
  }

  static Future<WorkoutRequest> createWorkout(Workout workout) async {
    Map<String, String> headers = {'Content-type': 'application/json'};
    String body;
      body = jsonEncode(workout.toJson());
    try {
      final response = await http.post(
        'http://${global.serverIp}:2000/api/create-workout/',
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON.
        WorkoutRequest request =
            WorkoutRequest.fromJson(jsonDecode(response.body));
        await WorkoutDao().insert(request.data.first);
        return request;
      } else {
        // If that response was not OK, throw an error.
        print(response.body);
        return WorkoutRequest(
          success: false,
          data: null,
        );
      }
    } catch (e) {
      print(e);
      List<Workout> list = await WorkoutDao().insert(workout);
      print('catch ' + list.first.toJson().toString());

      return WorkoutRequest(
        success: false,
        data: list,
      );
    }
  }
}
