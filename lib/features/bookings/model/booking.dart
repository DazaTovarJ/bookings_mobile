import 'package:bookings_app/features/rooms/model/room.dart';

class Booking {
  final int? id;
  final String clientName;
  final String clientPhone;
  final DateTime bookingDate;
  final DateTime start;
  final DateTime end;
  final Room room;

  Booking({
    this.id,
    required this.clientName,
    required this.clientPhone,
    required this.bookingDate,
    required this.start,
    required this.end,
    required this.room,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      clientName: json['client_name'],
      clientPhone: json['client_phone'],
      bookingDate: DateTime.parse(json['booking_date']),
      start: DateTime.parse(json['entry_date']),
      end: DateTime.parse(json['end_date']),
      room: Room.fromJson(json['room']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'client_name': clientName,
    'client_phone': clientPhone,
    'booking_date': bookingDate.toIso8601String(),
    'entry_date': start.toIso8601String(),
    'end_date': end.toIso8601String(),
    'room': room.toJson(),
  };
}