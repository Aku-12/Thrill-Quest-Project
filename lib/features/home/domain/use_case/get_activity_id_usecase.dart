import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/home/domain/entity/activity_entity.dart';
import 'package:thrill_quest/features/home/domain/repository/activity_repository.dart';
import 'package:thrill_quest/app/use_case/use_case.dart';

class GetActivityByIdParams extends Equatable {
  final String id;

  const GetActivityByIdParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class GetActivityByIdUseCase implements UseCaseWithParams<ActivityEntity, GetActivityByIdParams> {
  final IActivityRepository repository;

  GetActivityByIdUseCase({required this.repository});

  @override
  Future<Either<Failure, ActivityEntity>> call(GetActivityByIdParams params) {
    return repository.getActivityById(params.id);
  }
}
