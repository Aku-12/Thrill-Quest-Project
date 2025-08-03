import 'package:dartz/dartz.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/core/utils/internet_checker.dart';
import 'package:thrill_quest/features/favorites/data/data_source/local_data_source/favorite_local_data_source.dart';
import 'package:thrill_quest/features/favorites/data/data_source/remote_data_source/favorite_remote_data_source.dart';
import 'package:thrill_quest/features/favorites/domain/repository/favorite_repository.dart';
import 'package:thrill_quest/features/home/data/model/activity_api_model.dart';
import 'package:thrill_quest/features/home/data/model/activity_hive_model.dart';

class FavoritesRepositoryImpl implements IFavoritesRepository {
  final FavoritesRemoteDataSource _remoteDataSource;
  final FavoritesLocalDatasource _localDataSource;
  final InternetChecker _internetChecker;

  FavoritesRepositoryImpl({
    required FavoritesRemoteDataSource remoteDataSource,
    required FavoritesLocalDatasource localDataSource,
    required InternetChecker internetChecker,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _internetChecker = internetChecker;

  @override
  Future<Either<Failure, List<ActivityApiModel>>> fetchFavorites() async {
    final isConnected = await _internetChecker.isConnected();
    if (!isConnected) {
      return Left(NetworkFailure(message: 'No internet connection.'));
    }
    try {
      final favorites = await _remoteDataSource.fetchFavoritesFromRemote();
      return favorites;
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToFavorites(ActivityApiModel booking) async {
    final isConnected = await _internetChecker.isConnected();
    if (!isConnected) {
      return Left(NetworkFailure(message: 'No internet connection.'));
    }
    try {
      return await _remoteDataSource.addToFavoritesRemote(booking);
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromFavorites(String bookingId) async {
    final isConnected = await _internetChecker.isConnected();
    if (!isConnected) {
      return Left(NetworkFailure(message: 'No internet connection.'));
    }
    try {
      return await _remoteDataSource.removeFromFavoritesRemote(bookingId);
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ActivityHiveModel>>> getCachedFavorites() async {
    try {
      final cachedFavorites = await _localDataSource.getCachedFavorites();
      return Right(cachedFavorites);
    } catch (error) {
      return Left(CacheFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addFavoriteLocally(
    ActivityHiveModel booking,
  ) async {
    try {
      await _localDataSource.addFavorite(booking);
      return const Right(null);
    } catch (error) {
      return Left(CacheFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavoriteLocally(String bookingId) async {
    try {
      await _localDataSource.removeFavorite(bookingId);
      return const Right(null);
    } catch (error) {
      return Left(CacheFailure(message: error.toString()));
    }
  }
}
