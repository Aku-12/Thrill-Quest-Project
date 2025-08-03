import 'package:dartz/dartz.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/home/data/model/activity_api_model.dart';
import 'package:thrill_quest/features/home/data/model/activity_hive_model.dart';

abstract interface class IFavoritesRepository {
  Future<Either<Failure, List<ActivityApiModel>>> fetchFavorites();

  Future<Either<Failure, void>> addToFavorites(ActivityApiModel activity);

  Future<Either<Failure, void>> removeFromFavorites(String activityId);

  Future<Either<Failure, List<ActivityHiveModel>>> getCachedFavorites();

  Future<Either<Failure, void>> addFavoriteLocally(ActivityHiveModel activity);

  Future<Either<Failure, void>> removeFavoriteLocally(String activityId);
}
