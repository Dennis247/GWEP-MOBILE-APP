import '../model/base_response.dart';
import '../utils/apiUrls.dart';
import '../utils/request_helper.dart';

class AccountService {
  static Future<BaseResponse> addAccount(
      {required phoneNumber, required firstName, required lastName}) async {
    try {
      String url = ApiUrls.addAccount;
      var values = {
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber
      };

      final json = await RequestHelper.postRequest(url, values);
      final response = BaseResponse.fromJson(json);
      return response;
    } catch (e) {
      return BaseResponse(data: null, succeeded: false, message: e.toString());
    }
  }

  static Future<BaseResponse> validateAccount({required phoneNumber}) async {
    try {
      String url = ApiUrls.validateAccount;
      var values = {"phoneNumber": phoneNumber};

      final json = await RequestHelper.postRequest(url, values);
      final response = BaseResponse.fromJson(json);
      return response;
    } catch (e) {
      var resp =
          BaseResponse(data: null, succeeded: false, message: e.toString());
      return resp;
    }
  }
}
