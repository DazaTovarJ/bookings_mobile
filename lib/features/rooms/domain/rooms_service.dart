import 'package:bookings_app/features/rooms/data/room_repository.dart';
import 'package:bookings_app/features/rooms/model/room.dart';
import 'package:bookings_app/shared/api_response.dart';

class RoomService {
  final RoomRepository _roomRepository = RoomRepository();

  Future<ApiResponse<List<Room>>> getRooms() async {
    return await _roomRepository.getAllRooms();
  }

  Future<ApiResponse<Room>> getRoom(int id) async {
    return await _roomRepository.getRoom(id);
  }

  Future<ApiResponse> createRoom(Room room) async {
    return await _roomRepository.createRoom(room);
  }

  Future<ApiResponse> updateRoom(Room room) async {
    return await _roomRepository.updateRoom(room);
  }

  Future<ApiResponse> deleteRoom(int id) async {
    return await _roomRepository.deleteRoom(id);
  }
}