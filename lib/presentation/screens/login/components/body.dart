//p2
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:log/data/services/user_services.dart';
import 'package:log/presentation/screens/chat_screen.dart';
import 'package:log/presentation/screens/mainChild.dart';
import 'package:log/presentation/screens/parent/perantDash.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../components/rounded_button.dart';
import '../../home_screen.dart';
import 'alreadyHaveAccout.dart';
import 'background.dart';
import 'roundedPassField.dart';
import 'rounded_input_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

class body extends StatelessWidget {
  body({
    super.key,
  });

  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return background(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "LOGIN",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 55, 164, 241),
                ),
              ),

              SvgPicture.asset(
                "android/icons/log1.svg",
                height: size.height * 0.5,
              ),

              RoundedInputField(
                hintText: "Your Email",
                onChanged: (value) {
                  email = value;
                },
                controller: emailController, // Pass the user object here
              ),

              RoundedPasswordField(
                onChanged: (value) {
                  password = value;
                },
                controller: passwordController, // Pass the user object here
              ),
//--------------------------------------------
              RoundedButton(
                text: "LOG IN",
                color: Color.fromARGB(255, 141, 199, 241),
                press: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await UserServices.login(
                          context: context,
                          email: emailController.text,
                          password: passwordController.text);

                      SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      String? role = sharedPreferences.getString('role');
                      if (role == "child") {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => mainChild()));
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PerantDash()));
                      }
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error.toString())));
                    }
                  } else {
                    print("not ok");
                  }

                  ///for firebase
                  try {
                    final userr = await _auth.signInWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );
                    if (userr != null) {
                      print("user from firebassse");
                    }
                  } catch (e) {
                    print("error from firebase login ${e}");
                  }
                },
              ),

//-----------------------------------
              AlreadyHaveAnAccountChecked(
                press: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
