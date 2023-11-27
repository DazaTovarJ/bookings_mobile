import 'dart:convert';

import 'package:bookings_app/features/rooms/model/room.dart';
import 'package:bookings_app/shared/api_config.dart';
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

  Future<List<Room>> getAllRooms() async {
    await _getCredentials();
    final response = await _httpClient.get(
      _apiConfig.getResourceUri("rooms"),
      headers: {'Authorization': "Bearer $_accessToken"},
    );

    var res = json.decode(response.body) as Map<String, dynamic>;

    var roomsData = res["data"];

    return roomsData.map<Room>((room) {
      return Room.fromJson(room);
    }).toList();
  }

  Future<Room> getRoom(int id) async {
    await _getCredentials();
    final response = await _httpClient.get(
      _apiConfig.getUniqueResourceUri("rooms", id.toString()),
      headers: {'Authorization': "Bearer $_accessToken"},
    );

    var res = json.decode(response.body) as Map<String, dynamic>;

    Map<String, dynamic> roomsData = res["data"];
    return Room.fromJson(roomsData);
  }

  Future<Map<String, dynamic>> createRoom(Room room) async {
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

    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateRoom(Room room) async {
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

    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteRoom(int id) async {
    await _getCredentials();
    final response = await _httpClient.delete(
      _apiConfig.getUniqueResourceUri("rooms", id.toString()),
      headers: {'Authorization': "Bearer $_accessToken"},
    );

    return json.decode(response.body) as Map<String, dynamic>;
  }
}
