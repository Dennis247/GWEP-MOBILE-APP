import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
import '../model/base_response.dart';

class RequestHelper {
  static Map<String, String> header = {
    'Content-Type': 'application/json',
  };

  static Future<dynamic> getRequest(String url) async {
    try {
      log("Url--$url");

      http.Response response = await http.get(Uri.parse(url), headers: header);

      String data = response.body;
      var decodedData = jsonDecode(data);
      log(json.encode(decodedData));

      return decodedData;
    } on SocketException {
      throw BaseResponse(
          message: 'No Internet connection 😑', succeeded: false, data: null);
    } on Exception {
      throw BaseResponse(
          message: 'Failed to process request, try again later',
          succeeded: false,
          data: null);
    }
  }

  static Future<dynamic> postRequest(String url, dynamic values) async {
    try {
      log("Url--$url");

      log(json.encode(header));
      print("==============================================");
      print("==============================================");

      var postValue = json.encode(values);
      log(postValue);
      print("==============================================");
      print("==============================================");

      http.Response response = await http.post(
        Uri.parse(url),
        headers: header,
        body: postValue,
      );

      String data = response.body;
      var decodedData = jsonDecode(data);
      log(json.encode(decodedData));
      print("==============================================");
      print("==============================================");

      return decodedData;
    } on SocketException {
      throw Exception(
        'No Internet connection 😑',
      );
    } on Exception {
      throw Exception(
        'Failed to process request, try again later',
      );
    }
  }
}
