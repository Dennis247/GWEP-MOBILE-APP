class WaterBodyDetailsData {
  int? pageNumber;
  int? pageSize;
  String? firstPage;
  String? lastPage;
  int? totalPages;
  int? totalRecords;
  String? nextPage;
  dynamic previousPage;
  WaterBodyDetails? data;
  bool? succeeded;
  String? message;

  WaterBodyDetailsData(
      {this.pageNumber,
      this.pageSize,
      this.firstPage,
      this.lastPage,
      this.totalPages,
      this.totalRecords,
      this.nextPage,
      this.previousPage,
      this.data,
      this.succeeded,
      this.message});

  WaterBodyDetailsData.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    firstPage = json['firstPage'];
    lastPage = json['lastPage'];
    totalPages = json['totalPages'];
    totalRecords = json['totalRecords'];
    nextPage = json['nextPage'];
    previousPage = json['previousPage'];
    data =
        json['data'] != null ? WaterBodyDetails.fromJson(json['data']) : null;
    succeeded = json['succeeded'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    data['firstPage'] = this.firstPage;
    data['lastPage'] = this.lastPage;
    data['totalPages'] = this.totalPages;
    data['totalRecords'] = this.totalRecords;
    data['nextPage'] = this.nextPage;
    data['previousPage'] = this.previousPage;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['succeeded'] = this.succeeded;
    data['message'] = this.message;
    return data;
  }
}

class WaterBodyDetails {
  String? type;
  String? name;
  Crs? crs;
  List<Features>? features;

  WaterBodyDetails({this.type, this.name, this.crs, this.features});

