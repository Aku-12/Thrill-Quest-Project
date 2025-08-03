import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/home/domain/entity/activity_entity.dart';
import 'package:thrill_quest/features/home/domain/repository/activity_repository.dart';
import 'package:thrill_quest/app/use_case/use_case.dart';

class UpdateActivityParams extends Equatable {
  final String id;
  final ActivityEntity activity;

  const UpdateActivityParams({required this.id, required this.activity});

  @override
  List<Object?> get props => [id, activity];
}

class UpdateActivityUseCase implements UseCaseWithParams<void, UpdateActivityParams> {
  final IActivityRepository repository;

  UpdateActivityUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(UpdateActivityParams params) {
    return repository.updateActivity(params.id, params.activity);
  }
}
