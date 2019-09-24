import 'package:trainer_app_flutter/models/exercise.dart';

class ExerciseRequest {
  bool success;
  List<Exercise> data;

  ExerciseRequest({this.success, this.data});

  ExerciseRequest.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<Exercise>();
      json['data'].forEach((v) {
        data.add(new Exercise.fromJson(v));
      });
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
}