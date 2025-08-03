import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thrill_quest/app/use_case/use_case.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/favorites/domain/repository/favorite_repository.dart';
import 'package:thrill_quest/features/home/data/model/activity_api_model.dart';

class AddToFavoritesParams extends Equatable {
  final ActivityApiModel activity;

  const AddToFavoritesParams({required this.activity});

  @override
  List<Object?> get props => [activity];
}

class AddToFavoritesUseCase
    implements UseCaseWithParams<void, AddToFavoritesParams> {
  final IFavoritesRepository _favoritesRepository;

  AddToFavoritesUseCase(this._favoritesRepository);

  @override
  Future<Either<Failure, void>> call(AddToFavoritesParams params) {
    return _favoritesRepository.addToFavorites(params.activity);
  }
}
