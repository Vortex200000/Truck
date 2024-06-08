import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truck_app/db/hive_client.dart';
import 'package:truck_app/screens/sign_up_screen.dart';
import 'package:truck_app/screens/truck_screen.dart';

import '../models/index.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  String? _validateEmail(String? email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9.\-]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );

    if (email == null || email.trim().isEmpty == true) {
      return 'Email cannot be empty';
    } else if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  String? _validatePassword(String? password) {
    if (password == null || password.trim().isEmpty == true) {
      return 'Password cannot be empty';
    }

    return null;
  }

  void _navigateToSignupPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      ),
    );
  }

  void _navigateToTrucksPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TruckScreen(),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() == true) {
      final email = _emailController.text.toLowerCase();
      final password = _passwordController.text;

      try {
        log(HiveClient().userBox.values.toString());
        log('email: $email, password: $password');
        final User user = HiveClient()
            .userBox
            .values
            .cast<User>()
            .firstWhere((element) => element.email == email);
        if (user.password == password) {
          final User user = User(email: email, password: password);
          await clearDataIfDifferentUser(user);
          await HiveClient().currentUserBox.add(user);
          log('${HiveClient().currentUserBox.values}');
          _navigateToTrucksPage();
        } else {
          _showLoginFailedPopup();
        }
      } catch (e) {
        _showLoginFailedPopup();
        log('show failure');
      }
    }
  }

  Future<void> clearDataIfDifferentUser(User user) async {
    try {
      log('currentUser: ${HiveClient().currentUserBox.values}');
      final User? lastLoggedInUser =
          HiveClient().currentUserBox.values.firstOrNull as User?;
      // clear data if it's not the last logged in user
      if (lastLoggedInUser != null && lastLoggedInUser.email != user.email) {
        log('different user logging in, emptying the db');
        await HiveClient().orderBox.clear();
        await HiveClient().currentUserBox.clear();
        await HiveClient().currentCartTruckBox.clear();
      }
    } catch (e) {
      log('throwing exception at: clearDataIfDifferentUser');
    }
  }

  void _showLoginFailedPopup() {
    AlertDialog alert = AlertDialog(
      title: const Text('Invalid email or password'),
      content: const Text('Please verify your username and password'),
      actions: [
        ElevatedButton(
          onPressed: _dismissAlert,
          child: const Text('OK'),
        )
      ],
    );

    showDialog(
      context: context,
      builder: (context) => alert,
    );
  }

  void _dismissAlert() {
    Navigator.of(context).maybePop();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Center(child: const Text("Login")),
      // ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 250,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Sign Up',
                        style: GoogleFonts.aBeeZee(
                            fontSize: 50, fontWeight: FontWeight.bold)),
                  ],
                ),
                // Image.asset(
                //   'assets/truck.png',
                //   width: 100,
                //   height: 100,
                // ),
                const SizedBox(height: 60),
                Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(14))),
                          labelText: 'E-mail',
                        ),
                        validator: (email) => _validateEmail(email),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(14))),
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            onPressed: _togglePasswordVisibility,
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        validator: (password) => _validatePassword(password),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              elevation: 0,
                              backgroundColor: const Color(0xff6652cc)),
                          onPressed: _submitForm,
                          child: Text(
                            'Sign up',
                            style: GoogleFonts.aBeeZee(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: _navigateToSignupPage,
                        child: Text('I have Account ' 'Login',
                            style: GoogleFonts.aBeeZee()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
