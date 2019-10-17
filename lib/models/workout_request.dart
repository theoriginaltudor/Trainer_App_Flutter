import 'package:http/http.dart' as http;
import 'dart:convert';
import '../variables.dart' as global;
import 'package:trainer_app_flutter/models/workout.dart';

class WorkoutRequest {
  bool success;
  List<Workout> data;

  WorkoutRequest({this.success, this.data});

  WorkoutRequest.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<Workout>();
      
      try {
        json['data'].forEach((v) {
          data.add(new Workout.fromJson(v));
        });
      } catch (e) {
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
    final response = await http.get('http://${global.serverIp}:2000/api/workouts-for-client/${global.userId}');
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return WorkoutRequest.fromJson(jsonDecode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load Workouts');
    }
  }

  static Future<WorkoutRequest> createWorkout(Workout workout) async {
    Map<String, String> headers = {'Content-type': 'application/json'};
    String body = jsonEncode(workout.toJson());
    final response = await http.post('http://${global.serverIp}:2000/api/create-workout/', headers: headers, body: body);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return WorkoutRequest.fromJson(jsonDecode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception(response.body);
    }
  }
}