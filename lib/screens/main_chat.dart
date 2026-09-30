import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo_app/provider/message_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:demo_app/services/webSocket.dart';

class chat_box extends ConsumerStatefulWidget {
  const chat_box({super.key});

  @override
  ConsumerState<chat_box> createState() => _chat_boxState();
}

class _chat_boxState extends ConsumerState<chat_box> {
  final msg = TextEditingController();
  bool showOnline = false;

  void showOnlineStatus() {
    setState(() {
      showOnline = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showOnline = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final MessageAsync = ref.watch(message);
    final live_msg = ref.watch(newMsg);
    final user_id = ref.watch(id).value ?? '';
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: BackButton(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                GestureDetector(
                  onTap: showOnlineStatus,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/main_logo.jpg"),
                    radius: 17,
                  ),
                ),
                SizedBox(height: height * 0.009),

                if (showOnline)
                 Text(
                      "Online",
                      style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                    ),

              ],
            ),
            Text("Ayush B", style: TextStyle(fontWeight: FontWeight.bold)),
            Icon(Icons.camera),
          ],
        ),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            Expanded(
              child: MessageAsync.when(
                data: (messages) {
                  final all_message = [...messages, ...live_msg];
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final msg = all_message[index];
                      bool isMe = msg.sender.toString() == user_id;
                      return Align(
                        alignment: isMe
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isMe ? Colors.green : Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(children: []),
                          ),
                        ),
                      );
                    },
                    itemCount: all_message.length,
                  );
                },
                error: (error, stacktrace) {
                  return Center(child: Text(error.toString()));
                },

                loading: () {
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: msg,
                      decoration: InputDecoration(
                        hintText: "Type",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            final text = msg.text.trim();
                            if (text.isNotEmpty) {
                              socket.send(msg);
                              msg.clear();
                            }
                          },
                          icon: Icon(Icons.send),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1),
                    child: Icon(Icons.camera, size: 35, color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(height: 7),
          ],
        ),
      ),
    );
  }
}
