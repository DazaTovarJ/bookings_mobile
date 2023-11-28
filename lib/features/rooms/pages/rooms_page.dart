import 'package:bookings_app/auth_check.dart';
import 'package:bookings_app/features/rooms/domain/rooms_service.dart';
import 'package:bookings_app/features/rooms/model/room.dart';
import 'package:bookings_app/features/rooms/pages/create_room.dart';
import 'package:bookings_app/features/rooms/pages/edit_room.dart';
import 'package:bookings_app/shared/api_response.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({super.key});

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  final RoomService _roomService = RoomService();

  late Future<ApiResponse<List<Room>>> _rooms;

  void _showDeleteConfirmationAlert(Room room) {
    var theme = Theme.of(context);

    Widget yesButton = TextButton(
      onPressed: () {
        deleteRoom(room.id!).then((value) {
          setState(() {
            _rooms = _roomService.getRooms();
          });
        });
        Navigator.pop(context);
      },
      child: const Text("Sí"),
    );
    Widget noButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text("No"),
    );

    AlertDialog dialog = AlertDialog(
      backgroundColor: theme.colorScheme.errorContainer,
      title: const Text("Eliminación de habitación"),
      content: Text(
          "¿Está seguro que desea eliminar la habitación ${room.roomNumber}?"),
      actions: [
        yesButton,
        noButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

  Future<void> deleteRoom(int id) async {
    try {
      final response = await _roomService.deleteRoom(id);

      _showDialog(response.message, response.code == 200 ? "success" : "error");
    } catch (e) {
      _showDialog("Error al eliminar la habitación", "error");
    }
  }

  _showDialog(String message, String type) {
    var theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(type == 'error' ? 'Error' : 'Éxito'),
          backgroundColor: type == 'error'
              ? theme.colorScheme.errorContainer
              : theme.dialogTheme.backgroundColor,
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _rooms = _roomService.getRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ApiResponse<List<Room>>>(
          future: _rooms,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                  child: Text('Error al obtener las habitaciones'));
            }

            if (snapshot.hasData) {
              var response = snapshot.data!;
              if (response.code == 401) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginCheck(),
                    ),
                  );
                });
              } else if (response.code == 404 || response.data!.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Symbols.local_hotel,
                        size: 100,
                      ),
                      Text("No se encontraron habitaciones. Crea una nueva"),
                    ],
                  ),
                );
              } else {
                var rooms = response.data!;
                return ListView.builder(
                  itemCount: rooms.length,
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
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditRoomPage(room: room),
                                    ),
                                  );
                                },
                                child: const Text('Editar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _showDeleteConfirmationAlert(room);
                                },
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
            }

            return const Center(child: CircularProgressIndicator());
          }),
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
