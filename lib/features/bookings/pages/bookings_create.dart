import 'package:bookings_app/auth_check.dart';
import 'package:bookings_app/features/bookings/domain/bookings_service.dart';
import 'package:bookings_app/features/bookings/model/booking.dart';
import 'package:bookings_app/features/rooms/domain/rooms_service.dart';
import 'package:bookings_app/features/rooms/model/room.dart';
import 'package:bookings_app/shared/api_response.dart';
import 'package:bookings_app/shared/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

class BookingsCreate extends StatefulWidget {
  const BookingsCreate({super.key});

  @override
  State<BookingsCreate> createState() => _BookingsCreateState();
}

class _BookingsCreateState extends State<BookingsCreate> {
  final _formKey = GlobalKey<FormState>();

  late Future<ApiResponse<List<Room>>> rooms;
  bool _isLoading = false;
  Room? selectedRoom;

  TextEditingController nameCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController bookingdateCtrl = TextEditingController();
  TextEditingController checkinCtrl = TextEditingController();
  TextEditingController checkoutCtrl = TextEditingController();
  TextEditingController roomCtrl = TextEditingController();
  final RoomService _roomService = RoomService();
  final BookingsService _bookingsService = BookingsService();

  @override
  void initState() {
    super.initState();
    rooms = _roomService.getRooms();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    bookingdateCtrl.dispose();
    checkinCtrl.dispose();
    checkoutCtrl.dispose();
    roomCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar Reservas"),
      ),
      body: FutureBuilder<ApiResponse<List<Room>>>(
        future: rooms,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var response = snapshot.data!;

            if (response.code == 401) {
              showDialog(
                context: context,
                builder: (context) =>
                    LoginCheck.showLogoutNotification(context),
              );
            } else if (response.data!.isEmpty) {
              _showDialog(
                title: "Información",
                message: "No hay habitaciones disponibles.",
                type: "info",
              );
            } else {
              var availableRooms = response.data!;
              return Column(
                children: [
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        padding: const EdgeInsets.all(16.0),
                        children: [
                          TextFormField(
                            controller: nameCtrl,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Por favor, ingrese su nombre";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              filled: true,
                              prefixIcon: Icon(Symbols.person),
                              labelText: "Nombre",
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: phoneCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              filled: true,
                              prefixIcon: Icon(Symbols.phone),
                              labelText: "Teléfono",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Por favor, ingrese su número de teléfono";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: bookingdateCtrl,
                            readOnly: true,
                            keyboardType: TextInputType.datetime,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Symbols.calendar_today),
                              filled: true,
                              labelText: "Fecha de Reserva",
                            ),
                            onTap: () {
                              _showDatePicker(bookingdateCtrl);
                            },
                            validator: (value) {
                              DateFormat format = DateFormat('dd/MM/yyyy');
                              if (value == null || value.isEmpty) {
                                return "Por favor, ingrese la fecha de reserva";
                              }

                              if (format
                                  .parse(value)
                                  .isBefore(DateTime.now())) {
                                return "La fecha de reserva no puede ser menor a la"
                                    " fecha actual";
                              }

                              if (checkinCtrl.text.isNotEmpty &&
                                  checkoutCtrl.text.isNotEmpty) {
                                if (format
                                    .parse(value)
                                    .isAfter(format.parse(checkinCtrl.text))) {
                                  return "La fecha de reserva no puede ser mayor a su"
                                      " fecha de inicio";
                                }

                                if (format
                                    .parse(value)
                                    .isAfter(format.parse(checkoutCtrl.text))) {
                                  return "La fecha de reserva no puede ser mayor a su"
                                      " fecha de cierre";
                                }
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: checkinCtrl,
                            readOnly: true,
                            keyboardType: TextInputType.datetime,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Symbols.calendar_clock),
                              filled: true,
                              labelText: "Desde",
                            ),
                            onTap: () {
                              _showDatePicker(checkinCtrl);
                            },
                            validator: (value) {
                              DateFormat format = DateFormat('dd/MM/yyyy');
                              if (value == null || value.isEmpty) {
                                return "Por favor, ingrese la fecha de inicio de la"
                                    " reserva";
                              }

                              if (format
                                  .parse(value)
                                  .isBefore(DateTime.now())) {
                                return "La fecha de inicio no puede ser menor a la"
                                    " fecha actual";
                              }

                              if (checkoutCtrl.text.isNotEmpty) {
                                if (format
                                    .parse(value)
                                    .isAfter(format.parse(checkoutCtrl.text))) {
                                  return "La fecha de inicio no puede ser mayor a la"
                                      " fecha de cierre de la reserva";
                                }
                              }

                              if (bookingdateCtrl.text.isNotEmpty) {
                                if (format.parse(value).isBefore(
                                    format.parse(bookingdateCtrl.text))) {
                                  return "La fecha de inicio no puede ser menor a la"
                                      " fecha de reserva";
                                }
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: checkoutCtrl,
                            keyboardType: TextInputType.datetime,
                            readOnly: true,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Symbols.calendar_clock),
                              filled: true,
                              labelText: "Hasta",
                            ),
                            onTap: () {
                              _showDatePicker(checkoutCtrl);
                            },
                            validator: (value) {
                              DateFormat format = DateFormat('dd/MM/yyyy');
                              if (value == null || value.isEmpty) {
                                return "Por favor, ingrese la fecha de cierre de la"
                                    " reserva";
                              }

                              if (format
                                  .parse(value)
                                  .isBefore(DateTime.now())) {
                                return "La fecha de cierre no puede ser menor a la"
                                    " fecha actual";
                              }

                              if (format.parse(value).isBefore(
                                  format.parse(bookingdateCtrl.text))) {
                                return "La fecha de cierre no puede ser menor a la"
                                    " fecha de reserva";
                              }

                              if (format
                                  .parse(value)
                                  .isBefore(format.parse(checkinCtrl.text))) {
                                return "La fecha de cierre no puede ser menor a la"
                                    " fecha de inicio de la reserva";
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildDropdownMenu(
                            context,
                            availableRooms,
                            "Habitación",
                            const Icon(Symbols.hotel),
                            roomCtrl,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FilledButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });
                                createBooking().then((value) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                });
                              }
                            },
                      child: const Text("Registrar"),
                    ),
                  ),
                ],
              );
            }
          } else if (snapshot.hasError) {
            _showDialog(
              message: "No se pudo obtener la lista de habitaciones",
              type: "error",
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildDropdownMenu(BuildContext context, List<Room> items,
      String label, Icon leadingIcon, TextEditingController ctrl) {
    return FormField<Room>(
      validator: (value) {
        if (value == null) {
          return "Por favor, seleccione una habitación";
        }
        return null;
      },
      builder: (state) {
        return InputDecorator(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(0.0),
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              maxWidth: MediaQuery.of(context).size.width,
            ),
            errorText: state.errorText,
          ),
          child: DropdownMenu(
            controller: ctrl,
            label: Text(label),
            leadingIcon: leadingIcon,
            width: MediaQuery.of(context).size.width - 32,
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
            ),
            dropdownMenuEntries: items
                .map((e) => DropdownMenuEntry(
                      value: e,
                      label: "${e.roomNumber} - ${e.type}",
                    ))
                .toList(),
            onSelected: (value) {
              state.didChange(value);
              setState(() {
                selectedRoom = value;
              });
            },
          ),
        );
      },
    );
  }

  Future<void> _showDatePicker(TextEditingController ctrl) async {
    DateFormat format = DateFormat('dd/MM/yyyy');
    DateTime initialDate =
        ctrl.text.isEmpty ? DateTime.now() : format.parse(ctrl.text);
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        ctrl.text = format.format(date);
      });
    }
  }

  Future<void> createBooking() async {
    try {
      DateFormat format = DateFormat('dd/MM/yyyy');

      String name = nameCtrl.text;
      String phone = phoneCtrl.text;
      DateTime bookingDate = format.parse(bookingdateCtrl.text);
      DateTime checkin = format.parse(checkinCtrl.text);
      DateTime checkout = format.parse(checkoutCtrl.text);
      int room = selectedRoom!.id!;
      final response = await _bookingsService.createBooking(Booking(
          clientName: name,
          clientPhone: phone,
          bookingDate: bookingDate,
          start: checkin,
          end: checkout,
          room: room));

      if (!context.mounted) return;
      if (response.code == 401) {
        showDialog(
          context: context,
          builder: (context) => LoginCheck.showLogoutNotification(context),
        );
      }

      _showDialog(
        message: response.message,
        type: response.code == 201 ? "success" : "error",
      );
    } catch (e) {
      _showDialog(
        message: "Error al registrar la reserva",
        type: "error",
      );
    }
  }

  _showDialog({required String message, required String type, String? title}) {
    var theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(type == 'error' ? 'Error' : title ?? 'Éxito'),
          backgroundColor: type == 'error'
              ? theme.colorScheme.errorContainer
              : theme.dialogTheme.backgroundColor,
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                type == "error" || type == "warning"
                    ? Navigator.pop(context)
                    : Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainLayout(),
                        ),
                        (route) => false);
              },
              child: const Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }
}
