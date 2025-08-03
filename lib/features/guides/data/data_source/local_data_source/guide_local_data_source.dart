import 'package:thrill_quest/core/network/hive_service.dart';
import 'package:thrill_quest/features/guides/data/data_source/guide_data_source.dart';
import 'package:thrill_quest/features/guides/domain/entity/guide_entity.dart';

class GuideLocalDataSource implements IGuideDataSource {
  final HiveService _hiveService;

  GuideLocalDataSource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<List<GuideEntity>> getAllGuides({
    String search = '',
    String? status,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final localModels = await _hiveService.getCachedGuides();
      return localModels.map((e) => e.toEntity()).toList();
    } catch (e) {
      throw Exception('Local fetch guides failed: $e');
    }
  }
}
