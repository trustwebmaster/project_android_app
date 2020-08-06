import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:pharmifind/GenericResponse.dart';

class RequestService {
  static request(phoneNumber, name, surname, latitude, longitude) async {
    try {
      final response = await http.get(
          'http://192.168.137.1/DrugsDB/requests.php?phoneNumber=$phoneNumber&name=$name&surname=$surname&latitude=$latitude&longitude=$longitude');
      if (200 == response.statusCode) {
        print('response returned from server::::::::::::');
        return 'success';
      } else {
        return GenRes();
      }
    } catch (e) {
      print(e);

      return GenRes();
    }
  }

  static GenRes parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<GenRes>((json) => GenRes.fromJson(json)).toList();
  }
}
