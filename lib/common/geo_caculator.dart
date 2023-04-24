import 'dart:math' show cos, sqrt, sin, pi, asin;

import 'package:here_sdk/core.dart';

class GeoCaculator {
// Function to calculate the distance between two locations
  static double calculateDistance(
      GeoCoordinates location1, GeoCoordinates location2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((location2.latitude - location1.latitude) * p) / 2 +
        c(location1.latitude * p) *
            c(location2.latitude * p) *
            (1 - c((location2.longitude - location1.longitude) * p)) /
            2;
    var result = 12742 * asin(sqrt(a));
    return result;
  }
}
