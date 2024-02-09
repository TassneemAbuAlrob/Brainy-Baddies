import 'package:flutter/material.dart';

import 'text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData iconData; // Changed the parameter name
  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  const RoundedInputField({
    Key? key, // Use 'Key?' for the key parameter
    required this.hintText,
    this.iconData = Icons.person, // Changed the parameter name
    required this.onChanged,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField( // Use TextFormField instead of TextField
        controller: controller,
        decoration: InputDecoration(
          icon: Icon(
            iconData, // Use the corrected parameter name
            color: Color.fromARGB(255, 141, 199, 241),
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
