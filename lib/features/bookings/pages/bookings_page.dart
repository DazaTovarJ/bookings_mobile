import 'package:bookings_app/auth_check.dart';
import 'package:bookings_app/features/bookings/domain/bookings_service.dart';
import 'package:bookings_app/features/bookings/model/booking.dart';
import 'package:bookings_app/features/bookings/pages/bookings_create.dart';
import 'package:bookings_app/features/bookings/pages/edit_booking.dart';
import 'package:bookings_app/shared/api_response.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  late Future<ApiResponse<List<Booking>>> _bookings;
  final BookingsService _bookingsService = BookingsService();

  @override
  void initState() {
    super.initState();
    var response = _bookingsService.getBookings();
    _bookings = response;
  }

  void _showDeleteConfirmationAlert(Booking booking) {
    var theme = Theme.of(context);

    Widget yesButton = TextButton(
      onPressed: () {
        deleteBooking(booking.id!).then((value) {
          setState(() {
            _bookings = _bookingsService.getBookings();
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
      title: const Text("Eliminación de reserva"),
      content: Text(
          "¿Está seguro que desea eliminar la reserva de ${booking.clientName}?"),
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

  Future<void> deleteBooking(int id) async {
    try {
      final response = await _bookingsService.deleteBooking(id);

      _showDialog(response.message, response.code == 200 ? "success" : "error");
    } catch (e) {
      _showDialog("Error al eliminar la habitación", "error");
    }
  }

  void _showDialog(String message, String type) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ApiResponse<List<Booking>>>(
        future: _bookings,
        builder: (context, snapshot) {
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
                      Symbols.calendar_add_on,
                      size: 100,
                    ),
                    Text("No se encontraron reservas. Crea una nueva"),
                  ],
                ),
              );
            } else {
              var bookings = response.data!;
              return ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  var booking = bookings[index];
                  return _buildBookingCard(context, booking: booking);
                },
              );
            }
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return const Center(
              child: Text("Ocurrió un error al cargar la lista de reservas."),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BookingsCreate(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, {required Booking booking}) {
    var theme = Theme.of(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: ElevationOverlay.applySurfaceTint(
          theme.colorScheme.surface,
          theme.colorScheme.surfaceTint,
          1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(booking.clientName, style: theme.textTheme.titleLarge),
          const SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: theme.colorScheme.surfaceVariant,
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Symbols.date_range,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "${DateFormat('dd/MM/yyyy').format(booking.start)} - "
                      "${DateFormat('dd/MM/yyyy').format(booking.end)}",
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Symbols.hotel,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "${booking.room.roomNumber} - ${booking.room.type}",
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditBookingPage(booking: booking),
                    ),
                  );
                },
                child: const Text("Editar"),
              ),
              TextButton(
                onPressed: () {
                  _showDeleteConfirmationAlert(booking);
                },
                child: const Text("Eliminar"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
