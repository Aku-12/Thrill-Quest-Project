import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:thrill_quest/features/home/domain/entity/activity_entity.dart';


part 'activity_api_model.g.dart';

@JsonSerializable()
class ActivityApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String name;
  final String location;
  final List<String>? images;
  final double price;
  final String duration;
  final String difficulty;
  final int bookings;
  final double rating;
  final String status;

  const ActivityApiModel({
    this.id,
    required this.name,
    required this.location,
    this.images,
    required this.price,
    required this.duration,
    required this.difficulty,
    required this.bookings,
    required this.rating,
    required this.status,
  });

  factory ActivityApiModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityApiModelToJson(this);

  ActivityEntity toEntity() {
    return ActivityEntity(
      id: id ?? '',
      name: name,
      location: location,
      images: images,
      price: price,
      duration: duration,
      difficulty: difficulty,
      bookings: bookings,
      rating: rating,
      status: status,
    );
  }

  factory ActivityApiModel.fromEntity(ActivityEntity entity) {
    return ActivityApiModel(
      id: entity.id,
      name: entity.name,
      location: entity.location,
      images: entity.images,
      price: entity.price,
      duration: entity.duration,
      difficulty: entity.difficulty,
      bookings: entity.bookings,
      rating: entity.rating,
      status: entity.status,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        location,
        images,
        price,
        duration,
        difficulty,
        bookings,
        rating,
        status,
      ];
}
