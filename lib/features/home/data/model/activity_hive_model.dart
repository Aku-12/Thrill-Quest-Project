import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:thrill_quest/features/home/data/model/activity_api_model.dart'; // Import the API model
import 'package:thrill_quest/features/home/domain/entity/activity_entity.dart';

part 'activity_hive_model.g.dart';

@HiveType(typeId: 1)
class ActivityHiveModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String location;

  @HiveField(3)
  final List<String> images;

  @HiveField(4)
  final double price;

  @HiveField(5)
  final String duration;

  @HiveField(6)
  final String difficulty;

  @HiveField(7)
  final int bookings;

  @HiveField(8)
  final double rating;

  @HiveField(9)
  final String status;

  const ActivityHiveModel({
    required this.id,
    required this.name,
    required this.location,
    required this.images,
    required this.price,
    required this.duration,
    required this.difficulty,
    required this.bookings,
    required this.rating,
    required this.status,
  });

  factory ActivityHiveModel.fromApiModel(ActivityApiModel apiModel) {
    return ActivityHiveModel(
      id: apiModel.id ?? '', // Use null-aware operator for optional ID
      name: apiModel.name,
      location: apiModel.location,
      images: apiModel.images ?? [], // Use null-aware operator for optional list
      price: apiModel.price,
      duration: apiModel.duration,
      difficulty: apiModel.difficulty,
      bookings: apiModel.bookings,
      rating: apiModel.rating,
      status: apiModel.status,
    );
  }

  // Factory constructor to create a Hive model from a domain entity.
  factory ActivityHiveModel.fromEntity(ActivityEntity entity) {
    return ActivityHiveModel(
      id: entity.id,
      name: entity.name,
      location: entity.location,
      images: entity.images ?? [],
      price: entity.price,
      duration: entity.duration,
      difficulty: entity.difficulty,
      bookings: entity.bookings,
      rating: entity.rating,
      status: entity.status,
    );
  }

  // Method to convert the Hive model back to a domain entity.
  ActivityEntity toEntity() {
    return ActivityEntity(
      id: id,
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
  
  // Method to convert the Hive model back to an API model.
  ActivityApiModel toApiModel() {
    return ActivityApiModel(
      id: id,
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