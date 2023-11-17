import 'package:bookings_app/shared/api_config.dart';
import 'package:http/http.dart';

class BookingsRepository {
  final Client _httpClient = Client();
  final ApiConfig _apiConfig = ApiConfig();

  Future<void> createBooking(String clientName, String clientPhone,
      DateTime bookingDate, DateTime start, DateTime end, int roomId) async {
    final response = await _httpClient.post(
      _apiConfig.getResourceUri('bookings'),
      headers: {'Authorization': "Bearer <token>"},
      // TODO: Diseñar guardado del token
      body: {
        'name': clientName,
        'phone': clientPhone,
        'booking_date': bookingDate.toIso8601String(),
        'check_in': start.toIso8601String(),
        'check_out': end.toIso8601String(),
        'room': roomId.toString(),
      },
    );

    if (response.statusCode == 200) {
      print('Booking created');
    } else {
      throw Exception('Failed to create booking');
    }
  }

  Future<void> updateBooking(int id, String clientName, String clientPhone,
      DateTime bookingDate, DateTime start, DateTime end, int roomId) async {
    final response = await _httpClient.put(
      _apiConfig.getUniqueResourceUri('bookings', id.toString()),
      headers: {'Authorization': "Bearer <token>"},
      // TODO: Diseñar guardado del token
      body: {
        'name': clientName,
        'phone': clientPhone,
        'booking_date': bookingDate.toIso8601String(),
        'check_in': start.toIso8601String(),
        'check_out': end.toIso8601String(),
        'room': roomId.toString(),
      },
    );

    if (response.statusCode == 200) {
      print('Booking updated');
    } else {
      throw Exception('Failed to update booking');
    }
  }

  Future<void> deleteBooking(int id) async {
    final response = await _httpClient.delete(
      _apiConfig.getUniqueResourceUri("bookings", id.toString()),
      headers: {
        'Authorization': "Bearer <token>"
      }, // TODO: Diseñar guardado del token
    );

    if (response.statusCode == 200) {
      print('Booking updated');
    } else {
      throw Exception('Failed to update booking');
    }
  }

  Future<void> getAllBookings() async {
    final response = await _httpClient.delete(
      _apiConfig.getResourceUri("bookings"),
      headers: {
        'Authorization': "Bearer <token>"
      }, // TODO: Diseñar guardado del token
    );

    if (response.statusCode == 200) {
      print('Booking updated');
    } else {
      throw Exception('Failed to update booking');
    }
  }

  Future<void> getBooking(int id) async {
    final response = await _httpClient.delete(
      _apiConfig.getUniqueResourceUri("bookings", id.toString()),
      headers: {
        'Authorization': "Bearer <token>"
      }, // TODO: Diseñar guardado del token
    );

    if (response.statusCode == 200) {
      print('Booking updated');
    } else {
      throw Exception('Failed to update booking');
    }
  }
}
