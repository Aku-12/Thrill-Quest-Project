import 'package:dartz/dartz.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/core/network/hive_service.dart';
import 'package:thrill_quest/features/guides/data/model/guide_hive_model.dart';
import 'package:thrill_quest/features/guides/domain/entity/guide_entity.dart';
import 'package:thrill_quest/features/guides/domain/repository/guide_repository.dart';

class GuideLocalRepository implements IGuideRepository {
  final HiveService _hiveService;

  GuideLocalRepository({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<Either<Failure, List<GuideEntity>>> getAllGuides({
    String search = '',
    String? status,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final cachedModels = await _hiveService.getCachedGuides();

      final filtered =
          cachedModels
              .where((guide) {
                final matchesSearch =
                    search.isEmpty ||
                    guide.name.toLowerCase().contains(search.toLowerCase());
                final matchesStatus = status == null || guide.status == status;
                return matchesSearch && matchesStatus;
              })
              .skip((page - 1) * limit)
              .take(limit)
              .toList();

      final result = filtered.map((e) => e.toEntity()).toList();
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cacheGuides(List<GuideEntity> guides) async {
    try {
      final hiveModels =
          guides.map((e) => GuideHiveModel.fromEntity(e)).toList();
      await _hiveService.cacheGuides(hiveModels);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
