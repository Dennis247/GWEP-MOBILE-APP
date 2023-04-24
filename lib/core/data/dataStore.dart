import 'package:here_sdk/mapview.dart';

import '../model/account_data.dart';

class DataStore {
  static bool isOffline = false;
  static Account? userAccount;
  static bool? isDemoModeOn = false;

  static List<String> hubAreas = [];
  static String selectedHub = "";

  static MapScheme mapScheme = MapScheme.normalDay;
}
