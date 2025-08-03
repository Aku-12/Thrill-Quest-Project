import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thrill_quest/app/use_case/use_case.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/review/domain/entity/review_entity.dart';
import 'package:thrill_quest/features/review/domain/repository/review_repository.dart';

class CreateReviewParams extends Equatable {
  final String activityId;
  final double rating;
  final String? comment;

  const CreateReviewParams({
    required this.activityId,
    required this.rating,
    this.comment,
  });

  @override
  List<Object?> get props => [activityId, rating, comment];
}

class CreateReviewUseCase
    implements UseCaseWithParams<ReviewEntity, CreateReviewParams> {
  final IReviewRepository repository;

  CreateReviewUseCase({required this.repository});

  @override
  Future<Either<Failure, ReviewEntity>> call(CreateReviewParams params) {
    return repository.createReview(
      activityId: params.activityId,
      rating: params.rating,
      comment: params.comment,
    );
  }
}
