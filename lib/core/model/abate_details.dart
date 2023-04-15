class AbatePointDetails {
  String? type;
  String? name;
  dynamic propertyName;
  String? abateCaptain;
  String? woreda;
  String? kebele;
  String? village;
  String? villageCode;
  String? villageSharingWaterSource;
  String? waterSourceName;
  num? latitude;
  num? longitude;
  String? typeofWaterSource;
  String? specialUse;
  String? reasonsforusingwatersource;
  int? id;
  String? created;

  AbatePointDetails(
      {this.type,
      this.name,
      this.propertyName,
      this.abateCaptain,
      this.woreda,
      this.kebele,
      this.village,
      this.villageCode,
      this.villageSharingWaterSource,
      this.waterSourceName,
      this.latitude,
      this.longitude,
      this.typeofWaterSource,
      this.specialUse,
      this.reasonsforusingwatersource,
      this.id,
      this.created});

  AbatePointDetails.fromJson(Map<String, dynamic> json) {
    type = json['type'] ?? '';
    name = json['name'] ?? '';
    propertyName = json['PropertyName'] ?? '';
    abateCaptain = json['AbateCaptain'] ?? '';
    woreda = json['Woreda'] ?? '';
    kebele = json['Kebele'] ?? '';
    village = json['Village'] ?? '';
    villageCode = json['VillageCode'] ?? '';
    villageSharingWaterSource = json['VillageSharingWaterSource'] ?? '';
    waterSourceName = json['WaterSourceName'] ?? '';
    latitude = json['Latitude'] ?? 0.0;
    longitude = json['Longitude'] ?? 0.0;
    typeofWaterSource = json['TypeofWaterSource'] ?? '';
    specialUse = json['SpecialUse'] ?? '';
    reasonsforusingwatersource = json['Reasonsforusingwatersource'] ?? '';
    id = json['Id'] ?? '';
    created = json['Created'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['name'] = this.name;
    data['PropertyName'] = this.propertyName;
    data['AbateCaptain'] = this.abateCaptain;
    data['Woreda'] = this.woreda;
    data['Kebele'] = this.kebele;
    data['Village'] = this.village;
    data['VillageCode'] = this.villageCode;
    data['VillageSharingWaterSource'] = this.villageSharingWaterSource;
    data['WaterSourceName'] = this.waterSourceName;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    data['TypeofWaterSource'] = this.typeofWaterSource;
    data['SpecialUse'] = this.specialUse;
    data['Reasonsforusingwatersource'] = this.reasonsforusingwatersource;
    data['Id'] = this.id;
    data['Created'] = this.created;
    return data;
  }
}
