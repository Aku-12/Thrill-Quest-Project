import 'package:dartz/dartz.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/bookings/data/data_source/remote_data_source/bookings_remote_data_source.dart';
import 'package:thrill_quest/features/bookings/domain/entity/bookings_entity.dart';
import 'package:thrill_quest/features/bookings/domain/repository/bookings_repository.dart';

class BookingsRemoteRepository implements IBookingsRepository {
  final BookingsRemoteDataSource _remoteDataSource;

  BookingsRemoteRepository({required BookingsRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, void>> createBooking(BookingsEntity booking) async {
    try {
      await _remoteDataSource.createBooking(booking);
      return Right(null);
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateBooking(
      String id, BookingsEntity booking) async {
    try {
      await _remoteDataSource.updateBooking(id, booking);
      return Right(null);
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookingsEntity>>> getMyBookings() async {
    try {
      final bookings = await _remoteDataSource.getMyBookings();
      return Right(bookings);
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }
}
