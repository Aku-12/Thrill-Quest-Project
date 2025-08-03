import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/home/domain/use_case/get_all_activties_usecase.dart'; // Import the use case
import 'package:thrill_quest/features/home/presentation/view_model/home_event.dart';
import 'package:thrill_quest/features/home/presentation/view_model/home_state.dart';

class HomeViewModel extends Bloc<HomeEvent, HomeState> {
  final GetAllActivitiesUseCase getAllActivitiesUseCase; // Use case dependency

  HomeViewModel({required this.getAllActivitiesUseCase}) // Inject the use case
    : super(const HomeInitial()) {
    on<LoadActivities>(_onLoadActivities);
  }

  Future<void> _onLoadActivities(
    LoadActivities event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(const HomeLoading());
      final result = await getAllActivitiesUseCase();
      result.fold(
        (failure) => emit(HomeError(message: _mapFailureToMessage(failure))),
        (activities) => emit(HomeLoaded(activities: activities)),
      );
    } catch (e) {
      // Catch any unexpected errors, though the use case should handle most
      emit(HomeError(message: e.toString()));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return 'Server Error: Please try again later.';
      case NetworkFailure _:
        return 'No Internet Connection: Check your network settings.';
      case CacheFailure _:
        return 'Data not found locally.';
      default:
        return 'An unexpected error occurred.';
    }
  }
}
