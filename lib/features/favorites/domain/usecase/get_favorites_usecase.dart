import 'package:dartz/dartz.dart';
import 'package:thrill_quest/app/use_case/use_case.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/favorites/domain/repository/favorite_repository.dart';
import 'package:thrill_quest/features/home/data/model/activity_api_model.dart';

class GetFavoritesUseCase
    implements UseCaseWithoutParams<List<ActivityApiModel>> {
  final IFavoritesRepository _favoritesRepository;

  GetFavoritesUseCase({required IFavoritesRepository favoritesRepository})
    : _favoritesRepository = favoritesRepository;

  @override
  Future<Either<Failure, List<ActivityApiModel>>> call() {
    return _favoritesRepository.fetchFavorites();
  }
}
