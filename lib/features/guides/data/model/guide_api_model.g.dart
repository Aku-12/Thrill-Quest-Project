// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guide_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GuideApiModel _$GuideApiModelFromJson(Map<String, dynamic> json) =>
    GuideApiModel(
      id: json['_id'] as String?,
      name: json['name'] as String,
      email: json['email'] as String,
      specialties: (json['specialties'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      experience: (json['experience'] as num).toInt(),
      assignedTours: (json['assignedTours'] as num).toInt(),
      ratings: (json['ratings'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      averageRating: (json['averageRating'] as num).toDouble(),
      status: json['status'] as String,
    );

Map<String, dynamic> _$GuideApiModelToJson(GuideApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'specialties': instance.specialties,
      'experience': instance.experience,
      'assignedTours': instance.assignedTours,
      'ratings': instance.ratings,
      'averageRating': instance.averageRating,
      'status': instance.status,
    };
