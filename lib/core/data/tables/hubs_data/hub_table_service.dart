import 'dart:developer';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../utils/constants.dart';
import 'hub_table.dart';

class HubTableService {
  //todo add list of water table service and update item in each water table service

  static Box<HubTable> getHubData() => Hive.box<HubTable>(Constants.hubTable);

  //get list of all water bodies
  static List<String> getAllHubTableData() {
    final box = getHubData();
    final data = box.values.cast<HubTable>();

    List<String> hubData = [];
    for (var element in data) {
      hubData.add(element.name!);
    }

    return hubData;
  }

  static Future<void> insertHubList(List<String> hubLIst) async {
    try {
      final box = getHubData();
      //   box.clear();
      for (var i = 0; i < hubLIst.length; i++) {
        var hd = hubLIst[i];
        box.put(hd, HubTable(id: hd, name: hd));
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
