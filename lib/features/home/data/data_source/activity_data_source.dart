import 'package:thrill_quest/features/home/domain/entity/activity_entity.dart';

abstract interface class IActivityDatasource {
  Future<List<ActivityEntity>> getAllActivities();
  Future<ActivityEntity> getActivityById(String id);
  Future<void> createActivity(ActivityEntity activity);
  Future<void> updateActivity(String id, ActivityEntity activity);
  Future<void> deleteActivity(String id);
}
