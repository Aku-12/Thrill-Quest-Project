import 'package:dartz/dartz.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/core/utils/internet_checker.dart';
import 'package:thrill_quest/features/bookings/data/repository/bookings_local_repository.dart';
import 'package:thrill_quest/features/bookings/data/repository/bookings_remote_repository.dart';
import 'package:thrill_quest/features/bookings/domain/entity/bookings_entity.dart';
import 'package:thrill_quest/features/bookings/domain/repository/bookings_repository.dart';

class BookingsRepositoryImpl implements IBookingsRepository {
  final BookingsRemoteRepository _remoteRepository;
  final BookingsLocalRepository _localRepository;
  final InternetChecker _internetChecker;

  BookingsRepositoryImpl({
    required BookingsRemoteRepository remoteRepository,
    required BookingsLocalRepository localRepository,
    required InternetChecker internetChecker,
  }) : _remoteRepository = remoteRepository,
       _localRepository = localRepository,
       _internetChecker = internetChecker;

  @override
  Future<Either<Failure, void>> createBooking(BookingsEntity booking) async {
    final isOnline = await _internetChecker.isConnected();
    if (isOnline) {
      final remoteResult = await _remoteRepository.createBooking(booking);
      return remoteResult.fold((failure) => Left(failure), (_) async {
        await _localRepository.createBooking(booking);
        return const Right(null);
      });
    } else {
      return _localRepository.createBooking(booking);
    }
  }

  @override
  Future<Either<Failure, void>> updateBooking(
    String id,
    BookingsEntity booking,
  ) async {
    final isOnline = await _internetChecker.isConnected();
    if (isOnline) {
      final remoteResult = await _remoteRepository.updateBooking(id, booking);
      return remoteResult.fold((failure) => Left(failure), (_) async {
        await _localRepository.updateBooking(id, booking);
        return const Right(null);
      });
    } else {
      return _localRepository.updateBooking(id, booking);
    }
  }

  @override
  Future<Either<Failure, List<BookingsEntity>>> getMyBookings() async {
    final isOnline = await _internetChecker.isConnected();
    if (isOnline) {
      final remoteResult = await _remoteRepository.getMyBookings();
      return remoteResult.fold(
        (failure) async => _localRepository.getMyBookings(),
        (bookings) async {
          // Sync with local cache
          for (var booking in bookings) {
            await _localRepository.createBooking(booking);
          }
          return Right(bookings);
        },
      );
    } else {
      return _localRepository.getMyBookings();
    }
  }
}
