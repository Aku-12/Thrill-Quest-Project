import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thrill_quest/app/use_case/use_case.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/favorites/domain/repository/favorite_repository.dart';

class RemoveFromFavoritesParams extends Equatable {
  final String activityId;

  const RemoveFromFavoritesParams({required this.activityId});

  @override
  List<Object?> get props => [activityId];
}

class RemoveFromFavoritesUseCase
    implements UseCaseWithParams<void, RemoveFromFavoritesParams> {
  final IFavoritesRepository _favoritesRepository;

  RemoveFromFavoritesUseCase(this._favoritesRepository);

  @override
  Future<Either<Failure, void>> call(RemoveFromFavoritesParams params) {
    return _favoritesRepository.removeFromFavorites(params.activityId);
  }
}
