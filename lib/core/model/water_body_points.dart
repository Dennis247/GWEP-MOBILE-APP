import 'package:intl/intl.dart';

import '../data/tables/water_point_data/water_body_point_table.dart';
import '../utils/constants.dart';

class WaterBodyPointsData {
  List<WaterBodyPoint>? data;
  bool? succeeded;
  String? message;

  WaterBodyPointsData({this.data, this.succeeded, this.message});

  WaterBodyPointsData.fromJson(Map<String, dynamic> json) {
    data = <WaterBodyPoint>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data!.add(WaterBodyPoint.fromJson(v));
      });
    }
    succeeded = json['succeeded'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['succeeded'] = succeeded;
    data['message'] = message;
    return data;
  }
}

class WaterBodyPoint {
  String? objectid;
  String? uniquEID;
  String? confidence;
  num? latitude;
  num? longitude;
  String? phase;
  num? areASQM;
  num? shapELeng;
  num? shapEArea;
  dynamic lastUpdatedBy;
  dynamic lastUpdatedByName;
  bool? isWaterBodyPresent;
  bool? hasBeenVisited;
  String? lastTimeVisisted;
  String? lastVisistedBy;
  num? id;
  String? created;
  String? lastUpdatedDate;
  String? depression;
  String? waterBodyStatus;
  String? hubName;
  String? hubArea;
  bool? isAbateKnownPoint;
  String? abatePointDetails;

  DateTime get formattedDate {
    if (created!.isEmpty) {
      return DateTime(2000, 1, 1);
    }
    return DateTime.parse(created!);
  }

  DateTime get lastSyncUpdateDate {
    return DateTime.parse(lastUpdatedDate!);
  }

  String get formattedlastUpdatedDate {
    if (lastUpdatedDate == Constants.oldDate) {
      return '';
    }

    var result =
        DateFormat.yMMMMEEEEd().format(DateTime.parse(lastUpdatedDate!));
    return result;
  }

