import 'dart:convert';

import 'package:bookings_app/features/users/model/user.dart';
import 'package:bookings_app/shared/api_config.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final Client _httpClient = Client();
  final ApiConfig _apiConfig = ApiConfig();
  String accessToken = "";

  UserRepository() {
    SharedPreferences.getInstance().then((value) {
      accessToken = value.getString('token') ?? "";
    });
  }

  Future<List<User>> getAllUsers() async {
    final response = await _httpClient.get(
      _apiConfig.getResourceUri("users"),
      headers: {
        'Authorization': "Bearer $accessToken"
      },
    );

    var res = json.decode(response.body) as Map<String, dynamic>;

    List<Map<String, dynamic>> userData = res["data"];
    return userData.map((user) => User.fromJson(user)).toList();
  }

  Future<User> getUser(int id) async {
    final response = await _httpClient.get(
      _apiConfig.getUniqueResourceUri("users", id.toString()),
      headers: {
        'Authorization': "Bearer $accessToken"
      },
    );

    var res = json.decode(response.body) as Map<String, dynamic>;

    if (!res.containsKey("data") || res["data"] == null) {
      return Future.error("Usuario no encontrado");
    }

    Map<String, dynamic> userData = res["data"];
    return User.fromJson(userData);
  }

  Future<Map<String, dynamic>> updateUser(User user) async {
    final response = await _httpClient.patch(
      _apiConfig.getUniqueResourceUri('users', user.id.toString()),
      headers: {'Authorization': "Bearer $accessToken"},
      // TODO: Diseñar guardado del token
      body: {
        'firstName': user.givenName,
        'lastName': user.familyName,
        'email': user.email,
      },
    );

    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteUser(int id) async {
    final response = await _httpClient.delete(
      _apiConfig.getUniqueResourceUri("users", id.toString()),
      headers: {
        'Authorization': "Bearer $accessToken"
      }, // TODO: Diseñar guardado del token
    );

    return json.decode(response.body) as Map<String, dynamic>;
  }
}
