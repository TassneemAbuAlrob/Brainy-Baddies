//for the details of the button 
import'package:flutter/material.dart';

import '../../core/constants/colors.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback? press; // Change the type to VoidCallback
  final Color color, textColor;

  const RoundedButton({
    Key? key, // Fix the typo in 'super.key'
    required this.text,
    this.press,
    this.color = KPrimaryColor,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            backgroundColor: color,
          ),
          onPressed: press, 
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}
