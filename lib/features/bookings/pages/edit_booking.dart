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

class EditBookingPage extends StatefulWidget {
  const EditBookingPage({super.key, required this.booking});

  final Booking booking;

  @override
  State<EditBookingPage> createState() => _EditBookingPageState();
}

class _EditBookingPageState extends State<EditBookingPage> {
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

    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    rooms = _roomService.getRooms();
    nameCtrl.text = widget.booking.clientName;
    phoneCtrl.text = widget.booking.clientPhone;
    bookingdateCtrl.text = dateFormat.format(widget.booking.bookingDate);
    checkinCtrl.text = dateFormat.format(widget.booking.start);
    checkoutCtrl.text = dateFormat.format(widget.booking.end);
    roomCtrl.text = "${widget.booking.room.roomNumber} - ${widget.booking.room.type}";
    selectedRoom = widget.booking.room;
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
        title: const Text("Editar Reserva"),
      ),
      body: FutureBuilder<ApiResponse<List<Room>>>(
        future: rooms,
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
                              _showDatePicker(bookingdateCtrl, widget.booking.bookingDate);
                            },
                            validator: (value) {
                              DateFormat format = DateFormat('dd/MM/yyyy');
                              if (value == null || value.isEmpty) {
                                return "Por favor, ingrese la fecha de reserva";
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
                              _showDatePicker(checkinCtrl, widget.booking.start);
                            },
                            validator: (value) {
                              DateFormat format = DateFormat('dd/MM/yyyy');
                              if (value == null || value.isEmpty) {
                                return "Por favor, ingrese la fecha de inicio de la"
                                    " reserva";
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
                              _showDatePicker(checkoutCtrl, widget.booking.end);
                            },
                            validator: (value) {
                              DateFormat format = DateFormat('dd/MM/yyyy');
                              if (value == null || value.isEmpty) {
                                return "Por favor, ingrese la fecha de cierre de la"
                                    " reserva";
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
                            widget.booking.room,
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
                                updateBooking().then((value) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                });
                              }
                            },
                      child: const Text("Editar"),
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

  Widget _buildDropdownMenu(BuildContext context, Room initial, List<Room> items,
      String label, Icon leadingIcon, TextEditingController ctrl) {
    return FormField<Room>(
      initialValue: initial,
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
            initialSelection: initial,
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

  Future<void> _showDatePicker(TextEditingController ctrl, DateTime originalDate) async {
    DateFormat format = DateFormat('dd/MM/yyyy');
    DateTime initialDate = ctrl.text.isEmpty ? DateTime.now() : format.parse(ctrl.text);
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: originalDate,
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        ctrl.text = format.format(date);
      });
    }
  }

  Future<void> updateBooking() async {
    try {
      DateFormat format = DateFormat('dd/MM/yyyy');

      String name = nameCtrl.text;
      String phone = phoneCtrl.text;
      DateTime bookingDate = format.parse(bookingdateCtrl.text);
      DateTime checkin = format.parse(checkinCtrl.text);
      DateTime checkout = format.parse(checkoutCtrl.text);
      Room room = selectedRoom!;
      final response = await _bookingsService.updateBooking(Booking(
          id: widget.booking.id,
          clientName: name,
          clientPhone: phone,
          bookingDate: bookingDate,
          start: checkin,
          end: checkout,
          room: room));

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
        message: response.message,
        type: response.code == 200 ? "success" : "error",
      );
    } catch (e) {
      _showDialog(
        message: "Error al editar la reserva",
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
