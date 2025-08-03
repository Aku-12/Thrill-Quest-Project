import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thrill_quest/features/favorites/domain/usecase/add_to_favorite_usecase.dart';
import 'package:thrill_quest/features/favorites/domain/usecase/get_favorites_usecase.dart';
import 'package:thrill_quest/features/favorites/domain/usecase/remove_from_favorite.dart';
import 'package:thrill_quest/features/favorites/presentation/view_model/favorites_event.dart';
import 'package:thrill_quest/features/favorites/presentation/view_model/favorites_state.dart';

class FavoritesViewModel extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavoritesUseCase _getFavoritesUseCase;
  final AddToFavoritesUseCase _addToFavoritesUseCase;
  final RemoveFromFavoritesUseCase _removeFromFavoritesUseCase;

  FavoritesViewModel({
    required GetFavoritesUseCase getFavoritesUseCase,
    required AddToFavoritesUseCase addToFavoritesUseCase,
    required RemoveFromFavoritesUseCase removeFromFavoritesUseCase,
  })  : _getFavoritesUseCase = getFavoritesUseCase,
        _addToFavoritesUseCase = addToFavoritesUseCase,
        _removeFromFavoritesUseCase = removeFromFavoritesUseCase,
        super(const FavoritesInitial()) {
    on<FetchFavoritesEvent>(_onFetchFavorites);
    on<AddToFavoritesEvent>(_onAddFavorite);
    on<RemoveFromFavoritesEvent>(_onRemoveFavorite);
  }

  Future<void> _onFetchFavorites(
    FetchFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(const FavoritesLoading());
    final result = await _getFavoritesUseCase();
    result.fold(
      (failure) => emit(FavoritesError(message: failure.message)),
      (favorites) => emit(FavoritesLoaded(favorites: favorites)),
    );
  }

  Future<void> _onAddFavorite(
    AddToFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    await _addToFavoritesUseCase(AddToFavoritesParams(activity: event.activity));
    add(const FetchFavoritesEvent()); // Refresh list
  }

  Future<void> _onRemoveFavorite(
    RemoveFromFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    await _removeFromFavoritesUseCase(RemoveFromFavoritesParams(activityId: event.activityId));
    add(const FetchFavoritesEvent()); // Refresh list
  }
}
