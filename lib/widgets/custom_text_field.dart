import 'package:flutter/material.dart';

import '../helpers/scheme.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {super.key,
        this.secure,
        required this.controller,
        required this.labelAndHint,
        required this.validator, required this.prefixIcon});

  final TextEditingController controller;
  final bool? secure;
  final String labelAndHint;
  final IconData prefixIcon;
  final String? Function(String?)? validator;
  final primaryColor = Colors.blue;


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            offset: Offset(-3,3),
            color: Colors.transparent,
            blurRadius: 3
          )
        ]
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        obscureText: secure ?? false,
        validator: validator,
        decoration: InputDecoration(
          hintText: labelAndHint,
          isDense: true,
          prefixIcon: Icon(prefixIcon),
          labelText: labelAndHint,
          labelStyle: TextStyle(
            color: Colors.black
          ),
          fillColor: Colors.black12.withOpacity(0.1),

          filled: true,
          hintStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(8.0)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(12.0)
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(12.0)
          ),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(12.0)
          ),
        ),
      ),
    );
  }
}

InputDecoration textFieldDecorationTheme = InputDecoration(
  filled: true,
  fillColor: Color(0xFFf7a793),
  isDense: true,
  isCollapsed: true,
  contentPadding: EdgeInsets.all(12.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: BorderSide(color: Colors.black, width: 2),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: BorderSide(color: Colors.black, width: 2),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: BorderSide(color: Colors.black, width: 2),
  ),
);

TextStyle textFieldTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.black87,
);


class NormalTemplateTextField extends StatelessWidget {
    final Function(String)? onChanged;
    String? Function(String?)? validator;
  final TextEditingController? controller;
  final String hintText;
  final int? lines;
  Color? backgroundColor;

  NormalTemplateTextField({
    super.key,
    this.lines,
    this.onChanged, 
    this.validator,
    this.backgroundColor,
    this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      maxLines: lines,
      textAlignVertical: TextAlignVertical.center,
      decoration: textFieldDecorationTheme.copyWith(
        hintText: hintText,
        fillColor: backgroundColor ?? Color(0xFFafcbbf)
      ),
      style: textFieldTextStyle,
    );
  }
}
