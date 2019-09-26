import 'package:trainer_app_flutter/models/history.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoryRequest {
  bool success;
  List<History> data;

  HistoryRequest({this.success, this.data});

  HistoryRequest.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<History>();
      json['data'].forEach((v) {
        data.add(new History.fromJson(v));
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

  static Future<HistoryRequest> fetchHistory(String exerciseId, String workoutId) async {
    final response = await http.get('http://195.249.188.75:2000/api/history-for-workout/$workoutId/for-exercise/$exerciseId');
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return HistoryRequest.fromJson(jsonDecode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception(response.body);
    }
  }
}