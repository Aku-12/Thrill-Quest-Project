import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/home/domain/repository/activity_repository.dart';
import 'package:thrill_quest/app/use_case/use_case.dart';

class DeleteActivityParams extends Equatable {
  final String id;

  const DeleteActivityParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class DeleteActivityUseCase implements UseCaseWithParams<void, DeleteActivityParams> {
  final IActivityRepository repository;

  DeleteActivityUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(DeleteActivityParams params) {
    return repository.deleteActivity(params.id);
  }
}
