import 'package:dartz/dartz.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/bookings/data/data_source/local_data_source/bookings_local_data_source.dart';
import 'package:thrill_quest/features/bookings/domain/entity/bookings_entity.dart';
import 'package:thrill_quest/features/bookings/domain/repository/bookings_repository.dart';

class BookingsLocalRepository implements IBookingsRepository {
  final BookingsLocalDataSource _localDataSource;

  BookingsLocalRepository({required BookingsLocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  @override
  Future<Either<Failure, void>> createBooking(BookingsEntity booking) async {
    try {
      await _localDataSource.createBooking(booking);
      return Right(null);
    } catch (error) {
      return Left(
        LocalDatabaseFailure(message: 'Local booking creation failed: $error'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateBooking(
    String id,
    BookingsEntity booking,
  ) async {
    try {
      await _localDataSource.updateBooking(id, booking);
      return Right(null);
    } catch (error) {
      return Left(
        LocalDatabaseFailure(message: 'Local booking update failed: $error'),
      );
    }
  }

  @override
  Future<Either<Failure, List<BookingsEntity>>> getMyBookings() async {
    try {
      // This assumes getMyBookings() in the local data source already filters by user
      final result = await _localDataSource.getMyBookings();
      return Right(result);
    } catch (error) {
      return Left(
        LocalDatabaseFailure(message: 'Failed to fetch local bookings: $error'),
      );
    }
  }
}
