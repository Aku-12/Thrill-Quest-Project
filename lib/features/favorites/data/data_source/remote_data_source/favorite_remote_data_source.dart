import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/core/network/api_service.dart';
import 'package:thrill_quest/features/favorites/data/data_source/favorite_data_source.dart';
import 'package:thrill_quest/app/constant/api/api_endpoints.dart';
import 'package:thrill_quest/features/home/data/model/activity_api_model.dart';
import 'package:thrill_quest/features/home/data/model/activity_hive_model.dart';

class FavoritesRemoteDataSource implements IFavoriteDataSource {
  final ApiService _apiService;

  FavoritesRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<Either<Failure, List<ActivityApiModel>>>
  fetchFavoritesFromRemote() async {
    try {
      final response = await _apiService.dio.get(ApiEndpoints.getFavorites);

      if (response.statusCode == 200) {
        final List<dynamic> favoritesData = response.data['favorites'] ?? [];

        final favorites =
            favoritesData.map((json) {
              final model = ActivityApiModel.fromJson(
                json as Map<String, dynamic>,
              );
              final imagesWithHost =
                  model.images?.map((imagePath) {
                    return '${ApiEndpoints.serverAddress}$imagePath';
                  }).toList();

              return ActivityApiModel(
                id: model.id,
                name: model.name,
                location: model.location,
                images: imagesWithHost,
                price: model.price,
                duration: model.duration,
                difficulty: model.difficulty,
                bookings: model.bookings,
                rating: model.rating,
                status: model.status,
              );
            }).toList();
        return Right(favorites);
      } else {
        return Left(
          ApiFailure(
            message: 'Failed to fetch favorites: ${response.statusMessage}',
          ),
        );
      }
    } on DioException catch (error) {
      final message = error.response?.data['message'] ?? error.message;
      return Left(ApiFailure(message: message));
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToFavoritesRemote(
    ActivityApiModel activity,
  ) async {
    try {
      // CORRECTED: Send a map with the correct key name 'activityId'
      final response = await _apiService.dio.post(
        ApiEndpoints.addFavorite,
        data: {'activityId': activity.id},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return const Right(null);
      } else {
        final message =
            response.data['message'] ?? 'Failed to add to favorites';
        return Left(
          ApiFailure(message: 'Failed to add to favorites: $message'),
        );
      }
    } on DioException catch (error) {
      final message = error.response?.data['message'] ?? error.message;
      return Left(ApiFailure(message: message));
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromFavoritesRemote(
    String activityId,
  ) async {
    try {
      final response = await _apiService.dio.delete(
        '${ApiEndpoints.removeFavorite}/$activityId',
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(
          ApiFailure(
            message:
                'Failed to remove from favorites: ${response.statusMessage}',
          ),
        );
      }
    } on DioException catch (error) {
      final message = error.response?.data['message'] ?? error.message;
      return Left(ApiFailure(message: message));
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ActivityHiveModel>>> getCachedFavoritesLocal() =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, void>> addFavoriteLocally(
    ActivityHiveModel activity,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> removeFavoriteLocally(String activityId) =>
      throw UnimplementedError();
}
