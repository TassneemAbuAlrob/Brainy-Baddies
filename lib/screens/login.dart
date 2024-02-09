import 'package:alaa_admin/helpers/scheme.dart';
import 'package:alaa_admin/models/auth_credentials.dart';
import 'package:alaa_admin/screens/home_navigator.dart';
import 'package:alaa_admin/services/auth_service.dart';
import 'package:alaa_admin/widgets/background_clip.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'control_panel_home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  final logoImage = Image.asset('assets/admin-logo.png',width: 200,height: 200,fit: BoxFit.cover,); // Your logo image path


  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.blue;
    final secondaryColor = Colors.green;
    final backgroundColor = Color(0xFFF5F5F5); // Light gray background
    final textColor = Colors.black;
    final backgroundPattern = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.grey[200]!, Colors.grey[300]!], // Subtle diagonal stripes
      ),
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      body: background(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    logoImage,
                    SizedBox(
                      height: 20,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Welcome back ',
                            style: TextStyle(fontSize: 26, color: textColor),
                          ),
                          TextSpan(
                            text: "Admin",
                            style: TextStyle(
                              fontSize: 26,
                              color: AppColors.secondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      "Login to your Account",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 12,),
                    CustomTextFormField(
                      prefixIcon: Icons.email,
                      controller: _emailController,
                      labelAndHint: 'Email',
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty) {
                            return "Please enter something";
                          } else if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                            return "Not a valid email";
                          }

                          return null;
                        }

                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextFormField(
                      prefixIcon: Icons.password,
                      controller: _passwordController,
                      labelAndHint: 'Password',
                      secure: true,
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty) {
                            return "Please enter something";
                          }

                          return null;
                        }

                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        child: Text('Login', style: customTextStyle,),
                        style: customButtonStyle,
                        onPressed: () async {
                          Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => HomeNavigatorScreen(),
                                  ),
                                );
                          // if (_formKey.currentState != null) {
                          //   if (_formKey.currentState!.validate()) {
                          //     AuthCredentials credentials = AuthCredentials(
                          //       email: _emailController.text,
                          //       password: _passwordController.text,
                          //     );

                          //     try {
                          //       await AuthService.login(credentials);
                          //       Navigator.of(context).push(
                          //         MaterialPageRoute(
                          //           builder: (context) => HomeNavigatorScreen(),
                          //         ),
                          //       );
                          //     } catch (error) {
                          //       ScaffoldMessenger.of(context).showSnackBar(
                          //         SnackBar(content: Text(error.toString())),
                          //       );
                          //     }
                          //   }
                          // }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
