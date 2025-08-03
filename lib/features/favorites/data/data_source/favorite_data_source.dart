import 'package:dartz/dartz.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/home/data/model/activity_api_model.dart';
import 'package:thrill_quest/features/home/data/model/activity_hive_model.dart';

abstract interface class IFavoriteDataSource {
  Future<Either<Failure, List<ActivityApiModel>>> fetchFavoritesFromRemote();
  Future<Either<Failure, void>> addToFavoritesRemote(ActivityApiModel activity);
  Future<Either<Failure, void>> removeFromFavoritesRemote(String activityId);

  Future<Either<Failure, List<ActivityHiveModel>>> getCachedFavoritesLocal();
  Future<Either<Failure, void>> addFavoriteLocally(ActivityHiveModel activity);
  Future<Either<Failure, void>> removeFavoriteLocally(String activityId);
}
