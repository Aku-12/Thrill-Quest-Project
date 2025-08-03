import 'package:thrill_quest/features/guides/domain/entity/guide_entity.dart';

abstract interface class IGuideDataSource {
  Future<List<GuideEntity>> getAllGuides({
    String search,
    String? status,
    int page,
    int limit,
  });
}
