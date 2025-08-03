import 'package:dartz/dartz.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/core/utils/internet_checker.dart';
import 'package:thrill_quest/features/guides/data/repository/guide_local_repository.dart';
import 'package:thrill_quest/features/guides/data/repository/guide_remote_repository.dart';
import 'package:thrill_quest/features/guides/domain/entity/guide_entity.dart';
import 'package:thrill_quest/features/guides/domain/repository/guide_repository.dart';

class GuideRepositoryImpl implements IGuideRepository {
  final GuideRemoteRepository _remoteRepository;
  final GuideLocalRepository _localRepository;
  final InternetChecker _internetChecker;

  GuideRepositoryImpl({
    required GuideRemoteRepository remoteRepository,
    required GuideLocalRepository localRepository,
    required InternetChecker internetChecker,
  }) : _remoteRepository = remoteRepository,
       _localRepository = localRepository,
       _internetChecker = internetChecker;

  @override
  Future<Either<Failure, List<GuideEntity>>> getAllGuides({
    String search = '',
    String? status,
    int page = 1,
    int limit = 10,
  }) async {
    final isOnline = await _internetChecker.isConnected();
    if (isOnline) {
      final remoteResult = await _remoteRepository.getAllGuides(
        search: search,
        status: status,
        page: page,
        limit: limit,
      );
      return remoteResult.fold(
        (failure) async {
          return _localRepository.getAllGuides(
            search: search,
            status: status,
            page: page,
            limit: limit,
          );
        },
        (guides) async {
          await _localRepository.cacheGuides(guides);
          return Right(guides);
        },
      );
    } else {
      return _localRepository.getAllGuides(
        search: search,
        status: status,
        page: page,
        limit: limit,
      );
    }
  }

  @override
  Future<Either<Failure, void>> cacheGuides(List<GuideEntity> guides) async {
    return _localRepository.cacheGuides(guides);
  }
}
