import 'package:flutter/material.dart';
import 'package:responsi/components/flushbar.dart';
import 'package:responsi/components/loading.dart';
import 'package:responsi/components/primary_button.dart';
import 'package:responsi/components/resto_text_form_field.dart';
import 'package:responsi/pages/login_page.dart';
import 'package:responsi/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  late bool _isValidation = false;
  late bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: SafeArea(
              child: Form(
                key: _registerFormKey,
                autovalidateMode: _isValidation ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Text('Create Account',
                        style: RestoFonts(context).boldQuicksand(
                          size: 32,
                          color: RestoColors.primary,
                        )),
                    Text(
                      'Fill in the details below to register',
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
                    const SizedBox(height: 15),
                    RestoTextFormField(
                      noLabel: true,
                      password: true,
                      suffix: true,
                      controller: _confirmPasswordController,
                      hint: 'Confirm Password',
                      capitalization: TextCapitalization.none,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Confirm password is required";
                        } else if (val != _passwordController.text) {
                          return "Passwords do not match";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    PrimaryButton(
                      text: 'REGISTER',
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        setState(() {
                          _isValidation = true;
                        });
                        if (_registerFormKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });

                          // Simpan data ke SharedPreferences
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.setString('username', _usernameController.text);
                          await prefs.setString('password', _passwordController.text);

                          await Future.delayed(const Duration(seconds: 1), () {
                            setState(() {
                              _isLoading = false;
                            });
                          });

                          alert(context, text: 'Registration successful!', icon: Icons.check);
                          
                          // Arahkan ke halaman Login setelah pendaftaran
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        }
                      },
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
