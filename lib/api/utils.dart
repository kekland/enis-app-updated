import 'dart:core';
import 'dart:async';
import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class Utils {
  static Future<http.Response> post({String url, Map reqData, Map headers}) async {
    try {
      final response = await http.post(url, body: reqData, headers: headers);

      if (response.statusCode >= 200 || response.statusCode <= 300) {
        return response;
      } else {
        print('Request at url: $url failed with code: ${response.statusCode}, phrase: ${response.reasonPhrase}');
        throw new Exception(response.reasonPhrase);
      }
    } catch (Exception) {
      print('Request at url: $url failed with cause: $Exception');
      throw Exception;
    }
  }


  static int getTimestamp() {
    return new DateTime.now().millisecondsSinceEpoch;
  }
}
