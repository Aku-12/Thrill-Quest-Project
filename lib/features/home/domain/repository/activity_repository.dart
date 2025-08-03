import 'package:dartz/dartz.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/home/domain/entity/activity_entity.dart';

abstract interface class IActivityRepository {
  Future<Either<Failure, List<ActivityEntity>>> getAllActivities();
  Future<Either<Failure, ActivityEntity>> getActivityById(String id);
  Future<Either<Failure, void>> createActivity(ActivityEntity activity);
  Future<Either<Failure, void>> updateActivity(String id, ActivityEntity activity);
  Future<Either<Failure, void>> deleteActivity(String id);
}
