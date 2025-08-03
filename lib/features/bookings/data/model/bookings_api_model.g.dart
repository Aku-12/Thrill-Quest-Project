// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookings_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingsApiModel _$BookingsApiModelFromJson(Map<String, dynamic> json) =>
    BookingsApiModel(
      id: json['_id'] as String?,
      activityName: json['activityName'] as String?,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      location: json['location'] as String?,
      price: json['price'] as num?,
      duration: json['duration'] as String?,
      activityId: json['activityId'] as String,
      customerName: json['customerName'] as String,
      guideName: json['guideName'] as String,
      tourDate: DateTime.parse(json['tourDate'] as String),
      paymentStatus: json['paymentStatus'] as String,
      bookingStatus: json['bookingStatus'] as String,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$BookingsApiModelToJson(BookingsApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'activityName': instance.activityName,
      'images': instance.images,
      'location': instance.location,
      'price': instance.price,
      'duration': instance.duration,
      'activityId': instance.activityId,
      'customerName': instance.customerName,
      'guideName': instance.guideName,
      'tourDate': instance.tourDate.toIso8601String(),
      'paymentStatus': instance.paymentStatus,
      'bookingStatus': instance.bookingStatus,
      'userId': instance.userId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
