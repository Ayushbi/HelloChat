import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:demo_app/provider/message_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo_app/model/message_model.dart';
import 'package:demo_app/services/Message_Api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

class socket {
  // Initialize WebSocket
  static token() async {
    final SharedPreferences token = await SharedPreferences.getInstance();
    return token.getString("token");
  }

  static Future<String?> authenticateChannel() async {
    final myToken = await socket.token();

    final response = await http.post(
      Uri.parse("http://10.0.2.2:8000/broadcasting/auth"),
      headers: {
        "Authorization": "Bearer $myToken",
        "Accept": "application/json",
      },
      body: {"channel_name": "private-chat_1_2"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data["auth"];
    }

    return null;
  }

  bool connected = false;
  bool connection_close = false;
  static late WebSocketChannel channel;
  static StreamSubscription? streamSubscription;

  void connect(WidgetRef ref) async {
    // connection
    try {
      if (connected) {
        return;
      }
      connection_close = false;
      channel = WebSocketChannel.connect(
        Uri.parse("ws://10.0.2.2:8080/app/cf8aii4udv5svkvy8uei"),
      );
      final auth = await socket.authenticateChannel();
      channel.sink.add(
        jsonEncode({
          "event": "pusher:subscribe",
          "data": {"channel": "private-chat_1_2", "auth": auth},
        }),
      );
      print("SUBSCRIBE SENT");
      connected = true;

      streamSubscription = channel.stream.listen(
        (event) {
          final data = jsonDecode(event);

          if (data["event"] == "App\\Events\\MsgSent") {
            final eventData = jsonDecode(data["data"]);

            final messageData = eventData["message"];

            final message = MessageModel.fromJson(messageData);

            ref.read(newMsg.notifier).addmsg(message);
          }
        },
        onError: (error) {
          print(error);
        },
        onDone: () async {
          connected = false;
          if (connection_close) {
            return;
          }
          await Future.delayed(Duration(seconds: 2));
          connect(ref);
        },
      );
    } catch (e) {
      print(e);
    }
  }

  //send
  static send(messages) async {
    try {
      await messageApi().SendMessage(messages);
    } catch (e) {
      print(e);
    }
  }

  void StopListening() {
    streamSubscription?.cancel();
  }

  //connection close
  void disconnect() {
    connection_close = true;
    channel.sink.close();
  }
}
