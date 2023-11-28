import 'dart:convert';

import 'package:bookings_app/features/users/model/user.dart';
import 'package:bookings_app/shared/api_config.dart';
import 'package:bookings_app/shared/api_response.dart';
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
      headers: {'Authorization': "Bearer $accessToken"},
    );

    var res = json.decode(response.body) as Map<String, dynamic>;

    List<Map<String, dynamic>> userData = res["data"];
    return userData.map((user) => User.fromJson(user)).toList();
  }

  Future<ApiResponse<User>> getUser(int id) async {
    final response = await _httpClient.get(
      _apiConfig.getUniqueResourceUri("users", id.toString()),
      headers: {'Authorization': "Bearer $accessToken"},
    );
    final apiResponse = ApiResponse<User>();
    var res = json.decode(response.body) as Map<String, dynamic>;

    apiResponse.code = res["code"];

    if (response.statusCode == 200) {
      apiResponse.data = User.fromJson(res["data"]);
    }

    apiResponse.message = res["message"];

    return apiResponse;
  }

  Future<Map<String, dynamic>> updateUser(User user) async {
    final response = await _httpClient.patch(
      _apiConfig.getUniqueResourceUri('users', user.id.toString()),
      headers: {'Authorization': "Bearer $accessToken"},
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
      },
    );

    return json.decode(response.body) as Map<String, dynamic>;
  }
}
