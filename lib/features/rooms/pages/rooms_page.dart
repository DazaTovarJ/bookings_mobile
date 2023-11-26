import 'package:flutter/material.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({super.key});

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                ListTile(
                  leading: Column(
                    children: [
                      const Icon(Icons.hotel),
                      Text("E${index + 1}"),
                    ],
                  ),
                  title: Text('Habitación ${index + 1}'),
                  subtitle: Text('Descripción de la habitación ${index + 1}'),
                  trailing: const Text("S/. 100.00"),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
