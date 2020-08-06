import 'dart:convert';
import 'package:http/http.dart' as http;
import 'locations.dart';

class PharmacyService {
  static const ROOT =
      'http://192.168.137.1/DrugsDB/drug_actions.php?action=GET_ALL_ROAD_ANGELS';

  static Future<List<Pharmacy>> getPharmacies() async {
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
}
