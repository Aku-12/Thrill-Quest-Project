// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookings_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookingsHiveModelAdapter extends TypeAdapter<BookingsHiveModel> {
  @override
  final int typeId = 1;

  @override
  BookingsHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookingsHiveModel(
      bookingId: fields[0] as String?,
      activityId: fields[1] as String,
      customerName: fields[2] as String,
      guideName: fields[3] as String,
      tourDate: fields[4] as DateTime,
      paymentStatus: fields[5] as String,
      bookingStatus: fields[6] as String,
      userId: fields[7] as String,
      createdAt: fields[8] as DateTime,
      updatedAt: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, BookingsHiveModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.bookingId)
      ..writeByte(1)
      ..write(obj.activityId)
      ..writeByte(2)
      ..write(obj.customerName)
      ..writeByte(3)
      ..write(obj.guideName)
      ..writeByte(4)
      ..write(obj.tourDate)
      ..writeByte(5)
      ..write(obj.paymentStatus)
      ..writeByte(6)
      ..write(obj.bookingStatus)
      ..writeByte(7)
      ..write(obj.userId)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingsHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
