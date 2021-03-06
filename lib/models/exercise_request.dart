import '../models/exercise.dart';
import 'package:http/http.dart' as http;
import '../models/exercise_dao.dart';
import 'dart:convert';
import '../variables.dart' as global;

class ExerciseRequest {
  bool success;
  List<Exercise> data;

  ExerciseRequest({this.success, this.data});

  ExerciseRequest.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<Exercise>();
      try {
        json['data'].forEach((v) {
          data.add(new Exercise.fromJson(v));
        });
      } catch (e) {
        data.add(new Exercise.fromJson(json['data']));
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

  static Future<ExerciseRequest> fetchAllExercises() async {
    try {
      final response =
          await http.get('http://${global.serverIp}:2000/api/exercises/');
      if (response.statusCode == 200) {
        var request = ExerciseRequest.fromJson(jsonDecode(response.body));
        // If server returns an OK response, parse the JSON.
        return request;
      } else {
        // If that response was not OK, throw an error.
        print(response.body);
        return ExerciseRequest(
          success: false,
          data: null,
        );
      }
    } catch (error) {
      print(error);
      return ExerciseRequest(
          success: false, data: await ExerciseDao().getAllData());
    }
  }

  static Future<ExerciseRequest> fetchExercises(
      List<String> exerciseList) async {
    try {
      Map<String, String> headers = {'Content-type': 'application/json'};
      String body = jsonEncode(exerciseList);
      final response = await http.post(
        'http://${global.serverIp}:2000/api/exercise-list/',
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        var request = ExerciseRequest.fromJson(jsonDecode(response.body));
        // If server returns an OK response, parse the JSON.
        return request;
      } else {
        // If that response was not OK, throw an error.
        print(response.body);
        return ExerciseRequest(
          success: false,
          data: null,
        );
      }
    } catch (error) {
      print(error);
      return ExerciseRequest(
        success: false,
        data: await ExerciseDao().getExercises(exerciseList),
      );
    }
  }

  static Future<ExerciseRequest> fetchExercise(String exerciseId) async {
    try {
      final response = await http
          .get('http://${global.serverIp}:2000/api/exercise/$exerciseId');
      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON.
        return ExerciseRequest.fromJson(jsonDecode(response.body));
      } else {
        // If that response was not OK, throw an error.
        print(response.body);
        return ExerciseRequest(
          success: false,
          data: null,
        );
      }
    } catch (error) {
      print(error);
      return ExerciseRequest(
        success: false,
        data: await ExerciseDao().getExercise(exerciseId),
      );
    }
  }
}
