import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thrill_quest/app/use_case/use_case.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/review/domain/entity/review_entity.dart';
import 'package:thrill_quest/features/review/domain/repository/review_repository.dart';

class GetActivityReviewsParams extends Equatable {
  final String activityId;

  const GetActivityReviewsParams({required this.activityId});

  @override
  List<Object?> get props => [activityId];
}

class GetActivityReviewsUseCase
    implements UseCaseWithParams<List<ReviewEntity>, GetActivityReviewsParams> {
  final IReviewRepository repository;

  GetActivityReviewsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<ReviewEntity>>> call(GetActivityReviewsParams params) {
    return repository.getActivityReviews(params.activityId);
  }
}
