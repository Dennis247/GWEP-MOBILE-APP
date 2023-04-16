// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:RefApp/core/data/dataStore.dart';
import 'package:RefApp/core/data/tables/water_point_data/water_body_point_table.dart';
import 'package:RefApp/core/data/tables/water_point_data/water_body_table_service.dart';
import 'package:RefApp/core/model/water_body_points.dart';
import 'package:RefApp/core/services/water_point_service.dart';
import 'package:RefApp/core/utils/constants.dart';
import 'package:RefApp/main.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
import 'package:latlong2/latlong.dart';

import '../widgets/bottom_sheet/global_dialogue.dart';

class WaterPointViewModel extends ChangeNotifier {
//selected water body points

  String selectedHubArea = "";
  setSelectedHubArea(String value) async {
    selectedHubArea = value;
    DataStore.selectedHub = selectedHubArea;
  }

  // List<Marker> markers = [];

  //List<Marker> vMakers = [];

  bool _isLoadingWaterPointData = false;
  bool get isLoadingWaterPointData => _isLoadingWaterPointData;
  setisLoadingWaterPointDataState(bool value, {bool notify = true}) {
    _isLoadingWaterPointData = value;
    if (notify) notifyListeners();
  }

  LatLng center = LatLng(51.5, -0.09);

  List<WaterBodyPoint> waterBodyPoints = [];

  Future<void> getAllWaterBodyPoints() async {
    try {
      if (selectedHubArea.isEmpty) {
        selectedHubArea = DataStore.hubAreas[13];
        DataStore.selectedHub = selectedHubArea;
      }

      setisLoadingWaterPointDataState(true);

      List<WaterBodyPointTable> localDb = [];
      var waterPointTable = await WaterTableService.getAllWaterBodyPoints();
      localDb = waterPointTable;

      if (DataStore.isOffline) {
        waterBodyPoints =
            WaterBodyPoint.getWaterBodyromWaterBodyTable(waterPointTable);
      } else {
        if (localDb.isEmpty) {
          WaterPointService.getAllWaterBodyPointsForMobile();
          var response = await WaterPointService.getAllWaterBodyPointsByArea(
              selectedHubArea);

          if (response.succeeded!) {
            waterBodyPoints = response.data!;

            localDb =
                WaterBodyPoint.getWaterBodyTableFromWaterBody(waterBodyPoints);
            WaterTableService.downloadDataForOfflineUse(localDb);
          }
        } else {
          waterBodyPoints =
              WaterBodyPoint.getWaterBodyromWaterBodyTable(localDb);
        }

        // var response = await WaterPointService.getAllWaterBodyPointsByArea(
        //     selectedHubArea);
        // if (response.succeeded!) {
        //   waterBodyPoints = response.data!;
        //   if (localDb.length != waterBodyPoints.length) {
        //     localDb =
        //         WaterBodyPoint.getWaterBodyTableFromWaterBody(waterBodyPoints);
        //     WaterTableService.downloadDataForOfflineUse(localDb);
        //   }
        // }
      }

      await Future.delayed(Duration(seconds: 1));

      var fp = waterBodyPoints[0];
      center = LatLng(fp.latitude!.toDouble(), fp.longitude!.toDouble());

      setisLoadingWaterPointDataState(false);
    } catch (e) {
      log(e.toString());
      setisLoadingWaterPointDataState(false);
    }
  }

