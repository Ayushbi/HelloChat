import 'package:demo_app/screens/chat_section.dart';
import 'package:flutter/material.dart';
import 'dart:async';
class splashscreen extends StatefulWidget {
  const splashscreen({super.key});

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
  @override
void initState() {
    // TODO: implement initState
    super.initState();
 Timer(Duration(seconds: 3), (){
   if(!mounted) return;
Navigator.pushReplacement(context, MaterialPageRoute(
    builder: (context)=>ChatSection()));
 });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 70,
              child: Image.asset("assets/main_logo.jpg",
                height: 150,
                width: 150,),
            ),

            const SizedBox(height: 20),

            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
