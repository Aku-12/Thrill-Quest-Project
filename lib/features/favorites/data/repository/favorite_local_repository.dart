import 'package:dartz/dartz.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/favorites/data/data_source/local_data_source/favorite_local_data_source.dart';
import 'package:thrill_quest/features/favorites/domain/repository/favorite_repository.dart';
import 'package:thrill_quest/features/home/data/model/activity_api_model.dart';
import 'package:thrill_quest/features/home/data/model/activity_hive_model.dart';

class FavoritesLocalRepository implements IFavoritesRepository {
  final FavoritesLocalDatasource _localDataSource;

  FavoritesLocalRepository({required FavoritesLocalDatasource localDataSource})
    : _localDataSource = localDataSource;

  @override
  Future<Either<Failure, List<ActivityHiveModel>>> getCachedFavorites() async {
    try {
      final favorites = await _localDataSource.getCachedFavorites();
      return Right(favorites);
    } catch (error) {
      return Left(CacheFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addFavoriteLocally(
    ActivityHiveModel activity,
  ) async {
    try {
      await _localDataSource.addFavorite(activity);
      return const Right(null);
    } catch (error) {
      return Left(CacheFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavoriteLocally(String activityId) async {
    try {
      await _localDataSource.removeFavorite(activityId);
      return const Right(null);
    } catch (error) {
      return Left(CacheFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ActivityApiModel>>> fetchFavorites() {
    throw UnimplementedError(
      'fetchFavorites is not implemented in local repository',
    );
  }

  @override
  Future<Either<Failure, void>> addToFavorites(ActivityApiModel activity) {
    throw UnimplementedError(
      'addToFavorites is not implemented in local repository',
    );
  }

  @override
  Future<Either<Failure, void>> removeFromFavorites(String activityId) {
    throw UnimplementedError(
      'removeFromFavorites is not implemented in local repository',
    );
  }
}
