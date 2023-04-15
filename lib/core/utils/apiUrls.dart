// ignore_for_file: file_names

class ApiUrls {
  static bool isLive = true;
  static String baseUrl = isLive
      ? 'http://deeosasdevfrica-001-site1.itempurl.com/api'
      : 'http://192.168.207.51/catalogue/api';
  static String waterdetections =
      "$baseUrl/WaterDetection/GetUploadedWaterDetections";
  static String getWaterBodyDetails =
      "$baseUrl/WaterDetection/GetWaterBodyDetails?name=NAME&pageNumber=PGNUMBER&pageSize=10";

  static String getWaterDetailsByName =
      "$baseUrl/WaterDetection/GetWaterBodyDataByName?name=";

  static String updateWaterBodyPresence =
      "$baseUrl/WaterDetection/UpdateWaterBodyPresence";

  static String updateWaterBodyVisitation =
      "$baseUrl/WaterDetection/UpdateWaterBodyVisitation";

  //water points data

  static String getAllWaterPointData = "$baseUrl/WaterPoint/GetAllWaterPoints";
  static String updateWaterPointPresence =
      "$baseUrl/WaterPoint/UpdateWaterBodyPresence";

  static String updateWaterPointVisitation =
      "$baseUrl/WaterPoint/UpdateWaterBodyVisitation";

  static String updateWaterBodyDepression =
      "$baseUrl/WaterPoint/UpdateWaterBodyDepression";

  static String updateWaterBodyStatus =
      "$baseUrl/WaterPoint/UpdateWaterBodyStatus";

  static String syncWaterBody = "$baseUrl/DataSync/WaterBodySynchronization";

  //Acount service

  static String validateAccount = "$baseUrl/Account/ValidateAccount";
  static String addAccount = "$baseUrl/Account/AddAccount";

  static String getHubAreas = "$baseUrl/WaterPoint/GetHubAreas";

  static String getWAterPointByHubArea =
      "$baseUrl/WaterPoint/GetWaterBodyPointsByHubArea?areaName=";
}
