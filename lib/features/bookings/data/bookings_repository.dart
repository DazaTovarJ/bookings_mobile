import 'dart:convert';

import 'package:bookings_app/features/bookings/model/booking.dart';
import 'package:bookings_app/shared/api_config.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingsRepository {
  final Client _httpClient = Client();
  final ApiConfig _apiConfig = ApiConfig();
  late String _accessToken;

  Future<void> _getCredentials() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    _accessToken = prefs.getString('token')!;
  }

  Future<Map<String, dynamic>> createBooking(Booking booking) async {
    await _getCredentials();
    final response = await _httpClient.post(
      _apiConfig.getResourceUri('bookings'),
      headers: {'Authorization': "Bearer $_accessToken"},
      body: {
        'name': booking.clientName,
        'phone': booking.clientPhone,
        'booking_date': booking.bookingDate.toIso8601String(),
        'check_in': booking.start.toIso8601String(),
        'check_out': booking.end.toIso8601String(),
        'room': booking.room.toString(),
      },
    );

    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateBooking(Booking booking) async {
    await _getCredentials();
    final response = await _httpClient.patch(
      _apiConfig.getUniqueResourceUri('bookings', booking.id.toString()),
      headers: {'Authorization': "Bearer $_accessToken"},
      // TODO: Diseñar guardado del token
      body: {
        'name': booking.clientName,
        'phone': booking.clientPhone,
        'booking_date': booking.bookingDate.toIso8601String(),
        'check_in': booking.start.toIso8601String(),
        'check_out': booking.end.toIso8601String(),
        'room': booking.room.toString(),
      },
    );

    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteBooking(int id) async {
    await _getCredentials();
    final response = await _httpClient.delete(
      _apiConfig.getUniqueResourceUri("bookings", id.toString()),
      headers: {'Authorization': "Bearer $_accessToken"},
    );

    return json.decode(response.body) as Map<String, dynamic>;
  }

  Future<List<Booking>> getAllBookings() async {
    await _getCredentials();
    final response = await _httpClient.get(
      _apiConfig.getResourceUri("bookings"),
      headers: {'Authorization': "Bearer $_accessToken"},
    );

    var res = json.decode(response.body) as Map<String, dynamic>;

    var bookingsData = res["data"];

    return bookingsData
        .map<Booking>((booking) => Booking.fromJson(booking))
        .toList();
  }

  Future<Booking> getBooking(int id) async {
    await _getCredentials();
    final response = await _httpClient.get(
      _apiConfig.getUniqueResourceUri("bookings", id.toString()),
      headers: {'Authorization': "Bearer $_accessToken"},
    );

    var res = json.decode(response.body) as Map<String, dynamic>;

    Map<String, dynamic> bookingsData = res["data"];
    return Booking.fromJson(bookingsData);
  }
}
