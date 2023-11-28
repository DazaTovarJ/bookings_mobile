import 'dart:convert';

import 'package:bookings_app/features/rooms/model/room.dart';
import 'package:bookings_app/shared/api_config.dart';
import 'package:bookings_app/shared/api_response.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoomRepository {
  final Client _httpClient = Client();
  final ApiConfig _apiConfig = ApiConfig();
  late String _accessToken;

  _getCredentials() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    _accessToken = prefs.getString('token')!;
  }

  Future<ApiResponse<List<Room>>> getAllRooms() async {
    await _getCredentials();
    final response = await _httpClient.get(
      _apiConfig.getResourceUri("rooms"),
      headers: {'Authorization': "Bearer $_accessToken"},
    );

    var res = json.decode(response.body) as Map<String, dynamic>;

    final apiResponse = ApiResponse<List<Room>>();

    apiResponse.code = res["code"];
    apiResponse.message = res["message"];

    if (response.statusCode == 200) {
      var roomsData = res["data"];
      apiResponse.data =
          roomsData.map<Room>((room) => Room.fromJson(room)).toList();
    }
    return apiResponse;
  }

  Future<ApiResponse<Room>> getRoom(int id) async {
    await _getCredentials();
    final response = await _httpClient.get(
      _apiConfig.getUniqueResourceUri("rooms", id.toString()),
      headers: {'Authorization': "Bearer $_accessToken"},
    );

    var res = json.decode(response.body) as Map<String, dynamic>;
    final apiResponse = ApiResponse<Room>();

    apiResponse.code = res["code"];
    apiResponse.message = res["message"];

    if (response.statusCode == 200) {
      var roomData = res["data"];
      apiResponse.data = Room.fromJson(roomData);
    }

    return apiResponse;
  }

  Future<ApiResponse> createRoom(Room room) async {
    await _getCredentials();
    final response = await _httpClient.post(
      _apiConfig.getResourceUri('rooms'),
      headers: {'Authorization': "Bearer $_accessToken"},
      body: {
        'room_number': room.roomNumber,
        'room_type': room.type,
        'room_value': room.value.toString(),
      },
    );
    var res = json.decode(response.body) as Map<String, dynamic>;
    final apiResponse = ApiResponse();

    apiResponse.code = res["code"];
    apiResponse.message = res["message"];

    return apiResponse;
  }

  Future<ApiResponse> updateRoom(Room room) async {
    await _getCredentials();
    final response = await _httpClient.patch(
      _apiConfig.getUniqueResourceUri('rooms', room.id.toString()),
      headers: {'Authorization': "Bearer $_accessToken"},
      body: {
        'room_number': room.roomNumber,
        'room_type': room.type,
        'room_value': room.value.toString(),
      },
    );
    var res = json.decode(response.body) as Map<String, dynamic>;
    final apiResponse = ApiResponse();

    apiResponse.code = res["code"];
    apiResponse.message = res["message"];

    return apiResponse;
  }

  Future<ApiResponse> deleteRoom(int id) async {
    await _getCredentials();
    final response = await _httpClient.delete(
      _apiConfig.getUniqueResourceUri("rooms", id.toString()),
      headers: {'Authorization': "Bearer $_accessToken"},
    );

    var res = json.decode(response.body) as Map<String, dynamic>;
    final apiResponse = ApiResponse();

    apiResponse.code = res["code"];
    apiResponse.message = res["message"];

    return apiResponse;
  }
}
