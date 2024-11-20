import 'package:flutter/material.dart';
import 'package:responsi/components/flushbar.dart';
import 'package:responsi/components/loading.dart';
import 'package:responsi/components/primary_button.dart';
import 'package:responsi/components/resto_text_form_field.dart';
import 'package:responsi/pages/main_page.dart';
import 'package:responsi/pages/register_page.dart';
import 'package:responsi/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late bool _isValidation = false;
  late bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkIfUserExists(); // Check if the user exists
  }

  // Function to check if the user is registered
  Future<void> _checkIfUserExists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');

    if (savedUsername == null) {
      // If there are no registered users, navigate to the registration page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const RegisterPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: SafeArea(
              child: Form(
                key: _loginFormKey,
                autovalidateMode: _isValidation ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      'Welcome!',
                      style: RestoFonts(context).boldQuicksand(
                        size: 32,
                        color: RestoColors.primary,
                      ),
                    ),
                    Text(
                      'Login in to continue',
                      style: RestoFonts(context).semiBoldQuicksand(size: 13, color: RestoColors.black),
                    ),
                    const SizedBox(height: 60),
                    const Icon(
                      Icons.restaurant,
                      size: 100,
                      color: RestoColors.primary,
                    ),
                    const SizedBox(height: 30),
                    RestoTextFormField(
                      noLabel: true,
                      controller: _usernameController,
                      hint: 'Username',
                      capitalization: TextCapitalization.none,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Username is required";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    RestoTextFormField(
                      noLabel: true,
                      password: true,
                      suffix: true,
                      controller: _passwordController,
                      hint: 'Password',
                      capitalization: TextCapitalization.none,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Password is required";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    PrimaryButton(
                      text: 'LOGIN',
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        setState(() {
                          _isValidation = true;
                        });
                        if (_loginFormKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });

                          // Retrieve data from SharedPreferences
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          String? savedUsername = prefs.getString('username');
                          String? savedPassword = prefs.getString('password');

                          // Validate username and password
                          if (_usernameController.text == savedUsername && _passwordController.text == savedPassword) {
                            await Future.delayed(const Duration(seconds: 1), () {
                              setState(() {
                                _isLoading = false;
                              });
                            });
                            // Navigate to MainPage with username
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => MainPage(username: _usernameController.text), // Sending username
                              ),
                            );
                          } else {
                            setState(() {
                              _isLoading = false;
                            });
                            alert(context, text: 'Username or Password is incorrect', icon: Icons.error);
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegisterPage()));
                      },
                      child: Text(
                        "Don't have an account? Register here.",
                        style: TextStyle(color: RestoColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        LoadingScreen(loading: _isLoading),
      ],
    );
  }
}
