import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thrill_quest/features/bookings/domain/use_case/get_my_bookings_usecase.dart';
import 'package:thrill_quest/features/bookings/presentation/view_model/all_bookings_event.dart';
import 'package:thrill_quest/features/bookings/presentation/view_model/all_bookings_state.dart';

class AllBookingsViewModel extends Bloc<BookingsEvent, BookingsState> {
  final GetMyBookingsUsecase _getMyBookingsUsecase;

  AllBookingsViewModel({required GetMyBookingsUsecase getMyBookingsUsecase})
      : _getMyBookingsUsecase = getMyBookingsUsecase,
        super(BookingsInitial()) {
    on<FetchAllBookings>(_onFetchAllBookings);
  }

  Future<void> _onFetchAllBookings(
    FetchAllBookings event,
    Emitter<BookingsState> emit,
  ) async {
    // Emit loading state to show a progress indicator in the UI.
    emit(BookingsLoading());

    // Execute the use case to get booking data.
    final result = await _getMyBookingsUsecase();

    // Handle the result from the use case.
    result.fold(
      // On failure, emit an error state with the failure message.
      (failure) => emit(BookingsError(failure.message)),
      // On success, emit a loaded state with the list of bookings.
      (bookings) => emit(BookingsLoaded(bookings)),
    );
  }
}