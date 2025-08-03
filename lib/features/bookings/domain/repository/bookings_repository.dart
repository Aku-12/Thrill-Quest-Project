import 'package:dartz/dartz.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/bookings/domain/entity/bookings_entity.dart';

abstract interface class IBookingsRepository {
  Future<Either<Failure, void>> createBooking(BookingsEntity booking);
  Future<Either<Failure, void>> updateBooking(
    String id,
    BookingsEntity booking,
  );
  Future<Either<Failure, List<BookingsEntity>>> getMyBookings();
}
