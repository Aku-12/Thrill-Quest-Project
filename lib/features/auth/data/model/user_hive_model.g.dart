// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserHiveModelAdapter extends TypeAdapter<UserHiveModel> {
  @override
  final int typeId = 0;

  @override
  UserHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserHiveModel(
      userId: fields[0] as String?,
      fName: fields[1] as String,
      lName: fields[2] as String?,
      email: fields[3] as String,
      phoneNo: fields[4] as String?,
      password: fields[5] as String?,
      role: fields[6] as String?,
      profileImage: fields[7] as String?,
      favorites: (fields[8] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserHiveModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.fName)
      ..writeByte(2)
      ..write(obj.lName)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.phoneNo)
      ..writeByte(5)
      ..write(obj.password)
      ..writeByte(6)
      ..write(obj.role)
      ..writeByte(7)
      ..write(obj.profileImage)
      ..writeByte(8)
      ..write(obj.favorites);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
