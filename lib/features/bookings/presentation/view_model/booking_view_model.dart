// lib/features/home/presentation/view_model/booking_view_model.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart'; // For debugPrint
import 'package:thrill_quest/app/context/auth_service.dart';
import 'package:thrill_quest/features/bookings/domain/use_case/create_booking_usecase.dart';
import 'package:thrill_quest/features/guides/domain/use_case/get_all_guides_usecase.dart';
import 'package:thrill_quest/features/bookings/presentation/view_model/booking_event.dart';
import 'package:thrill_quest/features/bookings/presentation/view_model/booking_state.dart';
import 'package:thrill_quest/features/bookings/domain/entity/bookings_entity.dart';

class BookingViewModel extends Bloc<BookingEvent, BookingState> {
  final CreateBookingUsecase _createBookingUsecase;
  final GetAllGuidesUsecase _getAllGuidesUsecase;
  final AuthService _authService;

  BookingViewModel({
    required CreateBookingUsecase createBookingUsecase,
    required GetAllGuidesUsecase getAllGuidesUsecase,
    required AuthService authService,
  }) : _createBookingUsecase = createBookingUsecase,
       _getAllGuidesUsecase = getAllGuidesUsecase,
       _authService = authService,
       super(const BookingState()) {
    on<ActivitySelected>((event, emit) {
      debugPrint(
        'BookingViewModel: ActivitySelected -> ID: ${event.activityId}, Name: ${event.activityName}',
      );
      emit(
        state.copyWith(
          selectedActivityId: event.activityId, // Store the ID
          selectedActivityName: event.activityName, // Store the Name
          errorMessage: null,
        ),
      );
    });

    on<GuideSelected>((event, emit) {
      debugPrint('BookingViewModel: GuideSelected -> Guide: ${event.guide}');
      emit(state.copyWith(selectedGuide: event.guide, errorMessage: null));
    });

    on<DateSelected>((event, emit) {
      debugPrint('BookingViewModel: DateSelected -> Date: ${event.date}');
      emit(state.copyWith(selectedDate: event.date, errorMessage: null));
    });

    on<FetchGuides>((event, emit) async {
      debugPrint('BookingViewModel: FetchGuides event received.');
      emit(
        state.copyWith(
          isGuidesLoading: true,
          errorMessage: null,
          availableGuides: [],
        ),
      ); // Clear guides and set loading
      final result = await _getAllGuidesUsecase(GetAllGuidesParams());
      result.fold(
        (failure) {
          debugPrint('BookingViewModel: FetchGuides failed -> ${failure.message}');
          emit(
            state.copyWith(
              errorMessage: 'Failed to fetch guides: ${failure.message}',
              isGuidesLoading: false,
            ),
          );
        },
        (guides) {
          debugPrint(
            'BookingViewModel: FetchGuides successful. Found ${guides.length} guides.',
          );
          emit(
            state.copyWith(
              availableGuides: guides,
              isGuidesLoading: false,
              selectedGuide:
                  state.selectedGuide ??
                  (guides.isNotEmpty ? guides.first.name : null),
            ),
          );
        },
      );
    });

    on<SubmitBooking>((event, emit) async {
      final String? activityIdToSubmit =
          event.activityId; // Get the ID from the event itself
      final String? activityNameForDisplay =
          state.selectedActivityName; // Get the Name from state for logs/UI
      final String? guide = state.selectedGuide;
      final DateTime? date = state.selectedDate;

      debugPrint('BookingViewModel: SubmitBooking event received.');
      debugPrint(
        ' Activity ID to submit: $activityIdToSubmit, Activity Name: $activityNameForDisplay, Guide: $guide, Date: $date',
      );

      if (activityIdToSubmit == null ||
          activityNameForDisplay == null ||
          guide == null ||
          date == null) {
        debugPrint('BookingViewModel: Validation failed. Missing booking details.');
        emit(
          state.copyWith(
            errorMessage: 'Please fill all booking details.',
            isLoading: false,
            bookingSuccess: false,
          ),
        );
        return;
      }

      // Get current user details from AuthService
      final user =
          await _authService
              .getUser(); // This is synchronous, gets the cached user

      // Safely construct the customerName
      final String customerFullName;
      if (user != null) {
        String fName = user.fName; // Use empty string if fName is null
        String lName = user.lName ?? ''; // Use empty string if lName is null
        customerFullName = '$fName $lName'.trim();
      } else {
        debugPrint('BookingViewModel: User object is null.');
        customerFullName = ''; // Default to empty if user is null
      }

      final currentUserId = user?.id; // Optional, can be null

      // Check if user full name or ID is missing
      if (customerFullName.isEmpty || currentUserId == null) {
        debugPrint(
          'BookingViewModel: Current user not logged in or user data incomplete (name/ID missing).',
        );
        emit(
          state.copyWith(
            errorMessage:
                'User profile incomplete. Please ensure you are logged in and your name is set.',
            isLoading: false,
            bookingSuccess: false,
          ),
        );
        return;
      }

      debugPrint('BookingViewModel: Validation passed. Attempting booking...');
      emit(
        state.copyWith(
          isLoading: true,
          errorMessage: null,
          bookingSuccess: false,
        ),
      );

      final BookingsEntity newBooking = BookingsEntity(
        activityId:
            activityIdToSubmit, // Use the actual activity ID for the backend
        customerName: customerFullName, // Use the safely constructed full name
        guideName: guide,
        tourDate: date,
        paymentStatus: 'Pending',
        bookingStatus: 'Confirmed',
        userId: currentUserId, // Use the fetched user's ID
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      debugPrint('BookingViewModel: Attempting to create booking for: $newBooking');
      final result = await _createBookingUsecase(newBooking);

      result.fold(
        (failure) {
          debugPrint('BookingViewModel: Booking failed: ${failure.message}');
          emit(
            state.copyWith(
              isLoading: false,
              bookingSuccess: false,
              errorMessage: 'Booking failed: ${failure.message}',
            ),
          );
        },
        (_) {
          debugPrint('BookingViewModel: Booking successful!');
          emit(
            state.copyWith(
              isLoading: false,
              bookingSuccess: true,
              errorMessage: null,
            ),
          );
        },
      );
    });

    on<ResetBookingState>((event, emit) {
      debugPrint(
        'BookingViewModel: ResetBookingState event received. Resetting success/error flags.',
      );
      emit(state.copyWith(bookingSuccess: false, errorMessage: null));
    });
  }
}
