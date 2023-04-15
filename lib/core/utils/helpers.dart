// import 'dart:math';
// import 'package:flutter/cupertino.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:map_launcher/map_launcher.dart';
// import 'package:flutter_offline/flutter_offline.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:navigator_map/data/dataStore.dart';

// class Helpers {
//   static int getRandomNumber() {
//     // Create a new instance of the Random class
//     var random = Random();

// // Generate a random number between 1 and 500
//     var randomNumber = random.nextInt(20) + 1;
//     return randomNumber;
//   }

//   //todo check if there is internet

//   static Future<void> isAppOffline() async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.mobile ||
//         connectivityResult == ConnectivityResult.wifi) {
//       DataStore.isOffline = false;
//     } else {
//       DataStore.isOffline = true;
//     }
//   }

//   static String? validateString(
//       {required String value, required String fieldnAme}) {
//     return value.isEmpty ? '$fieldnAme cannot be empty' : null;
//   }

//   //todo get device physical location

//   /// Determine the current position of the device.
//   ///
//   /// When the location services are not enabled or permissions
//   /// are denied the `Future` will return an error.
//   static Future<Position> getCurrentLOcation() async {
//     try {
//       if (DataStore.userPosition != null) {
//         return DataStore.userPosition!;
//       }

//       var result = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.best,
//           timeLimit: Duration(seconds: 5));
//       DataStore.userPosition = result;
//       return result;
//     } catch (e) {
//       print(e.toString());
//     }

//     bool serviceEnabled;
//     LocationPermission permission;

//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Location services are not enabled don't continue
//       // accessing the position and request users of the
//       // App to enable the location services.
//       return Future.error('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // Permissions are denied, next time you could try
//         // requesting permissions again (this is also where
//         // Android's shouldShowRequestPermissionRationale
//         // returned true. According to Android guidelines
//         // your App should show an explanatory UI now.
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       // Permissions are denied forever, handle appropriately.
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }

//     // When we reach here, permissions are granted and we can
//     // continue accessing the position of the device.
//     var result = await Geolocator.getCurrentPosition();
//     DataStore.userPosition = result;
//     return result;
//   }

//   //todo , use other maps for navigation

// }
