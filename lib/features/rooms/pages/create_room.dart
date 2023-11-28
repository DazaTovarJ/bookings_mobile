import 'package:bookings_app/auth_check.dart';
import 'package:bookings_app/features/rooms/domain/rooms_service.dart';
import 'package:bookings_app/features/rooms/model/room.dart';
import 'package:bookings_app/shared/main_layout.dart';
import 'package:flutter/material.dart';

class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({super.key});

  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  final RoomService _roomService = RoomService();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _roomNumberController = TextEditingController();
  final _roomTypeController = TextEditingController();
  final _roomValueController = TextEditingController();

  Future<void> _saveRoom() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Room room = Room(
        roomNumber: _roomNumberController.text,
        type: _roomTypeController.text,
        value: double.parse(_roomValueController.text),
      );

      var response = await _roomService.createRoom(room);

      if (!context.mounted) return;
      if (response.code == 401) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginCheck(),
          ),
        );
        return;
      }

      _showDialog(
        response.message,
        response.code == 201 ? "success" : "error",
      );
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
                type == "success"
                    ? Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainLayout(
                            initialPage: 1,
                          ),
                        ),
                        (route) => false)
                    : Navigator.pop(context);
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear habitación'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  TextFormField(
                    controller: _roomNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Número de habitación',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el número de habitación';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _roomTypeController,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de habitación',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el tipo de la habitación';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _roomValueController,
                    decoration: const InputDecoration(
                      labelText: 'Precio',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el precio de la habitación';
                      }

                      if (double.tryParse(value) == null) {
                        return 'Por favor ingrese un número válido';
                      }

                      if (double.parse(value) <= 0) {
                        return 'Por favor ingrese un número mayor a 0';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: FilledButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });
                        _saveRoom().then((value) {
                          setState(() {
                            _isLoading = false;
                          });
                        });
                      }
                    },
              child: const Text('Guardar'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _roomNumberController.dispose();
    _roomTypeController.dispose();
    _roomValueController.dispose();
    super.dispose();
  }
}
