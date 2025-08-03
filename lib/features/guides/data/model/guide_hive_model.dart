import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:thrill_quest/app/constant/hive/hive_table_constant.dart';
import 'package:thrill_quest/features/guides/domain/entity/guide_entity.dart';
import 'package:uuid/uuid.dart';

part 'guide_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.guidesTableId)
class GuideHiveModel extends Equatable {
  @HiveField(0)
  final String? guideId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final List<String> specialties;

  @HiveField(4)
  final int experience;

  @HiveField(5)
  final int assignedTours;

  @HiveField(6)
  final List<double> ratings;

  @HiveField(7)
  final double averageRating;

  @HiveField(8)
  final String status;

  GuideHiveModel({
    String? guideId,
    required this.name,
    required this.email,
    required this.specialties,
    required this.experience,
    required this.assignedTours,
    required this.ratings,
    required this.averageRating,
    required this.status,
  }) : guideId = guideId ?? const Uuid().v4();

  // Convert from entity
  factory GuideHiveModel.fromEntity(GuideEntity entity) {
    return GuideHiveModel(
      guideId: entity.id,
      name: entity.name,
      email: entity.email,
      specialties: entity.specialties,
      experience: entity.experience,
      assignedTours: entity.assignedTours,
      ratings: entity.ratings,
      averageRating: entity.averageRating,
      status: entity.status,
    );
  }

  // Convert to entity
  GuideEntity toEntity() {
    return GuideEntity(
      id: guideId ?? '',
      name: name,
      email: email,
      specialties: specialties,
      experience: experience,
      assignedTours: assignedTours,
      ratings: ratings,
      averageRating: averageRating,
      status: status,
    );
  }

  @override
  List<Object?> get props => [
        guideId,
        name,
        email,
        specialties,
        experience,
        assignedTours,
        ratings,
        averageRating,
        status,
      ];
}
