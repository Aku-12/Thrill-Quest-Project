import 'package:equatable/equatable.dart';
import 'package:thrill_quest/features/bookings/domain/entity/bookings_entity.dart';

abstract class BookingsState extends Equatable {
  const BookingsState();

  @override
  List<Object> get props => [];
}

class BookingsInitial extends BookingsState {}

class BookingsLoading extends BookingsState {}

class BookingsLoaded extends BookingsState {
  final List<BookingsEntity> bookings;

  const BookingsLoaded(this.bookings);

  @override
  List<Object> get props => [bookings];
}

class BookingsError extends BookingsState {
  final String message;

  const BookingsError(this.message);

  @override
  List<Object> get props => [message];
}