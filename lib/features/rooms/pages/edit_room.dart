import 'package:bookings_app/features/rooms/model/room.dart';
import 'package:flutter/material.dart';

class EditRoomPage extends StatefulWidget {
  const EditRoomPage({super.key, required this.room});
  final Room room;

  @override
  State<EditRoomPage> createState() => _EditRoomPageState();
}

class _EditRoomPageState extends State<EditRoomPage> {
  final _formKey = GlobalKey<FormState>();

  final _roomNumberController = TextEditingController();
  final _roomTypeController = TextEditingController();
  final _roomValueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _roomNumberController.text = widget.room.roomNumber;
    _roomTypeController.text = widget.room.type;
    _roomValueController.text = widget.room.value.toString();
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
                        return 'Por favor ingrese la descripción de la habitación';
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
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Procesando datos')),
                  );
                }
              },
              child: const Text('Editar'),
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
