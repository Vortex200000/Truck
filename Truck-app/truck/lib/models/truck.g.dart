// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'truck.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TruckAdapter extends TypeAdapter<Truck> {
  @override
  final int typeId = 1;

  @override
  Truck read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Truck(
      truckName: fields[0] as String,
      thumbnailImageUrl: fields[1] as String?,
      foodList: (fields[2] as List?)?.cast<FoodItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, Truck obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.truckName)
      ..writeByte(1)
      ..write(obj.thumbnailImageUrl)
      ..writeByte(2)
      ..write(obj.foodList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TruckAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
