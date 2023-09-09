import 'dart:convert';

import 'package:conferences_mobile/components/backgroundScrollView.dart';
import 'package:conferences_mobile/components/customAppBar.dart';
import 'package:conferences_mobile/components/drawer.dart';
import 'package:conferences_mobile/model/auth.dart';
import 'package:conferences_mobile/network/autentification_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoggedIn = false;
  String? message1;
  String? message2;

  @override
  void initState() {
    super.initState();
    _checkLoggedInStatus();
  }

  void _login() async {
    try {
      String email = emailController.text;
      String password = passwordController.text;
      final response = {'email': email, 'password': password};
      final jsonData = jsonEncode(response);
      int result = await AuthentificationService.loginUser(jsonData);
      if (result == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Logged in successfully!'),
              backgroundColor: Color(0xff4a23b2)),
        );
        Navigator.of(context).pushNamed('/');
      } else if (result == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You are allready logged in!')),
        );
        Navigator.of(context).pushNamed('/');
      } else {
        setState(() {
          message1 = 'Wrong input';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('wrong input')),
        );
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> _checkLoggedInStatus() async {
    await Future.delayed(Duration.zero);
    UserModel? user = await AuthModel().LoggedInUser();
    setState(() {
      if (user == null) {
        isLoggedIn = false;
      } else {
        isLoggedIn = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('You are already loggedin!'),
              backgroundColor: Color(0xffbe2b61)),
        );
        Navigator.of(context).pushNamed('/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == false) {
      return SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            onDrawerIconPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MyDrawer(
                    onDrawerIconPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
              );
            },
            onBackIconPressed: () {
              Navigator.pop(context);
            },
            showBackIcon: false,
          ),
          body: Stack(children: [
            const BackgroundScrollView(),
            SingleChildScrollView(
              child: Column(children: [
                const Center(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                    child: Text(
                      'LOGIN!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                ),
                Text(
                  message1 ?? '',
                  style: const TextStyle(color: Colors.red),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FractionallySizedBox(
                    widthFactor: 0.9,
                    child: TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Color(0xffbe2b61)),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xff4a23b2), width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffeadc48),
                            width: 0.50,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 6.0,
                        ),
                        fillColor: Color(0xff1a1a1a),
                        filled: true,
                      ),
                      style:
                          const TextStyle(color: Colors.amber, fontSize: 18.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FractionallySizedBox(
                    widthFactor: 0.9,
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Color(0xffbe2b61)),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xff4a23b2), width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffeadc48),
                            width: 0.50,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 6.0,
                        ),
                        fillColor: Color(0xff1a1a1a),
                        filled: true,
                      ),
                      style:
                          const TextStyle(color: Colors.amber, fontSize: 20.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'In case You do not have an account ',
                      style: const TextStyle(
                        color: Color(0xffbe2b61),
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Register',
                            style: const TextStyle(
                              color: Color(0xffeadc48),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).pushNamed('/register');
                              }),
                        const TextSpan(text: ' now!'),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffbe2b61),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Color(0xffbb2a5f),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () {
                        _login();
                      },
                      child: const Text(
                        'Login!',
                      ),
                    ),
                  ),
                ),
              ]),
            )
          ]),
        ),
      );
    } else {
      return Scaffold(
        appBar: CustomAppBar(
          onDrawerIconPressed: () {
            Scaffold.of(context).openDrawer();
          },
          onBackIconPressed: () {
            Navigator.of(context).maybePop();
          },
          showBackIcon: true,
        ),
        drawer: MyDrawer(
          onDrawerIconPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        body: const Stack(
          children: [
            BackgroundScrollView(),
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      );
    }
  }
}
