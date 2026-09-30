import 'dart:convert';
import 'package:demo_app/model/message_model.dart';
import 'package:http/http.dart' as http;

class messageApi {
  Future<List<MessageModel>> getmessage(String user_id) async {
    var url = Uri.parse("http://10.0.2.2:8000/api/show_message/1");

    final response = await http.get(url);

    Map<String, dynamic> data = jsonDecode(response.body);

    List<dynamic> messages = data["messages"];

    return messages.map((item) => MessageModel.fromJson(item)).toList();
  }

  Future<Map> SendMessage(String Message) async {
    var url = Uri.parse("http://10.0.2.2:8000/api/message");
    Map<String, String> Data = {"Message": "message"};
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(Data),
    );
    return jsonDecode(response.body);
  }
}
