import 'package:dartz/dartz.dart';
import 'package:thrill_quest/app/use_case/use_case.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/bookings/domain/entity/bookings_entity.dart';
import 'package:thrill_quest/features/bookings/domain/repository/bookings_repository.dart';

class GetMyBookingsUsecase implements UseCaseWithoutParams<List<BookingsEntity>> {
  final IBookingsRepository _bookingsRepository;

  GetMyBookingsUsecase({
    required IBookingsRepository bookingsRepository,
  }) : _bookingsRepository = bookingsRepository;

  @override
  Future<Either<Failure, List<BookingsEntity>>> call() {
    return _bookingsRepository.getMyBookings();
  }
}
