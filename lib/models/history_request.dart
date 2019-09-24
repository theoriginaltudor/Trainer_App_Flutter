import 'package:trainer_app_flutter/models/history.dart';

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
}