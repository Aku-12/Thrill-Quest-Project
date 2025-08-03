import 'package:dartz/dartz.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/home/data/data_source/remote_data_source/activity_remote_data_source.dart';
import 'package:thrill_quest/features/home/domain/entity/activity_entity.dart';

import 'package:thrill_quest/features/home/domain/repository/activity_repository.dart';

class ActivityRemoteRepository implements IActivityRepository {
  final ActivityRemoteDatasource _activityRemoteDatasource;

  ActivityRemoteRepository({
    required ActivityRemoteDatasource activityRemoteDatasource, required ActivityRemoteDatasource remoteDatasource,
  }) : _activityRemoteDatasource = activityRemoteDatasource;

  @override
  Future<Either<Failure, List<ActivityEntity>>> getAllActivities() async {
    try {
      final activities = await _activityRemoteDatasource.getAllActivities();
      return Right(activities);
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, ActivityEntity>> getActivityById(String id) async {
    try {
      final activity = await _activityRemoteDatasource.getActivityById(id);
      return Right(activity);
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createActivity(ActivityEntity activity) async {
    try {
      await _activityRemoteDatasource.createActivity(activity);
      return Right(null);
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateActivity(String id, ActivityEntity activity) async {
    try {
      await _activityRemoteDatasource.updateActivity(id, activity);
      return Right(null);
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteActivity(String id) async {
    try {
      await _activityRemoteDatasource.deleteActivity(id);
      return Right(null);
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }
}
