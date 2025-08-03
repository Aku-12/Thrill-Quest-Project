import 'package:thrill_quest/core/network/hive_service.dart';
import 'package:thrill_quest/features/home/data/model/activity_hive_model.dart';

class FavoritesLocalDatasource {
  final HiveService _hiveService;

  FavoritesLocalDatasource({required HiveService hiveService}) : _hiveService = hiveService;

  Future<void> cacheFavorites(List<ActivityHiveModel> favorites) async {
    await _hiveService.saveFavorites(favorites);
  }

  Future<List<ActivityHiveModel>> getCachedFavorites() async {
    return await _hiveService.getFavorites();
  }

  Future<void> addFavorite(ActivityHiveModel activity) async {
    await _hiveService.addFavorite(activity);
  }

  Future<void> removeFavorite(String activityId) async {
    await _hiveService.removeFavorite(activityId);
  }

  Future<void> clearAllFavorites() async {
    await _hiveService.clearFavorites();
  }
}
