import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:pharmifind/GenericResponse.dart';

class RegistrationService {
  static const ROOT = 'http://10.15.16.117/DrugsDB/register.php';
  static const _REGISTER = 'REGISTER';

  static register(user, name, surname, phoneNumber, pass) async {
    try {
      final response = await http.get(
          'http://192.168.137.1/DrugsDB/register.php?username=$user&password=$pass&name=$name&surname=$surname&phoneNumber=$phoneNumber');
      if (200 == response.statusCode) {
        // var res = parseResponse(response.body);
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
