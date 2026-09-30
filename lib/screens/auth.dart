import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class auth {
  static Future<Map<String, dynamic>> signup(
    String username,
    String password,
  ) async {
    var url = Uri.parse("http://10.0.2.2:8000/api/signup");
    bool isPhone = RegExp(r'^\+?[0-9]{7,15}$').hasMatch(username.trim());
    Map<String, String> requestBody = {"password": password};
    if (isPhone) {
      requestBody["phone"] = username.trim();
    } else {
      requestBody["email"] = username.trim();
    }
    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(requestBody),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> Image(http.MultipartFile Image) async {
    final shared=await SharedPreferences.getInstance();
    final token=shared.getString("token");
    var url = Uri.parse("http://10.0.2.2:8000/api/Image");
    var request = http.MultipartRequest("POST", url);
    request.files.add(Image);
    request.headers['Authorization']="Bearer $token";

    var response = await request.send();




    var data = await response.stream.bytesToString();

    return jsonDecode(data);
  }
}

