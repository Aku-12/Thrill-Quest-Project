import 'package:equatable/equatable.dart';

class BookingsEntity extends Equatable {
  // --- Optional Fields ---
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
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BookingsEntity({
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