import 'package:equatable/equatable.dart';

abstract class BookingsEvent extends Equatable {
  const BookingsEvent();

  @override
  List<Object> get props => [];
}

class FetchAllBookings extends BookingsEvent {}