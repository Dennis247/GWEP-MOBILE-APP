import 'dart:developer';

import '../model/base_response.dart';
import '../model/water_body_points.dart';
import '../utils/apiUrls.dart';
import '../utils/request_helper.dart';
import '../data/dataStore.dart';
import '../data/tables/hubs_data/hub_table_service.dart';
import '../data/tables/water_point_data/water_body_table_service.dart';

class WaterPointService {
  static Future<WaterBodyPointsData> getAllWaterPoints() async {
    try {
      String url = ApiUrls.getAllWaterPointData;
      final json = await RequestHelper.getRequest(url);
      final response = WaterBodyPointsData.fromJson(json);
      return response;
    } catch (e) {
      return WaterBodyPointsData(
          data: null, succeeded: false, message: e.toString());
    }
  }

  static Future<BaseResponse> updateWaterPointPresence(
      {required id, required bool status}) async {
    try {
      String url = ApiUrls.updateWaterPointPresence;
      var values = {
        "isWaterBodyPresent": status,
        "waterBodyId": id,
        "accountId": DataStore.userAccount?.id
      };

      final json = await RequestHelper.postRequest(url, values);
      final response = BaseResponse.fromJson(json);
      return response;
    } catch (e) {
      return BaseResponse(data: null, succeeded: false, message: e.toString());
    }
  }

  static Future<BaseResponse> updateWaterPointVisitation(
      {required id, required bool status}) async {
    try {
      String url = ApiUrls.updateWaterPointVisitation;
      var values = {
        "isVisisted": status,
        "waterBodyId": id,
        "accountId": DataStore.userAccount?.id
      };

      final json = await RequestHelper.postRequest(url, values);
      final response = BaseResponse.fromJson(json);
      return response;
    } catch (e) {
      return BaseResponse(data: null, succeeded: false, message: e.toString());
    }
  }

  static Future<BaseResponse> udpateWaterBodyDepression(
      {required id, required String selectedValue}) async {
    try {
      String url = ApiUrls.updateWaterBodyDepression;
      var values = {
        "depression": selectedValue,
        "waterBodyId": id,
        "accountId": DataStore.userAccount?.id
      };

      final json = await RequestHelper.postRequest(url, values);
      final response = BaseResponse.fromJson(json);
      return response;
    } catch (e) {
      return BaseResponse(data: null, succeeded: false, message: e.toString());
    }
  }

  //update water body status

  static Future<BaseResponse> updateWaterBodyStatus(
      {required id, required String selectedValue}) async {
    try {
      String url = ApiUrls.updateWaterBodyStatus;
      var values = {
        "waterBodyStatus": selectedValue,
        "waterBodyId": id,
        "accountId": DataStore.userAccount?.id
      };

      final json = await RequestHelper.postRequest(url, values);
      final response = BaseResponse.fromJson(json);
      return response;
    } catch (e) {
      return BaseResponse(data: null, succeeded: false, message: e.toString());
    }
  }

  //sync water body data with server
  static Future<BaseResponse> syncWaterBodyDataWithServer() async {
    try {
      // create a list to hold the sync data

      List<WaterBodyPoint> syncList = [];

      // get all local data
      var localData = await WaterTableService.getAllWaterBodyPoints();
      var localWaterBodyData =
          WaterBodyPoint.getWaterBodyromWaterBodyTable(localData);

      //get all server data
      List<WaterBodyPoint> serverData = [];
      String url = ApiUrls.getWAterPointByHubArea + DataStore.selectedHub;
      final json = await RequestHelper.getRequest(url);
      final response = WaterBodyPointsData.fromJson(json);
      if (response.succeeded!) {
        serverData = response.data!;
      }

      //merge local and server data
      for (var i = 0; i < serverData.length; i++) {
        var sData = serverData[i];
        var ldata = localWaterBodyData.firstWhere(
            (element) => element.id == sData.id,
            orElse: () => WaterBodyPoint(id: 0));
        if (ldata.id! > 0) {
          if (sData.lastSyncUpdateDate.isAfter(ldata.lastSyncUpdateDate)) {
            syncList.add(sData);
          } else {
            syncList.add(ldata);
          }
        } else {
          syncList.add(sData);
        }

        //update  sync list to local
      }
      var localDataForUpdate =
          WaterBodyPoint.getWaterBodyTableFromWaterBody(syncList);
      WaterTableService.syncLocalData(localDataForUpdate);

      var syncResult =
          await RequestHelper.postRequest(ApiUrls.syncWaterBody, syncList);
      var syncResp = BaseResponse.fromJson(syncResult);
      if (syncResp.succeeded) {
        return BaseResponse(
            data: null, succeeded: true, message: "Synchronization Completed!");
      } else {
        return BaseResponse(
            data: null,
            succeeded: false,
            message: "Failed to complete Synchronization!");
      }
    } catch (e) {
      return BaseResponse(
          data: null, succeeded: false, message: 'Failed to sync data');
    }
  }

