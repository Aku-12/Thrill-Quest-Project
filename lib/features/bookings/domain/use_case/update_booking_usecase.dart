import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thrill_quest/app/use_case/use_case.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/bookings/domain/entity/bookings_entity.dart';
import 'package:thrill_quest/features/bookings/domain/repository/bookings_repository.dart';

class UpdateBookingParams extends Equatable {
  final String id;
  final BookingsEntity updatedBooking;

  const UpdateBookingParams({required this.id, required this.updatedBooking});

  @override
  List<Object?> get props => [id, updatedBooking];
}

class UpdateBookingUsecase
    implements UseCaseWithParams<void, UpdateBookingParams> {
  final IBookingsRepository _bookingsRepository;

  UpdateBookingUsecase({required IBookingsRepository bookingsRepository})
    : _bookingsRepository = bookingsRepository;

  @override
  Future<Either<Failure, void>> call(UpdateBookingParams params) {
    return _bookingsRepository.updateBooking(params.id, params.updatedBooking);
  }
}
