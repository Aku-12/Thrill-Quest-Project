import 'package:dartz/dartz.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/guides/domain/entity/guide_entity.dart';
import 'package:thrill_quest/features/guides/domain/repository/guide_repository.dart';

class GetAllGuidesParams {
  final String search;
  final String? status;
  final int page;
  final int limit;

  GetAllGuidesParams({
    this.search = '',
    this.status,
    this.page = 1,
    this.limit = 10,
  });
}

class GetAllGuidesUsecase {
  final IGuideRepository _repository;

  GetAllGuidesUsecase(this._repository);

  Future<Either<Failure, List<GuideEntity>>> call(GetAllGuidesParams params) {
    return _repository.getAllGuides(
      search: params.search,
      status: params.status,
      page: params.page,
      limit: params.limit,
    );
  }
}
