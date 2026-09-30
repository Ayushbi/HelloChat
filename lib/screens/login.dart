import 'package:demo_app/screens/auth_login.dart';
import 'package:demo_app/screens/chat_section.dart';
import 'package:demo_app/main.dart';
import 'package:demo_app/screens/main_chat.dart';
import 'package:demo_app/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final _formkey = GlobalKey<FormState>();
  final password = TextEditingController();
  final username=TextEditingController();
  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  SizedBox(height: media.height * 0.12),
                  CircleAvatar(
                    radius: 70,
                    foregroundColor: Colors.pink,
                    backgroundImage: AssetImage("assets/main_logo.jpg"),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(height: media.height * 0.03),

                  SizedBox(
                    child: Text(
                      "Hello!",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: media.height * 0.03),

                  TextFormField(
                  controller: username,
                    decoration: InputDecoration(
                      label: Text("Name"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter name ";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: media.height * 0.02),

                  TextFormField(
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
                      label: Text("Password"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter password";
                      }
                      return null ;
                    },
                  ),

                  SizedBox(height: media.height * 0.02),

                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      label: Text("Confirm Password"),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter password ";
                      }
                      if (value != password.text) {
                        return " password mismatched ";
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: media.height * 0.01),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          var data=await Login.login_user(username.text, password.text);
                          if(data['success']==true) {
                            SharedPreferences login_token = await SharedPreferences
                                .getInstance();
                            await login_token.setString("token", data['token']);
                            await login_token.setString("id", data['user_id'].toString());
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>ChatSection()),
                              (route)=>false);

                      }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(data['error']??"login failed",),duration: Duration(seconds: 1),)
                            );
                          }
                        }
                      },
                      child: Text("Submit"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Spacer(flex: 1),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have account ? ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => register(),
                                ),
                              );
                            },
                            child: Text(
                              "Register",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
