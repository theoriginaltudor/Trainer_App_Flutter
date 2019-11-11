import 'package:http/http.dart' as http;
import 'dart:convert';
import '../variables.dart' as global;

class UserRequest {
  bool success;
  List<User> data;

  UserRequest({
    this.success,
    this.data,
  });

  UserRequest.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<User>();
      json['data'].forEach((v) {
        data.add(new User.fromJson(v));
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

  static Future<UserRequest> fetchUserId(String email) async {
    final response =
        await http.get('http://${global.serverIp}:2000/api/client-id/$email');
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return UserRequest.fromJson(jsonDecode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception(response.body);
    }
  }
}

class User {
  String sId;
  String email;
  String trainerID;

  User({
    this.sId,
    this.email,
    this.trainerID,
  });

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    trainerID = json['trainerID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['email'] = this.email;
    data['trainerID'] = this.trainerID;
    return data;
  }
}
