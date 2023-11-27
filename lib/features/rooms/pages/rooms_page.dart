import 'package:bookings_app/features/rooms/domain/rooms_service.dart';
import 'package:bookings_app/features/rooms/model/room.dart';
import 'package:bookings_app/features/rooms/pages/create_room.dart';
import 'package:flutter/material.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({super.key});

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  final RoomService _roomService = RoomService();

  late Future<List<Room>> _rooms;

  @override
  void initState() {
    super.initState();
    _rooms = _roomService.getRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _rooms,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print(snapshot.error);
            return const Center(child: Text('Error al obtener las habitaciones'));
          }

          var rooms = snapshot.data;
          return ListView.builder(
            itemCount: rooms!.length,
            itemBuilder: (context, index) {
              var room = rooms[index];
              return Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Column(
                        children: [
                          const Icon(Icons.hotel),
                          Text(room.roomNumber),
                        ],
                      ),
                      title: Text("Habitación ${room.roomNumber}"),
                      subtitle: Text('Clase: ${room.type}'),
                      trailing: Text("\$${room.value}"),
                    ),
                    ButtonBar(
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text('Editar'),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Eliminar'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateRoomPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
