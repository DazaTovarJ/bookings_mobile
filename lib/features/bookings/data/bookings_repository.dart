import 'dart:convert';

import 'package:bookings_app/features/bookings/model/booking.dart';
import 'package:bookings_app/shared/api_config.dart';
import 'package:bookings_app/shared/api_response.dart';
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

  Future<ApiResponse> createBooking(Booking booking) async {
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

    var res = json.decode(response.body) as Map<String, dynamic>;

    final apiResponse = ApiResponse();

    apiResponse.code = res["code"];
    apiResponse.message = res["message"];

    return apiResponse;
  }

  Future<ApiResponse> updateBooking(Booking booking) async {
    await _getCredentials();
    final response = await _httpClient.patch(
      _apiConfig.getUniqueResourceUri('bookings', booking.id.toString()),
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

    var res = json.decode(response.body) as Map<String, dynamic>;

    final apiResponse = ApiResponse();

    apiResponse.code = res["code"];
    apiResponse.message = res["message"];

    return apiResponse;
  }

  Future<ApiResponse> deleteBooking(int id) async {
    await _getCredentials();
    final response = await _httpClient.delete(
      _apiConfig.getUniqueResourceUri("bookings", id.toString()),
      headers: {'Authorization': "Bearer $_accessToken"},
    );

    var res =  json.decode(response.body) as Map<String, dynamic>;

    final apiResponse = ApiResponse();

    apiResponse.code = res["code"];
    apiResponse.message = res["message"];

    return apiResponse;
  }

  Future<ApiResponse<List<Booking>>> getAllBookings() async {
    await _getCredentials();
    final response = await _httpClient.get(
      _apiConfig.getResourceUri("bookings"),
      headers: {'Authorization': "Bearer $_accessToken"},
    );
    final apiResponse = ApiResponse<List<Booking>>();

    var res = json.decode(response.body) as Map<String, dynamic>;
    apiResponse.code = res["code"];
    apiResponse.message = res["message"];

    if (response.statusCode == 200) {
      var bookingsData = res["data"];
      apiResponse.data = bookingsData
          .map<Booking>((booking) => Booking.fromJson(booking))
          .toList();
    }

    return apiResponse;
  }

  Future<ApiResponse<Booking>> getBooking(int id) async {
    await _getCredentials();
    final response = await _httpClient.get(
      _apiConfig.getUniqueResourceUri("bookings", id.toString()),
      headers: {'Authorization': "Bearer $_accessToken"},
    );

    var res = json.decode(response.body) as Map<String, dynamic>;
    final apiResponse = ApiResponse<Booking>();

    apiResponse.code = res["code"];
    apiResponse.message = res["message"];

    if (response.statusCode == 200) {
      var bookingsData = res["data"];
      apiResponse.data = Booking.fromJson(bookingsData);
    }

    return apiResponse;
  }
}
