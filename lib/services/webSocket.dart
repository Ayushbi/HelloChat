import 'dart:convert';
import 'package:demo_app/provider/message_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo_app/model/message_model.dart';
import 'package:demo_app/services/Message_Api.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class socket {
  // Initialize WebSocket
  bool connected = false;
  bool connection_close=false;
  static late WebSocketChannel channel;

  void connect(WidgetRef ref) {
    // connection
    try {
      if (connected) {
        return;
      }
      connection_close=false;
      channel = WebSocketChannel.connect(Uri.parse("ws://10.0.2.2:8080"));
      connected = true;

      channel.stream.listen(
        (event) {
          final data = jsonDecode(event);
          final message = MessageModel.fromJson(data);
          ref.read(newMsg.notifier).addmsg(message);
        },
        onError: (error) {
          print(error);
        },
        onDone: () async{
          connected = false;
          if(connection_close){
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
      channel.sink.add(messages);
      await messageApi().SendMessage(messages);
    } catch (e) {
      print(e);
    }
  }

  //connection close
  void disconnect() {
  connection_close=true;
    channel.sink.close();
  }
}

