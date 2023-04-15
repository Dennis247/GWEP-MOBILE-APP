// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_body_point_table.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WaterBodyPointTableAdapter extends TypeAdapter<WaterBodyPointTable> {
  @override
  final int typeId = 0;

  @override
  WaterBodyPointTable read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WaterBodyPointTable(
      objectid: fields[1] as String?,
      uniquEID: fields[2] as String?,
      confidence: fields[3] as String?,
      latitude: fields[4] as num?,
      longitude: fields[5] as num?,
      phase: fields[6] as String?,
      areASQM: fields[7] as num?,
      shapELeng: fields[8] as num?,
      shapEArea: fields[9] as num?,
      lastUpdatedBy: fields[10] as dynamic,
      lastUpdatedByName: fields[11] as dynamic,
      isWaterBodyPresent: fields[12] as bool?,
      hasBeenVisited: fields[13] as bool?,
      lastTimeVisisted: fields[14] as dynamic,
      lastVisistedBy: fields[15] as dynamic,
      id: fields[0] as num?,
      created: fields[16] as String?,
      lastUpdatedDate: fields[17] as String?,
      depression: fields[18] as String?,
      waterBodyStatus: fields[19] as String?,
      hubName: fields[20] as String?,
      hubArea: fields[21] as String?,
      isAbateKnownPoint: fields[22] as bool?,
      abatePointDetails: fields[23] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WaterBodyPointTable obj) {
    writer
      ..writeByte(24)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.objectid)
      ..writeByte(2)
      ..write(obj.uniquEID)
      ..writeByte(3)
      ..write(obj.confidence)
      ..writeByte(4)
      ..write(obj.latitude)
      ..writeByte(5)
      ..write(obj.longitude)
      ..writeByte(6)
      ..write(obj.phase)
      ..writeByte(7)
      ..write(obj.areASQM)
      ..writeByte(8)
      ..write(obj.shapELeng)
      ..writeByte(9)
      ..write(obj.shapEArea)
      ..writeByte(10)
      ..write(obj.lastUpdatedBy)
      ..writeByte(11)
      ..write(obj.lastUpdatedByName)
      ..writeByte(12)
      ..write(obj.isWaterBodyPresent)
      ..writeByte(13)
      ..write(obj.hasBeenVisited)
      ..writeByte(14)
      ..write(obj.lastTimeVisisted)
      ..writeByte(15)
      ..write(obj.lastVisistedBy)
      ..writeByte(16)
      ..write(obj.created)
      ..writeByte(17)
      ..write(obj.lastUpdatedDate)
      ..writeByte(18)
      ..write(obj.depression)
      ..writeByte(19)
      ..write(obj.waterBodyStatus)
      ..writeByte(20)
      ..write(obj.hubName)
      ..writeByte(21)
      ..write(obj.hubArea)
      ..writeByte(22)
      ..write(obj.isAbateKnownPoint)
      ..writeByte(23)
      ..write(obj.abatePointDetails);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaterBodyPointTableAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
