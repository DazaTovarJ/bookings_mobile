import 'dart:convert';

import 'package:bookings_app/features/bookings/model/booking.dart';
import 'package:bookings_app/shared/api_config.dart';
import 'package:http/http.dart';

class BookingsRepository {
  final Client _httpClient = Client();
  final ApiConfig _apiConfig = ApiConfig();

  Future<Map<String, dynamic>> createBooking(Booking booking) async {
    final response = await _httpClient.post(
      _apiConfig.getResourceUri('bookings'),
      headers: {'Authorization': "Bearer <token>"},
      // TODO: Diseñar guardado del token
      body: {
        'name': booking.clientName,
        'phone': booking.clientPhone,
        'booking_date': booking.bookingDate.toIso8601String(),
        'check_in': booking.start.toIso8601String(),
        'check_out': booking.end.toIso8601String(),
        'room': booking.room.id.toString(),
      },
    );

    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateBooking(Booking booking) async {
    final response = await _httpClient.patch(
      _apiConfig.getUniqueResourceUri('bookings', booking.id.toString()),
      headers: {'Authorization': "Bearer <token>"},
      // TODO: Diseñar guardado del token
      body: {
        'name': booking.clientName,
        'phone': booking.clientPhone,
        'booking_date': booking.bookingDate.toIso8601String(),
        'check_in': booking.start.toIso8601String(),
        'check_out': booking.end.toIso8601String(),
        'room': booking.room.id.toString(),
      },
    );

    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteBooking(int id) async {
    final response = await _httpClient.delete(
      _apiConfig.getUniqueResourceUri("bookings", id.toString()),
      headers: {
        'Authorization': "Bearer <token>"
      }, // TODO: Diseñar guardado del token
    );

    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<List<Booking>> getAllBookings() async {
    final response = await _httpClient.delete(
      _apiConfig.getResourceUri("bookings"),
      headers: {
        'Authorization': "Bearer <token>"
      }, // TODO: Diseñar guardado del token
    );

    var res = json.decode(response.body) as Map<String, dynamic>;

    List<Map<String, dynamic>> bookingsData =  res["data"];
    return bookingsData.map((booking) => Booking.fromJson(booking)).toList();
  }

  Future<Booking> getBooking(int id) async {
    final response = await _httpClient.delete(
      _apiConfig.getUniqueResourceUri("bookings", id.toString()),
      headers: {
        'Authorization': "Bearer <token>"
      }, // TODO: Diseñar guardado del token
    );

    var res = json.decode(response.body) as Map<String, dynamic>;

    Map<String, dynamic> bookingsData =  res["data"];
    return Booking.fromJson(bookingsData);
  }
}
