import 'dart:io';

import 'package:demo_app/provider/theme_provider.dart';
import 'package:demo_app/screens/auth.dart';
import 'package:demo_app/screens/feedback.dart';
import 'package:demo_app/screens/login.dart';
import 'package:demo_app/services/Profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod/riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends ConsumerStatefulWidget {
  const Setting({super.key});

  @override
  ConsumerState<Setting> createState() => _SettingState();
}

class _SettingState extends ConsumerState<Setting> {
  File? image;
  String? profileImage;

  @override
  void initState() {
    super.initState();
    imageload();
  }

  Future<void> Pickimage() async {
    final picker = ImagePicker();
    final XFile? pickedimage = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedimage != null) {
      final file = await http.MultipartFile.fromPath("image", pickedimage.path);

      var resposne = await auth.Image(file);
      if (resposne['message'] == true) {
        await imageload();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Image Uploaded")));
      }
    }
  }

  void share() {
    print("SHARE BUTTON PRESSED");
    SharePlus.instance.share(ShareParams(text: "Download this app "));
  }

  Future<void> imageload() async {
    final img = await profile.getImage();
    setState(() {
      profileImage = img['image'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SizedBox(height: 15),
            GestureDetector(
              onTap: Pickimage,
              child: CircleAvatar(
                radius: 78,
                backgroundImage: profileImage != null
                    ? NetworkImage( "http://10.0.2.2:8000/storage/$profileImage")
                    : null,
              ),
            ),

            ListTile(
              leading: Icon(Icons.palette),
              title: Text("Theme"),
              trailing: Switch(
                value: ref.watch(ThemeProvider),
                onChanged: (value) {
                  ref.read(ThemeProvider.notifier).state = value;
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.feedback),
              title: Text("Feedback"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => feedback()),
                );
              },
            ),

            ListTile(
              leading: Icon(Icons.login),
              title: Text("logout"),
              onTap: () async {
                SharedPreferences token = await SharedPreferences.getInstance();
                final key = await token.remove('token');
                if (key) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => login()),
                  );
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text("Share App"),
              onTap: share,
            ),
          ],
        ),
      ),
    );
  }
}
