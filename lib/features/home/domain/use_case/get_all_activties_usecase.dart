import 'package:dartz/dartz.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/home/domain/entity/activity_entity.dart';
import 'package:thrill_quest/features/home/domain/repository/activity_repository.dart';
import 'package:thrill_quest/app/use_case/use_case.dart';

class GetAllActivitiesUseCase implements UseCaseWithoutParams<List<ActivityEntity>> {
  final IActivityRepository repository;

  GetAllActivitiesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<ActivityEntity>>> call() {
    return repository.getAllActivities();
  }
}
