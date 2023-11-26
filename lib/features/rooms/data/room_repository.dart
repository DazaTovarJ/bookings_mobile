import 'dart:convert';

import 'package:bookings_app/features/rooms/model/room.dart';
import 'package:bookings_app/shared/api_config.dart';
import 'package:http/http.dart';

class RoomRepository {
  final Client _httpClient = Client();
  final ApiConfig _apiConfig = ApiConfig();

  Future<List<Room>> getAllRooms() async {
    final response = await _httpClient.get(
      _apiConfig.getResourceUri("rooms"),
      headers: {
        'Authorization': "Bearer <token>"
      }, // TODO: Diseñar guardado del token
    );

    var res = json.decode(response.body) as Map<String, dynamic>;

    List<Map<String, dynamic>> roomsData = res["data"];
    return roomsData.map((booking) => Room.fromJson(booking)).toList();
  }

  Future<Room> getRoom(int id) async {
    final response = await _httpClient.get(
      _apiConfig.getUniqueResourceUri("rooms", id.toString()),
      headers: {
        'Authorization': "Bearer <token>"
      }, // TODO: Diseñar guardado del token
    );

    var res = json.decode(response.body) as Map<String, dynamic>;

    Map<String, dynamic> roomsData = res["data"];
    return Room.fromJson(roomsData);
  }

  Future<Map<String, dynamic>> createRoom(Room room) async {
    final response = await _httpClient.post(
      _apiConfig.getResourceUri('rooms'),
      headers: {'Authorization': "Bearer <token>"},
      // TODO: Diseñar guardado del token
      body: {
        'room_number': room.roomNumber,
        'room_type': room.type,
        'room_value': room.value.toString(),
      },
    );

    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateRoom(Room room) async {
    final response = await _httpClient.patch(
      _apiConfig.getUniqueResourceUri('rooms', room.id.toString()),
      headers: {'Authorization': "Bearer <token>"},
      // TODO: Diseñar guardado del token
      body: {
        'room_number': room.roomNumber,
        'room_type': room.type,
        'room_value': room.value.toString(),
      },
    );

    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteRoom(int id) async {
    final response = await _httpClient.delete(
      _apiConfig.getUniqueResourceUri("rooms", id.toString()),
      headers: {
        'Authorization': "Bearer <token>"
      }, // TODO: Diseñar guardado del token
    );

    return json.decode(response.body) as Map<String, dynamic>;
  }
}
