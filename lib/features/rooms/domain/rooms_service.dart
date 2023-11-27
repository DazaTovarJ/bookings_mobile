import 'package:bookings_app/features/rooms/data/room_repository.dart';
import 'package:bookings_app/features/rooms/model/room.dart';

class RoomService {
  final RoomRepository _roomRepository = RoomRepository();

  Future<List<Room>> getRooms() async {
    return await _roomRepository.getAllRooms();
  }

  Future<Room> getRoom(int id) async {
    return await _roomRepository.getRoom(id);
  }

  Future<Map<String, dynamic>> createRoom(Room room) async {
    return await _roomRepository.createRoom(room);
  }

  Future<Map<String, dynamic>> updateRoom(Room room) async {
    return await _roomRepository.updateRoom(room);
  }

  Future<Map<String, dynamic>> deleteRoom(int id) async {
    return await _roomRepository.deleteRoom(id);
  }
}