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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ApiResponse<List<Booking>>>(
        future: _bookings,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var response = snapshot.data!;

            if (response.code == 401) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginCheck(),
                ),
              );
            } else if (response.data!.isEmpty) {
              return const Center(
                child: Text("No se encontraron reservas. Crea una nueva"),
              );
            } else {
              var bookings = response.data!;
              return ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  var booking = bookings[index];
                  return BookingCard(
                    booking: booking,
                  );
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
}

class BookingCard extends StatelessWidget {
  const BookingCard({super.key, required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
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
                onPressed: () {},
                child: const Text("Eliminar"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
