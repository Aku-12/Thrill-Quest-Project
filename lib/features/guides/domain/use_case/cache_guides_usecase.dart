import 'package:dartz/dartz.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/guides/domain/entity/guide_entity.dart';
import 'package:thrill_quest/features/guides/domain/repository/guide_repository.dart';

class CacheGuidesUsecase {
  final IGuideRepository _repository;

  CacheGuidesUsecase(this._repository);

  Future<Either<Failure, void>> call(List<GuideEntity> guides) {
    return _repository.cacheGuides(guides);
  }
}