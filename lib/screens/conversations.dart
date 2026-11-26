import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo_app/provider/message_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:demo_app/services/webSocket.dart';

class Conversations extends ConsumerStatefulWidget {
  const Conversations({super.key});

  @override
  ConsumerState<Conversations> createState() => _chat_boxState();
}

class _chat_boxState extends ConsumerState<Conversations> {
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
  void initState() {
    super.initState();
    socket().connect(ref);
  }

  @override
  void dispose() {
    msg.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final MessageAsync = ref.watch(message);
    final live_msg = ref.watch(newMsg);
    final user_id = ref.watch(id).value ?? '';

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: const BackButton(),
        title: Row(
          children: [
            GestureDetector(
              onTap: showOnlineStatus,
              child: const CircleAvatar(
                backgroundImage: AssetImage("assets/main_logo.jpg"),
                radius: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Ayush B",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (showOnline)
                    const Text(
                      "Online",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blueGrey,
                      ),
                    ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == "clear") {
                  // Handle deleting or clearing chat
                }
              },
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: "clear",
                    child: Text("Delete"),
                  ),
                ];
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.surface,
                child: MessageAsync.when(
                  data: (messages) {
                    final all_message = [...messages, ...live_msg];

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      itemCount: all_message.length,
                      itemBuilder: (context, index) {
                        final currentMessage = all_message[index];
                        final isMe =
                            currentMessage.sender.toString() == user_id;

                        return Align(
                          alignment: isMe
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: width * 0.75,

                            ),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),decoration: BoxDecoration(
                            color: isMe
                                ? Colors.green.shade100
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(16),
                          ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 45,
                                    bottom: 3,
                                  ),
                                  child: Text(
                                    currentMessage.text,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Text(
                                    "${currentMessage.time.hour}:${currentMessage.time.minute.toString().padLeft(2, '0')}",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  error: (error, stacktrace) {
                    return Center(child: Text(error.toString()));
                  },
                  loading: () {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ),

            // Message input
            Container(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: msg,
                      minLines: 1,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            final text = msg.text.trim();

                            if (text.isNotEmpty) {
                              socket.send(text);
                              msg.clear();
                            }
                          },
                          icon: const Icon(Icons.send),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Icon(
                      Icons.camera_alt,
                      size: 35,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}