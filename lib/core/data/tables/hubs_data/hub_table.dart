import 'package:hive/hive.dart';

part 'hub_table.g.dart';

@HiveType(typeId: 1)
class HubTable {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? name;

  HubTable({this.id, this.name});
}