  Future<void> getAllWaterPointsForUpdates() async {
    try {
      if (DataStore.isOffline) {
        var waterPointTable = await WaterTableService.getAllWaterBodyPoints();
        waterBodyPoints =
            WaterBodyPoint.getWaterBodyromWaterBodyTable(waterPointTable);
      } else {
        var waterPointTable = await WaterTableService.getAllWaterBodyPoints();
        waterBodyPoints =
            WaterBodyPoint.getWaterBodyromWaterBodyTable(waterPointTable);

        // WaterPointService.getAllWaterBodyPointsByArea(selectedHubArea)
        //     .then((value) => {
        //           if (value.succeeded!) {waterBodyPoints = value.data!}
        //         });
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

//Update water body status
  dynamic selectedWaterBodyId = 0;
  bool? selectedIsWaterBodyVisited = false;
  bool? selctedIsWaterBodyPresent = false;
  String selectedWaterBodyStatus = "";

  WaterBodyPoint? selectedWaterBodyPoint;
  WaterBodyPoint? oldSelectedWaterBodyPoint;

  setSelctedWaterBodyStatus(
      {required vSelectedWaterBodyId,
      required bool vSelectedIsWaterBodyVisited,
      required bool vSelctedIsWaterBodyPresent,
      required WaterBodyPoint vWaterBodyPoint}) {
    selectedWaterBodyId = vSelectedWaterBodyId;

    selectedIsWaterBodyVisited = vSelectedIsWaterBodyVisited;
    selctedIsWaterBodyPresent = vSelctedIsWaterBodyPresent;
    selectedWaterBodyPoint = vWaterBodyPoint;
    oldSelectedWaterBodyPoint = selectedWaterBodyPoint;
    selectedWaterBodyStatus = vWaterBodyPoint.waterBodyStatus!;
    notifyListeners();
  }

  setIsWaterBodyPresentStatus(bool status) {
    selctedIsWaterBodyPresent = status;
    notifyListeners();
  }

  setIsWaterBodyVisistedStatus(bool status) {
    selectedIsWaterBodyVisited = status;
    notifyListeners();
  }

  Future<void> updateWaterBodyVisitation({required bool selectedValue}) async {
    try {
      selectedWaterBodyPoint?.hasBeenVisited = selectedValue;
      //meta data
      selectedWaterBodyPoint?.lastUpdatedByName =
          DataStore.userAccount?.fullName;
      selectedWaterBodyPoint?.lastUpdatedBy = DataStore.userAccount?.id;
      selectedWaterBodyPoint?.lastVisistedBy = DataStore.userAccount?.fullName;
      selectedWaterBodyPoint?.lastUpdatedDate =
          DateTime.now().toIso8601String();
      selectedWaterBodyPoint?.lastTimeVisisted =
          DateTime.now().toIso8601String();
      selectedWaterBodyPoint?.hasBeenVisited = true;

      var localData =
          WaterBodyPoint.getWaterTableDataFromData(selectedWaterBodyPoint!);
      WaterTableService.updateWaterBodyPoint(
          key: localData.id!.toInt().toInt(), waterPointBody: localData);
      selectedIsWaterBodyVisited = selectedValue;

      if (DataStore.isOffline) {
        WaterTableService.updateWaterBodyPoint(
            key: localData.id!.toInt().toInt(), waterPointBody: localData);
      } else {
        WaterPointService.updateWaterPointVisitation(
            id: selectedWaterBodyId, status: selectedValue);

        WaterTableService.updateWaterBodyPoint(
            key: localData.id!.toInt().toInt(), waterPointBody: localData);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateWaterBodyPresence({required bool selectedValue}) async {
    try {
      selectedWaterBodyPoint?.isWaterBodyPresent = selectedValue;

      //meata data
      selectedWaterBodyPoint?.lastUpdatedBy = DataStore.userAccount?.id;
      selectedWaterBodyPoint?.lastUpdatedDate =
          DateTime.now().toIso8601String();
      selectedWaterBodyPoint?.lastUpdatedByName =
          DataStore.userAccount?.fullName;

      var localData =
          WaterBodyPoint.getWaterTableDataFromData(selectedWaterBodyPoint!);
      WaterTableService.updateWaterBodyPoint(
          key: localData.id!.toInt(), waterPointBody: localData);
      selctedIsWaterBodyPresent = selectedValue;

      if (DataStore.isOffline) {
        WaterTableService.updateWaterBodyPoint(
            key: localData.id!.toInt(), waterPointBody: localData);
      } else {
        WaterPointService.updateWaterPointPresence(
            id: selectedWaterBodyId, status: selctedIsWaterBodyPresent!);

        WaterTableService.updateWaterBodyPoint(
            key: localData.id!.toInt(), waterPointBody: localData);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateWaterBodyDepression(
      {required String selectedValue}) async {
    try {
      selectedWaterBodyPoint?.depression = selectedValue;

      //meata data
      selectedWaterBodyPoint?.lastUpdatedBy = DataStore.userAccount?.id;
      selectedWaterBodyPoint?.lastUpdatedDate =
          DateTime.now().toIso8601String();
      selectedWaterBodyPoint?.lastUpdatedByName =
          DataStore.userAccount?.fullName;
      selectedWaterBodyPoint?.hasBeenVisited = true;

      var localData =
          WaterBodyPoint.getWaterTableDataFromData(selectedWaterBodyPoint!);
      WaterTableService.updateWaterBodyPoint(
          key: localData.id!.toInt(), waterPointBody: localData);
      selectedWaterBodyStatus = selectedValue;

      if (DataStore.isOffline) {
        WaterTableService.updateWaterBodyPoint(
            key: localData.id!.toInt(), waterPointBody: localData);
      } else {
        WaterPointService.udpateWaterBodyDepression(
            id: selectedWaterBodyId, selectedValue: selectedValue);

        WaterTableService.updateWaterBodyPoint(
            key: localData.id!.toInt(), waterPointBody: localData);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateWaterBodyStatus({required String selectedValue}) async {
    try {
      selectedWaterBodyPoint?.waterBodyStatus = selectedValue;

      //meata data
      selectedWaterBodyPoint?.lastUpdatedBy = DataStore.userAccount?.id;
      selectedWaterBodyPoint?.lastUpdatedDate =
          DateTime.now().toIso8601String();
      selectedWaterBodyPoint?.lastUpdatedByName =
          DataStore.userAccount?.fullName;
      selectedWaterBodyPoint?.hasBeenVisited = true;

      var localData =
          WaterBodyPoint.getWaterTableDataFromData(selectedWaterBodyPoint!);
      WaterTableService.updateWaterBodyPoint(
          key: localData.id!.toInt(), waterPointBody: localData);
      selectedWaterBodyStatus = selectedValue;

      if (DataStore.isOffline) {
        WaterTableService.updateWaterBodyPoint(
            key: localData.id!.toInt(), waterPointBody: localData);
      } else {
        WaterPointService.updateWaterBodyStatus(
            id: selectedWaterBodyId, selectedValue: selectedValue);

        WaterTableService.updateWaterBodyPoint(
            key: localData.id!.toInt(), waterPointBody: localData);
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  bool _isDownloadingData = false;
  bool get isDownloadingData => _isDownloadingData;
  setisDownloadingDataState(bool value, {bool notify = true}) {
    _isDownloadingData = value;
    if (notify) notifyListeners();
  }

  //todo download data for offline use

  Future<void> downloadDataForOfflineUse() async {
    try {
      setisDownloadingDataState(true);
      var data = WaterBodyPoint.getWaterBodyTableFromWaterBody(waterBodyPoints);
      var resp = await WaterTableService.downloadDataForOfflineUse(data);
      await Future.delayed(Duration(seconds: 5));
      setisDownloadingDataState(false);
      showStatusBottomSheet(navigatorKey.currentContext!,
          subtitle: resp.message, onButtonClick: () {
        //   Navigator.of(navigatorKey.currentContext!).pop();
      }, isSUcessful: resp.succeeded, isDismissible: true);
    } catch (e) {
      log(e.toString());
      setisDownloadingDataState(false);

      showStatusBottomSheet(navigatorKey.currentContext!,
          subtitle: 'Data Download Failed', onButtonClick: () {
        Navigator.of(navigatorKey.currentContext!).pop();
      }, isSUcessful: false, isDismissible: true);
    }
  }

  String processText = "";

  Future<void> syncWaterBodyData() async {
    try {
      //check if there is internet

      if (DataStore.isOffline) {
        showStatusBottomSheet(navigatorKey.currentContext!,
            subtitle: "Mobile app is currently offline", onButtonClick: () {
          Navigator.of(navigatorKey.currentContext!).pop();
        }, isSUcessful: false, isDismissible: true);
      } else {
        setisDownloadingDataState(true);
        processText = "Synchronization in progress...";
        //   var resp = await WaterPointService.syncWaterBodyDataWithServer();
        var resp = await WaterPointService.offlineSyncWithServer();
        setisDownloadingDataState(false);
        showStatusBottomSheet(navigatorKey.currentContext!,
            subtitle: resp.message, onButtonClick: () {
          Navigator.of(navigatorKey.currentContext!).pop();
        }, isSUcessful: resp.succeeded, isDismissible: true);
      }
    } catch (e) {
      log(e.toString());
      setisDownloadingDataState(false);
      showStatusBottomSheet(navigatorKey.currentContext!,
          subtitle: "Datasynchronization failed.", onButtonClick: () {
        Navigator.of(navigatorKey.currentContext!).pop();
      }, isSUcessful: false, isDismissible: true);
    }
  }

  Future<void> filterByConfidence({required String confidenceLevl}) async {
    //  setisLoadingWaterPointDataState(true);

    var waterPointTable = await WaterTableService.getAllWaterBodyPoints();
    waterBodyPoints =
        WaterBodyPoint.getWaterBodyromWaterBodyTable(waterPointTable);

    if (confidenceLevl == 'all') {
      waterBodyPoints = waterBodyPoints;
    } else {
      waterBodyPoints = waterBodyPoints
          .where((element) =>
              element.confidence!.toLowerCase() == confidenceLevl.toLowerCase())
          .toList();
    }

    //  await Future.delayed(Duration(seconds: 1));
//
    //   setisLoadingWaterPointDataState(false);
  }

  Future<void> filterByVisitationStatus(
      {required String visitationStaus}) async {
    //  setisLoadingWaterPointDataState(true);

    var waterPointTable = await WaterTableService.getAllWaterBodyPoints();
    waterBodyPoints =
        WaterBodyPoint.getWaterBodyromWaterBodyTable(waterPointTable);

    if (visitationStaus == 'all') {
      waterBodyPoints = waterBodyPoints;
    } else {
      if (visitationStaus == Constants.visited) {
        waterBodyPoints = waterBodyPoints
            .where((element) => element.hasBeenVisited! == true)
            .toList();
      } else if (visitationStaus == Constants.notVisited) {
        waterBodyPoints = waterBodyPoints
            .where((element) => element.hasBeenVisited! != true)
            .toList();
      }
    }

    //  await Future.delayed(Duration(seconds: 1));
    //setisLoadingWaterPointDataState(false);
  }

  Future<void> filterByPhase({required String phase}) async {
    //  setisLoadingWaterPointDataState(true);

    var waterPointTable = await WaterTableService.getAllWaterBodyPoints();
    waterBodyPoints =
        WaterBodyPoint.getWaterBodyromWaterBodyTable(waterPointTable);

    if (phase == 'all') {
      waterBodyPoints = waterBodyPoints;
    } else {
      if (phase == Constants.opneSky) {
        waterBodyPoints = waterBodyPoints
            .where((element) => element.phase! == Constants.opneSky)
            .toList();
      } else if (phase == Constants.underCanoy) {
        waterBodyPoints = waterBodyPoints
            .where((element) => element.phase! == Constants.underCanoy)
            .toList();
      }
    }

    //  await Future.delayed(Duration(seconds: 1));
    //setisLoadingWaterPointDataState(false);
  }

  Future<void> filterByAbatePoins() async {
    setisLoadingWaterPointDataState(true);
    await Future.delayed(Duration(seconds: 1));
    var waterPointTable = await WaterTableService.getAbatePoints();
    waterBodyPoints =
        WaterBodyPoint.getWaterBodyromWaterBodyTable(waterPointTable);

    if (waterBodyPoints.isNotEmpty) {
      var ct = waterBodyPoints[0];
      center = LatLng(ct.latitude!.toDouble(), ct.longitude!.toDouble());
    }
    _isLoadingWaterPointData = false;

    //set centre for abate point
  }
}

class DemoViewModel extends ChangeNotifier {
  setDemoMode(bool value) {
    DataStore.isDemoModeOn = value;
    notifyListeners();
  }
}
