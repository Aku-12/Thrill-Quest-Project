import 'package:dartz/dartz.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/review/data/data_source/review_data_source.dart';
import 'package:thrill_quest/features/review/domain/entity/review_entity.dart';
import 'package:thrill_quest/features/review/domain/repository/review_repository.dart';

class ReviewRemoteRepository implements IReviewRepository {
  final IReviewDataSource _reviewDataSource;

  ReviewRemoteRepository({required IReviewDataSource reviewDataSource})
      : _reviewDataSource = reviewDataSource;

  @override
  Future<Either<Failure, List<ReviewEntity>>> getActivityReviews(String activityId) async {
    try {
      final reviews = await _reviewDataSource.getActivityReviews(activityId);
      return Right(reviews);
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, ReviewEntity>> createReview({
    required String activityId,
    required double rating,
    String? comment,
  }) async {
    try {
      final review = await _reviewDataSource.createReview(
        activityId: activityId,
        rating: rating,
        comment: comment,
      );
      return Right(review);
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }
}
