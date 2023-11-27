import 'package:bookings_app/features/bookings/data/bookings_repository.dart';
import 'package:bookings_app/features/bookings/model/booking.dart';

class BookingsService {
  final BookingsRepository _bookingsRepository = BookingsRepository();

  Future<List<Booking>> getBookings() async {
    return await _bookingsRepository.getAllBookings();
  }

  Future<Booking> getBooking(int id) async {
    return await _bookingsRepository.getBooking(id);
  }

  Future<Map<String, dynamic>> createBooking(Booking bookings) async {
    return await _bookingsRepository.createBooking(bookings);
  }

  Future<Map<String, dynamic>> updateBooking(Booking bookings) async {
    return await _bookingsRepository.updateBooking(bookings);
  }

  Future<Map<String, dynamic>> deleteBooking(int id) async {
    return await _bookingsRepository.deleteBooking(id);
  }
}