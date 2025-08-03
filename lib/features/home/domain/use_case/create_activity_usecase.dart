import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/home/domain/entity/activity_entity.dart';
import 'package:thrill_quest/features/home/domain/repository/activity_repository.dart';
import 'package:thrill_quest/app/use_case/use_case.dart';

class CreateActivityParams extends Equatable {
  final ActivityEntity activity;

  const CreateActivityParams({required this.activity});

  @override
  List<Object?> get props => [activity];
}

class CreateActivityUseCase implements UseCaseWithParams<void, CreateActivityParams> {
  final IActivityRepository repository;

  CreateActivityUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(CreateActivityParams params) {
    return repository.createActivity(params.activity);
  }
}
