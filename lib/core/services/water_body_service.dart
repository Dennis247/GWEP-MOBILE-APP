import '../model/base_response.dart';
import '../model/water_body.dart';
import '../model/water_body_details.dart';
import '../model/water_body_details2.dart';
import '../utils/apiUrls.dart';
import '../utils/request_helper.dart';

class WaterBodyService {
  static Future<WaterBodyData> getWaterBody() async {
    try {
      String url = ApiUrls.waterdetections;
      final json = await RequestHelper.getRequest(url);
      final response = WaterBodyData.fromJson(json);
      return response;
    } catch (e) {
      return WaterBodyData(data: null, succeeded: false, message: e.toString());
    }
  }

  static Future<WaterBodyDetailsData> getWaterBodyDetails(
      {required String name, required int pgNumber}) async {
    try {
      String url = ApiUrls.getWaterBodyDetails
          .replaceAll('NAME', name)
          .replaceAll('PGNUMBER', '$pgNumber');

      final json = await RequestHelper.getRequest(url);
      final response = WaterBodyDetailsData.fromJson(json);
      return response;
    } catch (e) {
      return WaterBodyDetailsData(
          data: null, succeeded: false, message: e.toString());
    }
  }

  static Future<WaterBodyDetails2Data> getWaterBodyDetailsByName(
      {required String name}) async {
    try {
      String url = ApiUrls.getWaterDetailsByName + name;

      final json = await RequestHelper.getRequest(url);
      final response = WaterBodyDetails2Data.fromJson(json);
      return response;
    } catch (e) {
      return WaterBodyDetails2Data(
          data: null, succeeded: false, message: e.toString());
    }
  }

  static Future<BaseResponse> updateWaterBodyPresence(
      {required id, required bool status}) async {
    try {
      String url = ApiUrls.updateWaterBodyPresence;
      var values = {"isWaterBodyPresent": status, "waterBodyId": id};

      final json = await RequestHelper.postRequest(url, values);
      final response = BaseResponse.fromJson(json);
      return response;
    } catch (e) {
      return BaseResponse(data: null, succeeded: false, message: e.toString());
    }
  }

  static Future<BaseResponse> updateWaterBodyVisitation(
      {required id, required bool status}) async {
    try {
      String url = ApiUrls.updateWaterBodyVisitation;
      var values = {"isVisisted": status, "waterBodyId": id};

      final json = await RequestHelper.postRequest(url, values);
      final response = BaseResponse.fromJson(json);
      return response;
    } catch (e) {
      return BaseResponse(data: null, succeeded: false, message: e.toString());
    }
  }

  //WaterBodyDetailsData
}
