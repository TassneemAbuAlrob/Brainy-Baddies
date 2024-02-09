import 'package:flutter/material.dart';

import 'text_field_container.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  const RoundedPasswordField({
    Key? key,
    required this.onChanged,
    required this.controller, // Accept the User object as a parameter
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField( // Use TextFormField instead of TextField
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Enter something';
          }
          return null;
        },
        obscureText: true,
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: Color.fromARGB(255, 141, 199, 241),
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: Color.fromARGB(255, 141, 199, 241),
          ),
          border: InputBorder.none,
        ),

        
      ),
    );
  }
}
