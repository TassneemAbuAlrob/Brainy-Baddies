import'package:flutter/material.dart';

class AlreadyHaveAnAccountChecked extends StatelessWidget {
  final bool login;
  final VoidCallback press; // Change the type to VoidCallback

  const AlreadyHaveAnAccountChecked({
    Key? key, // Fix the typo in 'super.key'
    this.login = true,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Don't have an Account?" : "Already Have An Account?",
          style: TextStyle(
            color: Color.fromARGB(255, 55, 164, 241),
           fontWeight: FontWeight.bold,
          ),
          
        ),
        GestureDetector(
          onTap: press, // Use the VoidCallback here
          child: Text(
            login ? "Sign Up" : "Sign In",
            style: TextStyle(
            color: Color.fromARGB(255, 55, 164, 241),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
