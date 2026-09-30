import 'package:demo_app/screens/Contact.dart';
import 'package:demo_app/screens/Groups.dart';
import 'package:demo_app/screens/main_chat.dart';
import 'package:demo_app/screens/setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatSection extends StatefulWidget {
  const ChatSection({super.key});

  @override
  State<ChatSection> createState() => _ChatSectionState();
}

class _ChatSectionState extends State<ChatSection> {
  int index = 0;
  List<Widget> pages = [Contacts(),  Groups(),Setting(),];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap: (item) {
          setState(() {
            index = item;
          });

        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Groups"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setting"),
        ],
      ),
    );
  }
}
