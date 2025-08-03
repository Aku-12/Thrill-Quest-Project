import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:thrill_quest/features/bookings/domain/entity/bookings_entity.dart';

part 'bookings_api_model.g.dart';

@JsonSerializable()
class BookingsApiModel extends Equatable {
  // --- Optional Fields ---
  @JsonKey(name: '_id')
  final String? id;
  final String? activityName;
  final List<String>? images;   // <-- ADDED
  final String? location;       // <-- ADDED
  final num? price;             // <-- ADDED
  final String? duration;         // <-- ADDED

  // --- Required Fields ---
  final String activityId;
  final String customerName;
  final String guideName;
  final DateTime tourDate;
  final String paymentStatus;
  final String bookingStatus;
  @JsonKey(name: 'userId')
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BookingsApiModel({
    // Optional
    this.id,
    this.activityName,
    this.images,              // <-- ADDED
    this.location,            // <-- ADDED
    this.price,               // <-- ADDED
    this.duration,            // <-- ADDED
    // Required
    required this.activityId,
    required this.customerName,
    required this.guideName,
    required this.tourDate,
    required this.paymentStatus,
    required this.bookingStatus,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookingsApiModel.fromJson(Map<String, dynamic> json) {
    final dynamic rawActivity = json['activity'];
    
    // Parsed variables
    String parsedActivityId;
    String? parsedActivityName;
    List<String>? parsedImages;
    String? parsedLocation;
    num? parsedPrice;
    String? parsedDuration;

    if (rawActivity is Map<String, dynamic>) {
      parsedActivityId = rawActivity['_id'] as String? ?? '';
      parsedActivityName = rawActivity['name'] as String?;
      // Safely parse the new optional fields
      parsedImages = (rawActivity['images'] as List<dynamic>?)?.cast<String>();
      parsedLocation = rawActivity['location'] as String?;
      parsedPrice = rawActivity['price'] as num?;
      parsedDuration = rawActivity['duration'] as String?;
    } else if (rawActivity is String) {
      parsedActivityId = rawActivity;
      // Other fields are null since they weren't populated
      parsedActivityName = null;
      parsedImages = null;
      parsedLocation = null;
      parsedPrice = null;
      parsedDuration = null;
    } else {
      parsedActivityId = '';
      parsedActivityName = null;
      parsedImages = null;
      parsedLocation = null;
      parsedPrice = null;
      parsedDuration = null;
    }

    return BookingsApiModel(
      id: json['_id'] as String?,
      activityId: parsedActivityId,
      activityName: parsedActivityName,
      images: parsedImages,
      location: parsedLocation,
      price: parsedPrice,
      duration: parsedDuration,
      customerName: json['customerName'] as String,
      guideName: json['guideName'] as String,
      tourDate: DateTime.parse(json['tourDate'] as String),
      paymentStatus: json['paymentStatus'] as String,
      bookingStatus: json['bookingStatus'] as String,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => _$BookingsApiModelToJson(this);

  BookingsEntity toEntity() {
    return BookingsEntity(
      id: id,
      activityName: activityName,
      images: images,
      location: location,
      price: price,
      duration: duration,
      activityId: activityId,
      customerName: customerName,
      guideName: guideName,
      tourDate: tourDate,
      paymentStatus: paymentStatus,
      bookingStatus: bookingStatus,
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory BookingsApiModel.fromEntity(BookingsEntity entity) {
    return BookingsApiModel(
      id: entity.id,
      activityName: entity.activityName,
      images: entity.images,
      location: entity.location,
      price: entity.price,
      duration: entity.duration,
      activityId: entity.activityId,
      customerName: entity.customerName,
      guideName: entity.guideName,
      tourDate: entity.tourDate,
      paymentStatus: entity.paymentStatus,
      bookingStatus: entity.bookingStatus,
      userId: entity.userId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        activityName,
        images,
        location,
        price,
        duration,
        activityId,
        customerName,
        guideName,
        tourDate,
        paymentStatus,
        bookingStatus,
        userId,
        createdAt,
        updatedAt,
      ];
}