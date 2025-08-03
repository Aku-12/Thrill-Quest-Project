// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityApiModel _$ActivityApiModelFromJson(Map<String, dynamic> json) =>
    ActivityApiModel(
      id: json['_id'] as String?,
      name: json['name'] as String,
      location: json['location'] as String,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      price: (json['price'] as num).toDouble(),
      duration: json['duration'] as String,
      difficulty: json['difficulty'] as String,
      bookings: (json['bookings'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
      status: json['status'] as String,
    );

Map<String, dynamic> _$ActivityApiModelToJson(ActivityApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'images': instance.images,
      'price': instance.price,
      'duration': instance.duration,
      'difficulty': instance.difficulty,
      'bookings': instance.bookings,
      'rating': instance.rating,
      'status': instance.status,
    };
