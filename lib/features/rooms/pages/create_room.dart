import 'package:flutter/material.dart';

class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({super.key});

  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  final _formKey = GlobalKey<FormState>();

  final _roomNumberController = TextEditingController();
  final _roomTypeController = TextEditingController();
  final _roomValueController = TextEditingController();

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
