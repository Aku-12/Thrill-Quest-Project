import 'package:dartz/dartz.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/favorites/data/data_source/remote_data_source/favorite_remote_data_source.dart';
import 'package:thrill_quest/features/favorites/domain/repository/favorite_repository.dart';
import 'package:thrill_quest/features/home/data/model/activity_api_model.dart';
import 'package:thrill_quest/features/home/data/model/activity_hive_model.dart';

class FavoritesRemoteRepository implements IFavoritesRepository {
  final FavoritesRemoteDataSource _remoteDataSource;

  FavoritesRemoteRepository({
    required FavoritesRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<ActivityApiModel>>> fetchFavorites() async {
    try {
      final favorites = await _remoteDataSource.fetchFavoritesFromRemote();
      return favorites;
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToFavorites(ActivityApiModel activity) async {
    try {
      final result = await _remoteDataSource.addToFavoritesRemote(activity);
      return result;
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromFavorites(String activityId) async {
    try {
      final result = await _remoteDataSource.removeFromFavoritesRemote(
        activityId,
      );
      return result;
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ActivityHiveModel>>> getCachedFavorites() {
    throw UnimplementedError(
      'getCachedFavorites is not implemented in remote repository',
    );
  }

  @override
  Future<Either<Failure, void>> addFavoriteLocally(ActivityHiveModel activity) {
    throw UnimplementedError(
      'addFavoriteLocally is not implemented in remote repository',
    );
  }

  @override
  Future<Either<Failure, void>> removeFavoriteLocally(String activityId) {
    throw UnimplementedError(
      'removeFavoriteLocally is not implemented in remote repository',
    );
  }
}
