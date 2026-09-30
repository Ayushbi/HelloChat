import 'package:demo_app/screens/chat_section.dart';
import 'package:demo_app/screens/login.dart';
import 'package:demo_app/screens/main_chat.dart';
import 'package:demo_app/screens/register.dart';
import 'package:demo_app/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:demo_app/provider/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(ProviderScope(child: demo()));
}

class demo extends ConsumerStatefulWidget {
  const demo({super.key});

  @override
  ConsumerState<demo> createState() => _demoState();
}

class _demoState extends ConsumerState<demo> {
  bool checklogin = false;

  @override
  void initState() {
    super.initState();
    Login();
  }

  Future<void> Login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    setState(() {
      checklogin = token != null && token.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final istheme = ref.watch(ThemeProvider);
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: istheme ? ThemeMode.dark : ThemeMode.light,

      debugShowCheckedModeBanner: false,
      // home: checklogin ? ChatSection() : login(),
      home: ChatSection(),
    );
  }
}
