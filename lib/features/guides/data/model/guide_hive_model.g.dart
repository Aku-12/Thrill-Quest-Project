// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guide_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GuideHiveModelAdapter extends TypeAdapter<GuideHiveModel> {
  @override
  final int typeId = 2;

  @override
  GuideHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GuideHiveModel(
      guideId: fields[0] as String?,
      name: fields[1] as String,
      email: fields[2] as String,
      specialties: (fields[3] as List).cast<String>(),
      experience: fields[4] as int,
      assignedTours: fields[5] as int,
      ratings: (fields[6] as List).cast<double>(),
      averageRating: fields[7] as double,
      status: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GuideHiveModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.guideId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.specialties)
      ..writeByte(4)
      ..write(obj.experience)
      ..writeByte(5)
      ..write(obj.assignedTours)
      ..writeByte(6)
      ..write(obj.ratings)
      ..writeByte(7)
      ..write(obj.averageRating)
      ..writeByte(8)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GuideHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
