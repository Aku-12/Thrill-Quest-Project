import 'package:dartz/dartz.dart';
import 'package:thrill_quest/app/use_case/use_case.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/bookings/domain/entity/bookings_entity.dart';
import 'package:thrill_quest/features/bookings/domain/repository/bookings_repository.dart';

class CreateBookingUsecase implements UseCaseWithParams<void, BookingsEntity> {
  final IBookingsRepository _bookingsRepository;

  CreateBookingUsecase({required IBookingsRepository bookingsRepository})
    : _bookingsRepository = bookingsRepository;

  @override
  Future<Either<Failure, void>> call(BookingsEntity booking) {
    return _bookingsRepository.createBooking(booking);
  }
}
