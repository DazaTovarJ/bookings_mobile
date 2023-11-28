import 'package:bookings_app/features/bookings/data/bookings_repository.dart';
import 'package:bookings_app/features/bookings/model/booking.dart';
import 'package:bookings_app/shared/api_response.dart';

class BookingsService {
  final BookingsRepository _bookingsRepository = BookingsRepository();

  Future<ApiResponse<List<Booking>>> getBookings() async {
    return await _bookingsRepository.getAllBookings();
  }

  Future<ApiResponse<Booking>> getBooking(int id) async {
    return await _bookingsRepository.getBooking(id);
  }

  Future<ApiResponse> createBooking(Booking bookings) async {
    return await _bookingsRepository.createBooking(bookings);
  }

  Future<ApiResponse> updateBooking(Booking bookings) async {
    return await _bookingsRepository.updateBooking(bookings);
  }

  Future<ApiResponse> deleteBooking(int id) async {
    return await _bookingsRepository.deleteBooking(id);
  }
}