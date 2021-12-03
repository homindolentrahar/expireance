// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expire_item_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpireItemEntityAdapter extends TypeAdapter<ExpireItemEntity> {
  @override
  final int typeId = 101;

  @override
  ExpireItemEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpireItemEntity(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as int,
      fields[4] as String,
      fields[5] as String,
      fields[6] as ExpireCategoryEntity,
    );
  }

  @override
  void write(BinaryWriter writer, ExpireItemEntity obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.desc)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.image)
      ..writeByte(6)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpireItemEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
