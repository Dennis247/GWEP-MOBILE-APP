import 'package:hive_flutter/hive_flutter.dart';
import '../../../model/base_response.dart';
import '../../../utils/constants.dart';
import '../../dataStore.dart';
import 'water_body_point_table.dart';

class WaterTableService {
  //todo add list of water table service and update item in each water table service

  static Box<WaterBodyPointTable> getWaterBodyPoints() =>
      Hive.box<WaterBodyPointTable>(Constants.waterBodyPointTable);

  //get list of all water bodies
  static Future<List<WaterBodyPointTable>> getAllWaterBodyPoints() async {
    final box = getWaterBodyPoints();
    final data = box.values
        .where((element) => element.hubArea == DataStore.selectedHub)
        .toList()
        .cast<WaterBodyPointTable>();

    return data;
  }

  static Future<List<WaterBodyPointTable>> getAbatePoints() async {
    final box = getWaterBodyPoints();
    final data = box.values
        .where((element) => element.isAbateKnownPoint!)
        .toList()
        .cast<WaterBodyPointTable>();

    return data;
  }

//get all data
  static Future<List<WaterBodyPointTable>> getALlTableData() async {
    final box = getWaterBodyPoints();
    final data = box.values.toList().cast<WaterBodyPointTable>();

    return data;
  }

  //insert list of water bodies
  static Future<void> addWaterBodyPoint(
      List<WaterBodyPointTable> waterPointBodies) async {
    final box = getWaterBodyPoints();
    box.addAll(waterPointBodies);
  }

  //update water body data
  static Future<void> updateWaterBodyPoint(
      {required int key, required WaterBodyPointTable waterPointBody}) async {
    final box = getWaterBodyPoints();

    box.put(key, waterPointBody);
    final length = box.values.length;
    print('local length after update $length');
  }

  static BaseResponse downloadDataForOfflineUse(
      List<WaterBodyPointTable> data) {
    try {
      final box = getWaterBodyPoints();
      for (var i = 0; i < data.length; i++) {
        var wp = data[i];
        box.put(wp.id, wp);
      }
      return BaseResponse(
          data: data, succeeded: true, message: 'Download Sucessful');
    } catch (e) {
      return BaseResponse(
          data: data, succeeded: false, message: 'Failed to download data');
    }
  }

  static Future<BaseResponse> syncLocalData(
      List<WaterBodyPointTable> data) async {
    try {
      final box = getWaterBodyPoints();
      //   box.clear();
      for (var i = 0; i < data.length; i++) {
        var wp = data[i];
        box.put(wp.id, wp);
      }
      return BaseResponse(
          data: data, succeeded: true, message: 'Data Sync Sucessful');
    } catch (e) {
      return BaseResponse(
          data: data, succeeded: false, message: 'Failed to Sync data');
    }
  }
}
