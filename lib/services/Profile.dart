import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class profile {
  static Future<dynamic> getImage() async {
    var url = Uri.parse("http://10.0.2.2:8000/api/GetImage");
  final  SharedPreferences token=await SharedPreferences.getInstance();
 final user_token=token.getString('token');

    var response = await http.get(
        url,
        headers:
        {
          "Authorization": "Bearer $user_token",
          "Accept": "application/json",

        }
    );
    print(response.statusCode);

    return jsonDecode(response.body);
  }
}
