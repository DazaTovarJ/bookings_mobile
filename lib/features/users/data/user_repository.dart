import 'dart:convert';

import 'package:bookings_app/features/users/model/user.dart';
import 'package:bookings_app/shared/api_config.dart';
import 'package:http/http.dart';

class RoomRepository {
  final Client _httpClient = Client();
  final ApiConfig _apiConfig = ApiConfig();

  Future<List<User>> getAllUsers() async {
    final response = await _httpClient.get(
      _apiConfig.getResourceUri("users"),
      headers: {
        'Authorization': "Bearer <token>"
      }, // TODO: Diseñar guardado del token
    );

    var res = json.decode(response.body) as Map<String, dynamic>;

    List<Map<String, dynamic>> userData = res["data"];
    return userData.map((user) => User.fromJson(user)).toList();
  }

  Future<User> getUser(int id) async {
    final response = await _httpClient.get(
      _apiConfig.getUniqueResourceUri("users", id.toString()),
      headers: {
        'Authorization': "Bearer <token>"
      }, // TODO: Diseñar guardado del token
    );

    var res = json.decode(response.body) as Map<String, dynamic>;

    Map<String, dynamic> roomsData = res["data"];
    return User.fromJson(roomsData);
  }

  Future<Map<String, dynamic>> updateUser(User user) async {
    final response = await _httpClient.patch(
      _apiConfig.getUniqueResourceUri('users', user.id.toString()),
      headers: {'Authorization': "Bearer <token>"},
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
        'Authorization': "Bearer <token>"
      }, // TODO: Diseñar guardado del token
    );

    return json.decode(response.body) as Map<String, dynamic>;
  }
}
