// lib/features/home/presentation/view_model/booking_event.dart
import 'package:equatable/equatable.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

class ActivitySelected extends BookingEvent {
  final String activityId;
  final String activityName;
  // Constructor correctly uses activityId and activityName
  const ActivitySelected({required this.activityId, required this.activityName});

  @override
  List<Object?> get props => [activityId, activityName];
}

class GuideSelected extends BookingEvent {
  final String? guide;
  const GuideSelected(this.guide);

  @override
  List<Object?> get props => [guide];
}

class DateSelected extends BookingEvent {
  final DateTime? date;
  const DateSelected(this.date);

  @override
  List<Object?> get props => [date];
}

class SubmitBooking extends BookingEvent {
  // This event will now pass the actual activity ID for submission
  final String activityId; // Changed from activityName to activityId
  const SubmitBooking(this.activityId);

  @override
  List<Object?> get props => [activityId];
}

class FetchGuides extends BookingEvent {
  const FetchGuides();
}

// Add an event to reset the booking success/error state after a Snackbar is shown
class ResetBookingState extends BookingEvent {
  const ResetBookingState();
}