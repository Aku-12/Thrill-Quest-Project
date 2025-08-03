import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:thrill_quest/features/review/domain/entity/review_entity.dart';

part 'review_api_model.g.dart';

@JsonSerializable()
class ReviewApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;

  @JsonKey(name: 'activity')
  final String activityId;

  final String userId;
  final String userName;
  final double rating;
  final String? comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ReviewApiModel({
    this.id,
    required this.activityId,
    required this.userId,
    required this.userName,
    required this.rating,
    this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReviewApiModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewApiModelToJson(this);

  ReviewEntity toEntity() {
    return ReviewEntity(
      id: id ?? '',
      activityId: activityId,
      userId: userId,
      userName: userName,
      rating: rating,
      comment: comment,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ReviewApiModel.fromEntity(ReviewEntity entity) {
    return ReviewApiModel(
      id: entity.id,
      activityId: entity.activityId,
      userId: entity.userId,
      userName: entity.userName,
      rating: entity.rating,
      comment: entity.comment,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        activityId,
        userId,
        userName,
        rating,
        comment,
        createdAt,
        updatedAt,
      ];
}
