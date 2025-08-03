import 'package:dartz/dartz.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/guides/data/data_source/remote_data_source/guide_remote_data_source.dart';
import 'package:thrill_quest/features/guides/domain/entity/guide_entity.dart';
import 'package:thrill_quest/features/guides/domain/repository/guide_repository.dart';

class GuideRemoteRepository implements IGuideRepository {
  final GuideRemoteDataSource _remoteDataSource;

  GuideRemoteRepository({required GuideRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<GuideEntity>>> getAllGuides({
    String search = '',
    String? status,
    int page = 1,
    int limit = 10,
  }) async {
    return await _fetchAndHandle(
      () => _remoteDataSource.getAllGuides(
        search: search,
        status: status,
        page: page,
        limit: limit,
      ),
    );
  }

  Future<Either<Failure, List<GuideEntity>>> _fetchAndHandle(
    Future<List<GuideEntity>> Function() fetchFunction,
  ) async {
    try {
      final guides = await fetchFunction();
      return Right(guides);
    } catch (error) {
      return Left(ApiFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cacheGuides(List<GuideEntity> guides) {
    throw UnimplementedError();
  }
}
