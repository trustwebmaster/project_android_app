import 'dart:convert';
import 'package:http/http.dart'
    as http; // add the http plugin in pubspec.yaml file.
import 'package:pharmifind/roadAngels/locations.dart';

class Services {
  static const ROOT =
      'http://172.16.8.73/DrugsDB/drug_actions.php?action=GET_ALL_MECHANICS';

  static Future<List<Pharmacy>> getMechanics() async {
    try {
      final response = await http.get(ROOT);

      if (200 == response.statusCode) {
        List<Pharmacy> list = parseResponse(response.body);
        return list;
      } else {
        return List<Pharmacy>();
      }
    } catch (e) {
      return List<Pharmacy>();
    }
  }

  static List<Pharmacy> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Pharmacy>((json) => Pharmacy.fromJson(json)).toList();
  }

  static Future<List<Pharmacy>> postRequest(phoneNumber, fullName) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'REQUEST_MECHANIC';
      map['fullName'] = fullName.toString();
      map['phoneNumber'] = phoneNumber.toString();

      final response = await http
          .post('http://192.168.0.169/DrugsDB/drug_actions.php?action=G');

      if (200 == response.statusCode) {
        List<Pharmacy> list = parseResponse(response.body);
        return list;
      } else {
        return List<Pharmacy>();
      }
    } catch (e) {
      return List<Pharmacy>();
    }
  }
}
