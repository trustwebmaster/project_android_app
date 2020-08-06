import 'dart:convert';
import 'package:http/http.dart'
    as http; // add the http plugin in pubspec.yaml file.
import 'package:pharmifind/loginModel.dart';

class LoginService {
  static Future<List<Account>> verifyPassword(user, pass) async {
    try {
      print('AAPI HIT');

      final response = await http.get(
          'http://10.15.16.117/DrugsDB/login.php?username=$user&password=$pass');
      if (200 == response.statusCode) {
        List<Account> list = parseResponse(response.body);
        if (list.isNotEmpty) {
          return list;
        } else {
          print("Invalid username/username");
          return list;
        }
      } else {
        print("500r");
        return List<Account>();
      }
    } catch (e) {
      print(e);
      print("API DOWN");
      return List<Account>();
    }
  }

  static List<Account> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Account>((json) => Account.fromJson(json)).toList();
  }
}
