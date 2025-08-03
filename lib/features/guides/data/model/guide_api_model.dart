import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:thrill_quest/features/guides/domain/entity/guide_entity.dart';

part 'guide_api_model.g.dart';

@JsonSerializable()
class GuideApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String name;
  final String email;
  final List<String> specialties;
  final int experience;
  final int assignedTours;
  final List<double> ratings;
  final double averageRating;
  final String status;

  const GuideApiModel({
    this.id,
    required this.name,
    required this.email,
    required this.specialties,
    required this.experience,
    required this.assignedTours,
    required this.ratings,
    required this.averageRating,
    required this.status,
  });

  factory GuideApiModel.fromJson(Map<String, dynamic> json) =>
      _$GuideApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$GuideApiModelToJson(this);

  GuideEntity toEntity() {
    return GuideEntity(
      id: id ?? '',
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

  factory GuideApiModel.fromEntity(GuideEntity entity) {
    return GuideApiModel(
      id: entity.id,
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

  @override
  List<Object?> get props => [
        id,
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
