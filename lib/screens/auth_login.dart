import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class Login{
  static Future<Map<String,dynamic>>
  login_user (String username ,String password)async{
    var url=Uri.parse("http://10.0.2.2:8000/api/login");
    Map<String ,String>Data={
      "password":password,
    };
    bool isPhone=RegExp(r'^\+?[0-9]{7,15}$').hasMatch(username.trim());
    if(isPhone){
      Data['phone']=username.trim();
    }
    else {
      Data['email']=username.trim();
    }
    final response =await http.post(url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(Data),

    );
    return jsonDecode(response.body);
    }
  }


