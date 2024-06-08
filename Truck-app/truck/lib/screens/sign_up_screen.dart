import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truck_app/db/hive_client.dart';
import 'package:truck_app/models/index.dart';
import 'package:truck_app/screens/login_screen.dart';
import 'package:truck_app/screens/truck_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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

  void _navigateToLoginPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
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

  void _submitForm() {
    if (_formKey.currentState?.validate() == true) {
      final email = _emailController.text.toLowerCase();
      final password = _passwordController.text;

      log('Email: $email, Password: $password');
      final bool isExistingUser = HiveClient()
          .userBox
          .values
          .cast<User>()
          .any((element) => element.email == email);
      if (!isExistingUser) {
        final User newUser = User(email: email, password: password);
        // To know which is the current logged in User
        HiveClient().currentUserBox.clear();
        HiveClient().currentUserBox.add(newUser);

        HiveClient().userBox.add(newUser);

        HiveClient().orderBox.clear();
        HiveClient().currentCartTruckBox.clear();

        _navigateToTrucksPage();
      } else {
        _showSignUpFailedPopup();
      }
    }
  }

  void _showSignUpFailedPopup() {
    AlertDialog alert = AlertDialog(
      title: const Text('Account already exists'),
      content: const Text('Please proceed to login with your account.'),
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 250,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Log In ',
                      style: GoogleFonts.aBeeZee(
                          fontSize: 50, fontWeight: FontWeight.bold),
                    ),

                    //
                  ],
                ),
                const SizedBox(height: 60),
                Form(
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                              backgroundColor: const Color(0xff6652cc)),
                          onPressed: _submitForm,
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.aBeeZee(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text('Already Have An Account ? Login Now.'),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: _navigateToLoginPage,
                        child: Text('Login', style: GoogleFonts.aBeeZee()),
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
