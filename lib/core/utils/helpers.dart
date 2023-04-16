import 'dart:math';
import 'package:flutter/cupertino.dart';

class Helpers {
  static int getRandomNumber() {
    // Create a new instance of the Random class
    var random = Random();

// Generate a random number between 1 and 500
    var randomNumber = random.nextInt(20) + 1;
    return randomNumber;
  }

  //todo check if there is internet

  static String? validateString(
      {required String value, required String fieldnAme}) {
    return value.isEmpty ? '$fieldnAme cannot be empty' : null;
  }
}
