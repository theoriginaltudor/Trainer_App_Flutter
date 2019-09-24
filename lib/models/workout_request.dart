import 'package:trainer_app_flutter/models/workout.dart';

class WorkoutRequest {
  bool success;
  List<Workout> data;

  WorkoutRequest({this.success, this.data});

  WorkoutRequest.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<Workout>();
      json['data'].forEach((v) {
        data.add(new Workout.fromJson(v));
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