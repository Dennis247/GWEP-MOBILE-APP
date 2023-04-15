import 'package:hive/hive.dart';

part 'water_body_point_table.g.dart';

@HiveType(typeId: 0)
class WaterBodyPointTable {
  @HiveField(0)
  num? id;

  @HiveField(1)
  String? objectid;

  @HiveField(2)
  String? uniquEID;

  @HiveField(3)
  String? confidence;

  @HiveField(4)
  num? latitude;

  @HiveField(5)
  num? longitude;

  @HiveField(6)
  String? phase;

  @HiveField(7)
  num? areASQM;

  @HiveField(8)
  num? shapELeng;

  @HiveField(9)
  num? shapEArea;

  @HiveField(10)
  dynamic lastUpdatedBy;

  @HiveField(11)
  dynamic lastUpdatedByName;

  @HiveField(12)
  bool? isWaterBodyPresent;

  @HiveField(13)
  bool? hasBeenVisited;

  @HiveField(14)
  dynamic lastTimeVisisted;

  @HiveField(15)
  dynamic lastVisistedBy;

  @HiveField(16)
  String? created;

  @HiveField(17)
  String? lastUpdatedDate;

  @HiveField(18)
  String? depression;

  @HiveField(19)
  String? waterBodyStatus;

  @HiveField(20)
  String? hubName;

  @HiveField(21)
  String? hubArea;

  @HiveField(22)
  bool? isAbateKnownPoint;

  @HiveField(23)
  String? abatePointDetails;

  WaterBodyPointTable(
      {this.objectid,
      this.uniquEID,
      this.confidence,
      this.latitude,
      this.longitude,
      this.phase,
      this.areASQM,
      this.shapELeng,
      this.shapEArea,
      this.lastUpdatedBy,
      this.lastUpdatedByName,
      this.isWaterBodyPresent,
      this.hasBeenVisited,
      this.lastTimeVisisted,
      this.lastVisistedBy,
      this.id,
      this.created,
      this.lastUpdatedDate,
      this.depression,
      this.waterBodyStatus,
      this.hubName,
      this.hubArea,
      this.isAbateKnownPoint,
      this.abatePointDetails});
}
