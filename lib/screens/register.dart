import 'package:demo_app/screens/auth.dart';
import 'package:demo_app/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final emailProvider = StateProvider<String>((ref) => '');
class register extends ConsumerStatefulWidget {
  const register({super.key});

  @override
  ConsumerState<register> createState() => _registerState();
}

class _registerState extends ConsumerState<register> {
  final Formkey = GlobalKey<FormState>();
  final pass = TextEditingController();
  @override
  void dispose() {
   pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: media.height * 0.12),
            CircleAvatar(
              radius: 70,
              backgroundImage: AssetImage("assets/main_logo.jpg"),
            ),

            Form(
              key: Formkey,
              child: Padding(
                padding: EdgeInsets.all(9.0),
                child: Column(
                  children: [
                    TextFormField(
                      onChanged: (value) {
                        ref.read(emailProvider.notifier).state=value;
                      },
                      decoration: InputDecoration(
                        label: Text("email Or Phone"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter your email";
                        }
                        final bool isPhone = RegExp(r'^\+?[0-9]{7,15}$').hasMatch(value.trim());

                        final bool isEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim());

                        if (!isPhone && !isEmail) {
                          return "Enter a valid email or phone number";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: media.height * 0.01),
                    TextFormField(
                      decoration: InputDecoration(
                        label: Text("Confirm Email Or Phone"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "fill this field";
                        }
                        if (value != ref.read(emailProvider)) {
                          return "Email mismatched";
                        }

                        return null;
                      },
                    ),

                    SizedBox(height: media.height * 0.01),
                    TextFormField(
                      controller: pass,
                      obscureText: true,
                      decoration: InputDecoration(
                        label: Text("Password"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Fill details";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: media.height * 0.01),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        label: Text("Confirm password"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Fill Detail";
                        }
                        if (value != pass.text) {
                          return "Password mismatched";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: media.height * 0.01),
                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton(
                      onPressed: () async {
                          if (Formkey.currentState!.validate()) {
                            var data = await auth.signup(
                                ref.read(emailProvider), pass.text);
                            if (data['Status'] == true) {
                              pass.clear();
                              ref.read(emailProvider.notifier).state="";
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>login()));

                            }

                            else {
                              String errorMessage = data['message'] ??
                                  "Registration failed";
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(errorMessage,),
                                    backgroundColor: Colors.red,duration: Duration(seconds: 1),),
                              );
                            }
                          }
                        },

                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor: Colors.lightBlue,
                        ),
                        child: Text("Sign IN"),
                      ),
                    ),

                    SizedBox(height: media.height * 0.02),
                    SizedBox(
                      child: Text.rich(
                        TextSpan(
                          text: "By Signing up, you agree to our\n",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          children: [
                            TextSpan(
                              text: "Terms, Data Policy and Cookies Policy",
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Have an account ? ",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => login()),
                        );
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
