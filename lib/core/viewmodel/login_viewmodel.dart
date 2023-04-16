import 'package:RefApp/core/model/base_response.dart';
import 'package:RefApp/core/services/account_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:secure_shared_preferences/secure_shared_preferences.dart';

class LoginViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  setIsLoadingState(bool value, {bool notify = true}) {
    _isLoading = value;
    if (notify) notifyListeners();
  }

  Future<BaseResponse> loginUser({required String phoneNumber}) async {
    try {
      setIsLoadingState(true);
      var response =
          await AccountService.validateAccount(phoneNumber: phoneNumber);
      setIsLoadingState(false);
      return response;
    } catch (e) {
      setIsLoadingState(false);
      return BaseResponse(
          message: 'operation failed, please try again',
          data: null,
          succeeded: false);
    }
  }

  Future<void> logOutUser() async {
    var pref = await SecureSharedPref.getInstance();
    pref.clearAll();
  }
}
