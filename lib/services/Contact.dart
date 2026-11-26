import 'dart:convert';

import 'package:demo_app/model/contact_model.dart';
import 'package:http/http.dart' as http;

class ContactService {
  static Future<List<ContactModel>> getRegisteredUsers() async {
    var url = Uri.parse("http://10.0.2.2:8000/api/Contacts");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

         List<ContactModel> contacts = (data['users'] as List)
             .map((contact) => ContactModel.data(contact))
             .toList();
         return contacts;


    } else {
      throw Exception("Failed to fetch registered users");
    }
  }
}
