import 'package:http/http.dart' as http;
import 'package:vulpes/constant.dart';
import 'package:vulpes/models/task.dart';
import 'dart:convert';

import 'package:vulpes/models/user.dart';

// ignore: avoid_web_libraries_in_flutter

// var str = window.localStorage["csrf"];
// var jsontoken = json.decode(str as String);

// var token = jsontoken['token'].toString();

// var splitedtoken = str!.split(".");

// var payload =
//     json.decode(ascii.decode(base64.decode(base64.normalize(splitedtoken[1]))));

// var userID = payload["id"].toString();

class HttpService {
  Future<bool> getUserInfo(int id) async {
    final getUserInfoURL = '$baseURL/api/v1/users/$id/check_email';

    final response = await http.get(
      Uri.parse(getUserInfoURL),
      // Send authorization headers to the backend.
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(hours: 1));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return true;
    } else {
      return false;
      // If the server did not return a 200 OK response,
      // then throw an exception.
      // throw Exception('Failed to load Company');
    }
  }

  Future<bool> updateUserEmail(int id, String email) async {
    final updateUserEmail = '$baseURL/api/v1/users/$id/edit_email';
    final response = await http.put(
      Uri.parse(updateUserEmail),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
        // 'password': newpassword,
        // 'currentPassword': currentPassword,
      }),
    );
    if (response.statusCode == 201) {
      // print(response.body);
      return true;
    } else {
      // print(response.body);
      return false;
    }
  }

  Future<User?> getUser(int id) async {
    final getUserURL = '$baseURL/api/v1/users/$id';

    final response = await http.get(
      Uri.parse(getUserURL),
      // Send authorization headers to the backend.
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return User.fromJson(jsonDecode(response.body));
    } else {
      return null;
      // If the server did not return a 200 OK response,
      // then throw an exception.
      // throw Exception('Failed to load Company');
    }
  }

  Future<bool> startFarm(int id) async {
    final startFarmURL = '$baseURL/api/v1/users/$id/start_farm';
    final response = await http.post(
      Uri.parse(startFarmURL),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        // 'email': email,
        // 'password': newpassword,
        // 'currentPassword': currentPassword,
      }),
    );
    if (response.statusCode == 201) {
      // print(response.body);
      return true;
    } else {
      // print(response.body);
      return false;
    }
  }

  Future<bool> startTask(int id, String taskID) async {
    final startTaskURL = '$baseURL/api/v1/users/$id/tasks/$taskID/start_task';
    final response = await http.post(
      Uri.parse(startTaskURL),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        // 'email': email,
        // 'password': newpassword,
        // 'currentPassword': currentPassword,
      }),
    );
    if (response.statusCode == 201) {
      // print(response.body);
      return true;
    } else {
      // print(response.body);
      return false;
    }
  }

  Future<bool> claimReward(int id) async {
    final claimRewardURL = '$baseURL/api/v1/users/$id/claim';
    final response = await http.post(
      Uri.parse(claimRewardURL),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        <String, dynamic>{
          // 'email': email,
          // 'password': newpassword,
          // 'currentPassword': currentPassword,
        },
      ),
    );
    if (response.statusCode == 201) {
      // print(response.body);
      return true;
    } else {
      // print(response.body);
      return false;
    }
  }

  Future<List<Task>> getTasks(int id) async {
    final String usersDropDownURL = "$baseURL/api/v1/users/$id/tasks";

    final response = await http.get(
      Uri.parse(usersDropDownURL),
      // Send authorization headers to the backend.
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      var tasks =
          body["data"].map<Task>((json) => Task.fromJson(json)).toList();
      return tasks;
    } else {
      throw "Unable to retrieve tasks.";
    }
  }

  Future<bool> checkTask(int id, String taskID) async {
    final startTaskURL = '$baseURL/api/v1/users/$id/tasks/$taskID/check_task';
    final response = await http.post(
      Uri.parse(startTaskURL),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        // 'email': email,
        // 'password': newpassword,
        // 'currentPassword': currentPassword,
      }),
    );
    if (response.statusCode == 201) {
      // print(response.body);
      return true;
    } else {
      // print(response.body);
      return false;
    }
  }

  Future<bool> claimTask(int id, String taskID) async {
    final claimTaskURL = '$baseURL/api/v1/users/$id/tasks/$taskID/claim_task';
    final response = await http.post(
      Uri.parse(claimTaskURL),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        // 'email': email,
        // 'password': newpassword,
        // 'currentPassword': currentPassword,
      }),
    );
    if (response.statusCode == 201) {
      // print(response.body);
      return true;
    } else {
      // print(response.body);
      return false;
    }
  }
}