  WaterBodyDetails.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
    crs = json['crs'] != null ? new Crs.fromJson(json['crs']) : null;
    if (json['features'] != null) {
      features = <Features>[];
      json['features'].forEach((v) {
        features!.add(new Features.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['name'] = this.name;
    if (this.crs != null) {
      data['crs'] = this.crs!.toJson();
    }
    if (this.features != null) {
      data['features'] = this.features!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Crs {
  String? type;
  Properties? properties;

  Crs({this.type, this.properties});

  Crs.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    properties = json['properties'] != null
        ? new Properties.fromJson(json['properties'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.properties != null) {
      data['properties'] = this.properties!.toJson();
    }
    return data;
  }
}

class Properties {
  String? name;
  num? objectid;
  dynamic uniquEID;
  dynamic phase;
  dynamic confidence;
  num? latitude;
  num? longitude;
  num? areASQM;
  num? shapELength;
  num? shapEArea;
  num? objectiD2;
  dynamic uniquEID2;
  dynamic phasE2;
  dynamic confidencE2;
  num? latitudE2;
  num? longitudE2;
  num? areASQM2;
  num? shapELength2;
  num? shapEArea2;
  dynamic hubName;
  num? hubDist;
  dynamic direction;

  Properties(
      {this.name,
      this.objectid,
      this.uniquEID,
      this.phase,
      this.confidence,
      this.latitude,
      this.longitude,
      this.areASQM,
      this.shapELength,
      this.shapEArea,
      this.objectiD2,
      this.uniquEID2,
      this.phasE2,
      this.confidencE2,
      this.latitudE2,
      this.longitudE2,
      this.areASQM2,
      this.shapELength2,
      this.shapEArea2,
      this.hubName,
      this.hubDist,
      this.direction});

  Properties.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    objectid = json['objectid'];
    uniquEID = json['uniquE_ID'];
    phase = json['phase'];
    confidence = json['confidence'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    areASQM = json['areA_SQM'];
    shapELength = json['shapE_Length'];
    shapEArea = json['shapE_Area'];
    objectiD2 = json['objectiD_2'];
    uniquEID2 = json['uniquE_ID_2'];
    phasE2 = json['phasE_2'];
    confidencE2 = json['confidencE_2'];
    latitudE2 = json['latitudE_2'];
    longitudE2 = json['longitudE_2'];
    areASQM2 = json['areA_SQM_2'];
    shapELength2 = json['shapE_Length_2'];
    shapEArea2 = json['shapE_Area_2'];
    hubName = json['hubName'];
    hubDist = json['hubDist'];
    direction = json['direction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['objectid'] = this.objectid;
    data['uniquE_ID'] = this.uniquEID;
    data['phase'] = this.phase;
    data['confidence'] = this.confidence;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['areA_SQM'] = this.areASQM;
    data['shapE_Length'] = this.shapELength;
    data['shapE_Area'] = this.shapEArea;
    data['objectiD_2'] = this.objectiD2;
    data['uniquE_ID_2'] = this.uniquEID2;
    data['phasE_2'] = this.phasE2;
    data['confidencE_2'] = this.confidencE2;
    data['latitudE_2'] = this.latitudE2;
    data['longitudE_2'] = this.longitudE2;
    data['areA_SQM_2'] = this.areASQM2;
    data['shapE_Length_2'] = this.shapELength2;
    data['shapE_Area_2'] = this.shapEArea2;
    data['hubName'] = this.hubName;
    data['hubDist'] = this.hubDist;
    data['direction'] = this.direction;
    return data;
  }
}

class Features {
  String? type;
  Properties? properties;
  Geometry? geometry;

  Features({this.type, this.properties, this.geometry});

  Features.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    properties = json['properties'] != null
        ? new Properties.fromJson(json['properties'])
        : null;
    geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.properties != null) {
      data['properties'] = this.properties!.toJson();
    }
    if (this.geometry != null) {
      data['geometry'] = this.geometry!.toJson();
    }
    return data;
  }
}

// class Properties {
//   dynamic name;
//   int? objectid;
//   String? uniquEID;
//   String? phase;
//   String? confidence;
//   num? latitude;
//   double? longitude;
//   double? areASQM;
//   double? shapELength;
//   double? shapEArea;
//   int? objectiD2;
//   String? uniquEID2;
//   String? phasE2;
//   String? confidencE2;
//   double? latitudE2;
//   double? longitudE2;
//   double? areASQM2;
//   double? shapELength2;
//   double? shapEArea2;
//   String? hubName;
//   double? hubDist;
//   String? direction;

//   Properties(
//       {this.name,
//       this.objectid,
//       this.uniquEID,
//       this.phase,
//       this.confidence,
//       this.latitude,
//       this.longitude,
//       this.areASQM,
//       this.shapELength,
//       this.shapEArea,
//       this.objectiD2,
//       this.uniquEID2,
//       this.phasE2,
//       this.confidencE2,
//       this.latitudE2,
//       this.longitudE2,
//       this.areASQM2,
//       this.shapELength2,
//       this.shapEArea2,
//       this.hubName,
//       this.hubDist,
//       this.direction});

//   Properties.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     objectid = json['objectid'];
//     uniquEID = json['uniquE_ID'];
//     phase = json['phase'];
//     confidence = json['confidence'];
//     latitude = json['latitude'];
//     longitude = json['longitude'];
//     areASQM = json['areA_SQM'];
//     shapELength = json['shapE_Length'];
//     shapEArea = json['shapE_Area'];
//     objectiD2 = json['objectiD_2'];
//     uniquEID2 = json['uniquE_ID_2'];
//     phasE2 = json['phasE_2'];
//     confidencE2 = json['confidencE_2'];
//     latitudE2 = json['latitudE_2'];
//     longitudE2 = json['longitudE_2'];
//     areASQM2 = json['areA_SQM_2'];
//     shapELength2 = json['shapE_Length_2'];
//     shapEArea2 = json['shapE_Area_2'];
//     hubName = json['hubName'];
//     hubDist = json['hubDist'];
//     direction = json['direction'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.name;
//     data['objectid'] = this.objectid;
//     data['uniquE_ID'] = this.uniquEID;
//     data['phase'] = this.phase;
//     data['confidence'] = this.confidence;
//     data['latitude'] = this.latitude;
//     data['longitude'] = this.longitude;
//     data['areA_SQM'] = this.areASQM;
//     data['shapE_Length'] = this.shapELength;
//     data['shapE_Area'] = this.shapEArea;
//     data['objectiD_2'] = this.objectiD2;
//     data['uniquE_ID_2'] = this.uniquEID2;
//     data['phasE_2'] = this.phasE2;
//     data['confidencE_2'] = this.confidencE2;
//     data['latitudE_2'] = this.latitudE2;
//     data['longitudE_2'] = this.longitudE2;
//     data['areA_SQM_2'] = this.areASQM2;
//     data['shapE_Length_2'] = this.shapELength2;
//     data['shapE_Area_2'] = this.shapEArea2;
//     data['hubName'] = this.hubName;
//     data['hubDist'] = this.hubDist;
//     data['direction'] = this.direction;
//     return data;
//   }
// }

class Geometry {
  String? type;
  List<double>? coordinates;

  Geometry({this.type, this.coordinates});

  Geometry.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    return data;
  }
}
