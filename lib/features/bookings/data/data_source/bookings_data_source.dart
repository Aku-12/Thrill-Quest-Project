import 'package:thrill_quest/features/bookings/domain/entity/bookings_entity.dart';

abstract interface class IBookingsDataSource {
  Future<void> createBooking(BookingsEntity booking);
  Future<void> updateBooking(String id, BookingsEntity booking);
  Future<List<BookingsEntity>> getMyBookings();
}