  //sync water body data with server
  static Future<BaseResponse> offlineSyncWithServer() async {
    try {
      // create a list to hold the sync data

      // get all local data
      var localData = await WaterTableService.getALlTableData();
      var localWaterBodyData =
          WaterBodyPoint.getWaterBodyromWaterBodyTable(localData);
      //push local data online for update
      localWaterBodyData = localWaterBodyData
          .where((element) => element.lastUpdatedByName != "")
          .toList();
      var syncResult = await RequestHelper.postRequest(
          ApiUrls.syncWaterBody, localWaterBodyData);
      var syncResp = BaseResponse.fromJson(syncResult);
      if (!syncResp.succeeded) {
        return BaseResponse(
            data: null,
            succeeded: false,
            message: "Failed to complete Synchronization!");
      }

      //get all server data
      List<WaterBodyPoint> serverData = [];
      String url = ApiUrls.getAllWaterPointData;
      final json = await RequestHelper.getRequest(url);
      final response = WaterBodyPointsData.fromJson(json);
      if (response.succeeded!) {
        serverData = response.data!;
        //insert to local db
        var localDataForUpdate =
            WaterBodyPoint.getWaterBodyTableFromWaterBody(serverData);
        WaterTableService.syncLocalData(localDataForUpdate);

        return BaseResponse(
            data: null, succeeded: true, message: "Synchronization Completed!");
      }
      return BaseResponse(
          data: null, succeeded: false, message: 'Failed to sync data');
    } catch (e) {
      return BaseResponse(
          data: null, succeeded: false, message: 'Failed to sync data');
    }
  }

  static Future<void> getHubArea() async {
    try {
      //get from local

      var localHubData = HubTableService.getAllHubTableData();
      DataStore.hubAreas = localHubData;

      if (!DataStore.isOffline) {
        String url = ApiUrls.getHubAreas;
        final json = await RequestHelper.getRequest(url);
        final response = BaseResponse.fromJson(json);
        if (response.succeeded) {
          DataStore.hubAreas = response.data.cast<String>();
          HubTableService.insertHubList(DataStore.hubAreas);
        } else {
          DataStore.hubAreas = localHubData;
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<void> getWaterPointsByHubArea(String area) async {
    try {
      String url = ApiUrls.getWAterPointByHubArea + area;

      final json = await RequestHelper.getRequest(url);
      final response = BaseResponse.fromJson(json);
      if (response.succeeded) {
        DataStore.hubAreas = response.data.cast<String>();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<WaterBodyPointsData> getAllWaterBodyPointsByArea(area) async {
    try {
      String url = ApiUrls.getWAterPointByHubArea + area;
      final json = await RequestHelper.getRequest(url);
      final response = WaterBodyPointsData.fromJson(json);
      return response;
    } catch (e) {
      return WaterBodyPointsData(
          data: null, succeeded: false, message: e.toString());
    }
  }

  static Future<void> getAllWaterBodyPointsForMobile() async {
    try {
      String url = ApiUrls.getAllWaterPointData;
      final json = await RequestHelper.getRequest(url);
      final response = WaterBodyPointsData.fromJson(json);
      var allData =
          WaterBodyPoint.getWaterBodyTableFromWaterBody(response.data!);
      WaterTableService.syncLocalData(allData);
      //store in table
    } catch (e) {
      log(e.toString());
    }
  }
}
