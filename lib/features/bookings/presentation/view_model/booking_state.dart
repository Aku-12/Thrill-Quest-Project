// lib/features/home/presentation/view_model/booking_state.dart
import 'package:equatable/equatable.dart';
import 'package:thrill_quest/features/guides/domain/entity/guide_entity.dart';

class BookingState extends Equatable {
  final String? selectedActivityId; // To store the actual MongoDB _id
  final String? selectedActivityName; // To store the display name
  final String? selectedGuide;
  final DateTime? selectedDate;
  final bool isLoading;
  final String? errorMessage;
  final bool bookingSuccess;
  final List<GuideEntity> availableGuides;
  final bool isGuidesLoading;

  const BookingState({
    this.selectedActivityId,
    this.selectedActivityName,
    this.selectedGuide,
    this.selectedDate,
    this.isLoading = false,
    this.errorMessage,
    this.bookingSuccess = false,
    this.availableGuides = const [],
    this.isGuidesLoading = false,
  });

  BookingState copyWith({
    String? selectedActivityId,
    String? selectedActivityName,
    String? selectedGuide,
    DateTime? selectedDate,
    bool? isLoading,
    String? errorMessage,
    bool? bookingSuccess,
    List<GuideEntity>? availableGuides,
    bool? isGuidesLoading,
  }) {
    return BookingState(
      selectedActivityId: selectedActivityId ?? this.selectedActivityId,
      selectedActivityName: selectedActivityName ?? this.selectedActivityName,
      selectedGuide: selectedGuide ?? this.selectedGuide,
      selectedDate: selectedDate ?? this.selectedDate,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      bookingSuccess: bookingSuccess ?? this.bookingSuccess,
      availableGuides: availableGuides ?? this.availableGuides,
      isGuidesLoading: isGuidesLoading ?? this.isGuidesLoading,
    );
  }

  @override
  List<Object?> get props => [
        selectedActivityId,
        selectedActivityName,
        selectedGuide,
        selectedDate,
        isLoading,
        errorMessage,
        bookingSuccess,
        availableGuides,
        isGuidesLoading,
      ];
}