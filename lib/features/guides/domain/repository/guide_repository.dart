import 'package:dartz/dartz.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/guides/domain/entity/guide_entity.dart';

abstract interface class IGuideRepository {
  Future<Either<Failure, List<GuideEntity>>> getAllGuides({
    String search,
    String? status,
    int page,
    int limit,
  });

  Future<Either<Failure, void>> cacheGuides(List<GuideEntity> guides);
}
