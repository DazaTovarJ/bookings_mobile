import 'package:bookings_app/features/rooms/data/room_repository.dart';
import 'package:bookings_app/features/rooms/model/room.dart';

class RoomService {
  final RoomRepository _roomRepository = RoomRepository();

  Future<List<Room>> getRooms() async {
    return await _roomRepository.getAllRooms();
  }
}