  WaterBodyPoint(
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

  WaterBodyPoint.fromJson(Map<String, dynamic> json) {
    objectid = json['objectid'];
    uniquEID = json['uniquE_ID'];
    confidence = json['confidence'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    phase = json['phase'];
    areASQM = json['areA_SQM'];
    shapELeng = json['shapE_Leng'];
    shapEArea = json['shapE_Area'];
    lastUpdatedBy = json['lastUpdatedBy'] ?? 0;
    lastUpdatedByName = json['lastUpdatedByName'] ?? '';
    isWaterBodyPresent = json['isWaterBodyPresent'];
    hasBeenVisited = json['hasBeenVisited'];
    lastTimeVisisted = json['lastTimeVisisted'] ?? Constants.oldDate;
    lastVisistedBy = json['lastVisistedBy'];
    id = json['id'];
    created = json['created'] ?? Constants.oldDate;
    lastUpdatedDate = json['lastUpdatedDate'] ?? Constants.oldDate;
    depression = json['depression'];
    waterBodyStatus = json['waterBodyStatus'] ?? '';
    hubName = json['hubName'] ?? '';
    hubArea = json['hubArea'] ?? '';
    isAbateKnownPoint = json['isAbateKnownPoint'] ?? false;
    abatePointDetails = json['abatePointDetails'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['objectid'] = this.objectid;
    data['uniquE_ID'] = this.uniquEID;
    data['confidence'] = this.confidence;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['phase'] = this.phase;
    data['areA_SQM'] = this.areASQM;
    data['shapE_Leng'] = this.shapELeng;
    data['shapE_Area'] = this.shapEArea;
    data['lastUpdatedBy'] = this.lastUpdatedBy;
    data['lastUpdatedByName'] = this.lastUpdatedByName;
    data['isWaterBodyPresent'] = this.isWaterBodyPresent;
    data['hasBeenVisited'] = this.hasBeenVisited;
    data['lastTimeVisisted'] = this.lastTimeVisisted;
    data['lastVisistedBy'] = this.lastVisistedBy;
    data['id'] = this.id;
    data['created'] = this.created;
    data['lastUpdatedDate'] = this.lastUpdatedDate;
    data['depression'] = this.depression;
    data['waterBodyStatus'] = this.waterBodyStatus;
    data['hubName'] = this.hubName;
    data['hubArea'] = this.hubArea;
    data['isAbateKnownPoint'] = isAbateKnownPoint;
    data['abatePointDetails'] = abatePointDetails;
    return data;
  }

  static WaterBodyPointTable getWaterTableDataFromData(
      WaterBodyPoint waterBodyPoint) {
    return WaterBodyPointTable(
        areASQM: waterBodyPoint.areASQM,
        confidence: waterBodyPoint.confidence,
        created: waterBodyPoint.created,
        hasBeenVisited: waterBodyPoint.hasBeenVisited,
        id: waterBodyPoint.id,
        isWaterBodyPresent: waterBodyPoint.isWaterBodyPresent,
        lastTimeVisisted: waterBodyPoint.lastTimeVisisted,
        lastUpdatedBy: waterBodyPoint.lastUpdatedBy,
        lastUpdatedByName: waterBodyPoint.lastUpdatedByName,
        lastVisistedBy: waterBodyPoint.lastVisistedBy,
        latitude: waterBodyPoint.latitude,
        longitude: waterBodyPoint.longitude,
        objectid: waterBodyPoint.objectid,
        phase: waterBodyPoint.phase,
        shapEArea: waterBodyPoint.areASQM,
        shapELeng: waterBodyPoint.shapELeng,
        lastUpdatedDate: waterBodyPoint.lastUpdatedDate,
        uniquEID: waterBodyPoint.uniquEID,
        depression: waterBodyPoint.depression,
        waterBodyStatus: waterBodyPoint.waterBodyStatus,
        hubName: waterBodyPoint.hubName ?? '',
        hubArea: waterBodyPoint.hubArea ?? '',
        isAbateKnownPoint: waterBodyPoint.isAbateKnownPoint ?? false,
        abatePointDetails: waterBodyPoint.abatePointDetails);
  }

  static List<WaterBodyPointTable> getWaterBodyTableFromWaterBody(
      List<WaterBodyPoint> waterBodyData) {
    var result = waterBodyData
        .map((wd) => WaterBodyPointTable(
            id: wd.id,
            areASQM: wd.areASQM,
            confidence: wd.confidence,
            created: wd.created,
            hasBeenVisited: wd.hasBeenVisited,
            isWaterBodyPresent: wd.isWaterBodyPresent,
            lastTimeVisisted: wd.lastTimeVisisted,
            lastUpdatedBy: wd.lastUpdatedBy,
            lastUpdatedByName: wd.lastUpdatedByName,
            lastVisistedBy: wd.lastVisistedBy,
            latitude: wd.latitude,
            longitude: wd.longitude,
            objectid: wd.objectid,
            phase: wd.phase,
            shapEArea: wd.shapEArea,
            shapELeng: wd.shapELeng,
            uniquEID: wd.uniquEID,
            lastUpdatedDate: wd.lastUpdatedDate,
            depression: wd.depression,
            waterBodyStatus: wd.waterBodyStatus,
            hubName: wd.hubName ?? '',
            hubArea: wd.hubArea ?? '',
            isAbateKnownPoint: wd.isAbateKnownPoint ?? false,
            abatePointDetails: wd.abatePointDetails))
        .toList();
    return result;
  }

  static List<WaterBodyPoint> getWaterBodyromWaterBodyTable(
      List<WaterBodyPointTable> waterBodyData) {
    var result = waterBodyData
        .map((wd) => WaterBodyPoint(
            id: wd.id,
            areASQM: wd.areASQM,
            confidence: wd.confidence,
            created: wd.created,
            hasBeenVisited: wd.hasBeenVisited,
            isWaterBodyPresent: wd.isWaterBodyPresent,
            lastTimeVisisted: wd.lastTimeVisisted,
            lastUpdatedBy: wd.lastUpdatedBy,
            lastUpdatedByName: wd.lastUpdatedByName,
            lastVisistedBy: wd.lastVisistedBy,
            latitude: wd.latitude,
            longitude: wd.longitude,
            objectid: wd.objectid,
            phase: wd.phase,
            shapEArea: wd.shapEArea,
            shapELeng: wd.shapELeng,
            uniquEID: wd.uniquEID,
            lastUpdatedDate: wd.lastUpdatedDate,
            depression: wd.depression,
            waterBodyStatus: wd.waterBodyStatus,
            hubName: wd.hubName ?? '',
            hubArea: wd.hubArea ?? '',
            isAbateKnownPoint: wd.isAbateKnownPoint ?? false,
            abatePointDetails: wd.abatePointDetails))
        .toList();
    return result;
  }
}
