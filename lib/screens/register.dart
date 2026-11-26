import 'package:demo_app/authentication/auth.dart';
import 'package:demo_app/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class register extends ConsumerStatefulWidget {
  const register({super.key});

  @override
  ConsumerState<register> createState() => _registerState();
}

class _registerState extends ConsumerState<register> {
  int currentPage = 0;
  final mobileFormKey = GlobalKey<FormState>();
  final emailFormKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();
  final phone = TextEditingController();
  final confirm_phone = TextEditingController();
  final email = TextEditingController();
  final confirm_email = TextEditingController();
  final pass = TextEditingController();
  final confirm_pass = TextEditingController();
  final page = PageController();
  bool pass_show = false;
  bool confirm_pass_show = false;

  @override
  void dispose() {
    page.dispose();
    phone.dispose();
    confirm_phone.dispose();

    email.dispose();
    confirm_email.dispose();
    pass.dispose();
    confirm_pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: height * 0.10),
            CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage("assets/main_logo.jpg"),
            ),

            Expanded(
              child: PopScope(
                canPop: currentPage == 0,
                onPopInvokedWithResult: (didPop, result) {
                  if (!didPop && currentPage > 0) {
                    page.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  }
                },

                child: PageView(
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  controller: page,
                  physics: NeverScrollableScrollPhysics(),

                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 100,
                      ),
                      child: Form(
                        key: mobileFormKey,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(9.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: phone,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: InputDecoration(
                                    label: Text("Enter your Mobile number"),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter your mobile number";
                                    }
                                    if (value.length != 10) {
                                      return "Mobile number must contain 10 digits";
                                    }

                                    return null;
                                  },
                                ),

                                SizedBox(height: height * 0.01),

                                TextFormField(
                                  controller: confirm_phone,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    label: Text("Confirm Mobile number"),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please confirm your mobile number";
                                    }
                                    if (value.length != 10) {
                                      return "Mobile number must contain 10 digits";
                                    }

                                    if (confirm_phone != phone.text) {
                                      return "Mobile numbers do not match";
                                    }

                                    return null;
                                  },
                                ),

                                SizedBox(height: 20),

                                ElevatedButton(
                                  onPressed: () {
                                    if (mobileFormKey.currentState!
                                        .validate()) {
                                      page.nextPage(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeIn,
                                      );
                                    }
                                  },

                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    backgroundColor: Colors.lightBlue,
                                  ),
                                  child: Text("Next"),
                                ),
                                SizedBox(height: height * 0.1),
                                Text.rich(
                                  TextSpan(
                                    text: "Already signed up? ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "Login",

                                        style: TextStyle(color: Colors.blue),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => login(),
                                              ),
                                            );
                                          },
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 60,
                      ),
                      child: Form(
                        key: emailFormKey,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(9.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: email,
                                  decoration: InputDecoration(
                                    label: Text("Enter your Email"),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please fill your details";
                                    }
                                    if (!value.contains('@gmail.com')) {
                                      return "Please enter a valid Gmail address";
                                    }
                                    return null;
                                  },
                                ),

                                SizedBox(height: height * 0.01),

                                TextFormField(
                                  controller: confirm_email,
                                  decoration: InputDecoration(
                                    label: Text("Confirm your Email"),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please fill your details";
                                    }
                                    if (!value.contains('@gmail.com')) {
                                      return "Please enter a valid Gmail address";
                                    }
                                    if (confirm_email != email.text) {
                                      return "Email do not match";
                                    }

                                    return null;
                                  },
                                ),

                                SizedBox(height: 20),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        page.previousPage(
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeIn,
                                        );
                                      },

                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        backgroundColor: Colors.lightBlue,
                                      ),
                                      child: Text("Previous"),
                                    ),

                                    ElevatedButton(
                                      onPressed: () {
                                        if (emailFormKey.currentState!
                                            .validate()) {
                                          page.nextPage(
                                            duration: Duration(
                                              milliseconds: 300,
                                            ),
                                            curve: Curves.easeIn,
                                          );
                                        }
                                      },

                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        backgroundColor: Colors.lightBlue,
                                      ),
                                      child: Text("Next"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 60,
                      ),
                      child: Form(
                        key: passwordFormKey,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(9.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: pass,
                                  obscureText: !pass_show,
                                  decoration: InputDecoration(
                                    label: Text("Password"),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        pass_show
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          pass_show = !pass_show;
                                        });
                                      },
                                    ),
                                  ),

                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Fill details";
                                    }
                                    if (!RegExp(
                                      r'[!@#$%^&*(),.?":{}|<>]',
                                    ).hasMatch(value)) {
                                      return "Password must contain at least one special character";
                                    }

                                    return null;
                                  },
                                ),

                                SizedBox(height: height * 0.01),

                                TextFormField(
                                  controller: confirm_pass,
                                  obscureText: !confirm_pass_show,
                                  decoration: InputDecoration(
                                    label: Text("Confirm password"),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        confirm_pass_show
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          confirm_pass_show =
                                              !confirm_pass_show;
                                        });
                                      },
                                    ),
                                  ),

                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Fill details";
                                    }

                                    if (confirm_pass != pass.text) {
                                      return "Password mismatched";
                                    }
                                    if (!RegExp(
                                      r'[!@#$%^&*(),.?":{}|<>]',
                                    ).hasMatch(value)) {
                                      return "Password must contain at least one special character";
                                    }

                                    return null;
                                  },
                                ),

                                SizedBox(height: height * 0.01),

                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (passwordFormKey.currentState!
                                          .validate()) {
                                        try {
                                          final response = await auth.signup(
                                            email.text,
                                            phone.text,
                                            pass.text,
                                          );

                                          if (response["message"] == "error") {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                duration: Duration(seconds: 2),
                                                content: Text(
                                                  "error: ${response["error_details"]}",
                                                ),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                duration: Duration(seconds: 2),
                                                content: Text(
                                                  response["message"],
                                                ),
                                              ),
                                            );
                                            email.clear();
                                            confirm_email.clear();
                                            phone.clear();
                                            confirm_phone.clear();
                                            confirm_pass.clear();
                                            pass.clear();
                                          }
                                        } catch (e) {
                                          print("error: ${e}");
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      backgroundColor: Colors.lightBlue,
                                    ),
                                    child: Text("Sign Up"),
                                  ),
                                ),

                                SizedBox(height: height * 0.02),

                                Text.rich(
                                  TextSpan(
                                    text: "By Signing up, you agree to our\n",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            "Terms, Data Policy and Cookies Policy",
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),

                                SizedBox(height: 15),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
