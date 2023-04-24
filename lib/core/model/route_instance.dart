import 'package:here_sdk/core.dart';
import 'package:here_sdk/routing.dart' as Routing;
import 'package:here_sdk/src/sdk/transport/transport_mode.dart';
import 'package:here_sdk/src/sdk/core/language_code.dart';
import 'package:here_sdk/src/sdk/core/geo_polyline.dart';
import 'package:here_sdk/src/sdk/core/geo_box.dart';

class RouteInstance extends Routing.Route {
  final GeoCoordinates start;
  final GeoCoordinates end;
  final double distnaceKM;

  RouteInstance(
      {required this.start, required this.end, required this.distnaceKM});

  @override
  GeoBox get boundingBox => GeoBox(start, end);

  @override
  Duration get duration => new Duration(seconds: 0);

  @override
  Routing.EVDetails? get evDetails => Routing.EVDetails(6);

  @override
  GeoPolyline get geometry => GeoPolyline([start, end]);

  @override
  LanguageCode get language => LanguageCode.enUs;

  @override
  int get lengthInMeters => distnaceKM.toInt() * 1000;

  @override
  Routing.OptimizationMode get optimizationMode =>
      Routing.OptimizationMode.shortest;

  @override
  TransportMode get requestedTransportMode => TransportMode.pedestrian;

  @override
  Routing.RouteHandle? get routeHandle => Routing.RouteHandle("");

  @override
  List<Routing.Section> get sections => [];

  @override
  Duration get trafficDelay => new Duration(seconds: 0);
}
