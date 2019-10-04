import 'package:trainer_app_flutter/models/exercise.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  static Future<ExerciseRequest> fetchExercises(List<String> exerciseList) async {
    Map<String, String> headers = {'Content-type': 'application/json'};
    var body = listToJson(exerciseList);
    // print(body);
    final response = await http.post('http://195.249.188.75:2000/api/exercise-list/', headers: headers, body: body);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return ExerciseRequest.fromJson(jsonDecode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception(response.body);
    }
  }

  static Future<ExerciseRequest> fetchExercise(String exerciseId) async {
    final response = await http.get('http://195.249.188.75:2000/api/exercise/$exerciseId');
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return ExerciseRequest.fromJson(jsonDecode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception(response.body);
    }
  }

  static String listToJson (List<String> list) {
    String sList = '[';
    for (var i = 0; i < list.length-1; i++) {
      sList = sList + '"' + list[i] + '",';
    }
    sList += '"' + list.last + '"' + ']';
    return sList;
  }
}