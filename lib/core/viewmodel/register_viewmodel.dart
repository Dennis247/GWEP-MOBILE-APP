import 'package:flutter/cupertino.dart';

import '../model/base_response.dart';
import '../services/account_service.dart';

class RegisterViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  setIsLoadingState(bool value, {bool notify = true}) {
    _isLoading = value;
    if (notify) notifyListeners();
  }

  Future<BaseResponse> registerUser(
      {required String phoneNumber,
      required String firstName,
      required String lastName}) async {
    try {
      setIsLoadingState(true);
      var response = await AccountService.addAccount(
          phoneNumber: phoneNumber, firstName: firstName, lastName: lastName);
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
}
