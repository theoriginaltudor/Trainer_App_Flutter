import '../models/history.dart';
import 'package:http/http.dart' as http;
import '../models/history_dao.dart';
import 'dart:convert';
import '../variables.dart' as global;

class HistoryRequest {
  bool success;
  List<History> data;

  HistoryRequest({this.success, this.data});

  HistoryRequest.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<History>();
      try {
        json['data'].forEach((v) {
          data.add(new History.fromJson(v));
        });
      } catch (e) {
        data.add(new History.fromJson(json['data']));
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

  static Future<HistoryRequest> fetchHistoryExercise(String exerciseId) async {
    try {
      final response = await http.get(
          'http://${global.serverIp}:2000/api/history-for-trainer/${global.userId}/for-exercise/$exerciseId');
      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON.
        return HistoryRequest.fromJson(jsonDecode(response.body));
      } else {
        // If that response was not OK, throw an error.
        print(response.body);
        return HistoryRequest(
          success: false,
          data: null,
        );
      }
    } catch (e) {
      print(e);
      return HistoryRequest(
        success: false,
        data: await HistoryDao().getHistoryForExercise(exerciseId),
      );
    }
  }

  static Future<HistoryRequest> fetchHistoryWorkout(String workoutId) async {
    try {
      final response = await http.get(
          'http://${global.serverIp}:2000/api/history-for-client/${global.userId}/for-workout/$workoutId');
      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON.
        return HistoryRequest.fromJson(jsonDecode(response.body));
      } else {
        // If that response was not OK, throw an error.
        print(response.body);
        return HistoryRequest(
          success: false,
          data: null,
        );
      }
    } catch (e) {
      print(e);
      return HistoryRequest(
        success: false,
        data: await HistoryDao().getHistoryForWorkout(workoutId),
      );
    }
  }

  static Future<HistoryRequest> postHistoryEntry(
    String workoutId,
    String exerciseId,
    History entry,
  ) async {
    Map<String, String> headers = {'Content-type': 'application/json'};
    String body;
      body = jsonEncode(entry.toJson());
    try {
      final response = await http.post(
        'http://${global.serverIp}:2000/api/new-history-entry/${global.userId}/$workoutId/$exerciseId',
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON.
        HistoryRequest request = HistoryRequest.fromJson(jsonDecode(response.body));
        await HistoryDao().insert(request.data.first);
        return request;
      } else {
        // If that response was not OK, throw an error.
        print(response.body);
        return HistoryRequest(
          success: false,
          data: null,
        );
      }
    } catch (e) {
      print(e);
      entry.exerciseId = exerciseId;
      entry.workoutId = workoutId;
      entry.clientId = global.userId;
      List<History> list = await HistoryDao().insert(entry);
      print('catch ' + list.first.toJson().toString());

      return HistoryRequest(
        success: false,
        data: list,
      );
    }
  }
}
