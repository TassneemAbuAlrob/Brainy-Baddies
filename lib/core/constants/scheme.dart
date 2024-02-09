import 'package:flutter/material.dart';

final Color buttonBackgroundColor = Color(0xFF63746a);
final Color screenBackgroundColor = Color(0xFFe9e0db);
final Color lightGreen = Color(0xFFafcabd);
final Color heavyGreen = Color(0xFF758c7f);

final ButtonStyle customButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: buttonBackgroundColor,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.0),
    side: BorderSide(
      color: Colors.black,
      width: 2
    )
  ),
);

final TextStyle customTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 16
  // fontSize: 18
);

class AppColors {
  static const Color primaryColor = Color(0xFF007ACC); // Navy Blue
  // static const Color secondaryColor = Color(0xFF009688); // Teal

  // static const Color primaryColor = Color(0xFFc1dbec); // Navy Blue
  static const Color secondaryColor = Color(0xFF009688); // Teal

  static const Color headerColor = Color(0xFF859f8f);

  static const Color backgroundColor = Color(0xFFEEEDED); // Light Gray
  static const Color scaffoldColor = Color(0xFFafcabd);
  static const Color cardColor = Color(0xFFFFFFFF); // White
  static const Color textDarkColor = Color(0xFF333333); // Dark Gray
  static const Color textLightColor = Color(0xFF666666); // Gray
  // static const Color accentColor = Color(0xFFFFA726); // Amber
  static const Color accentColor = Color(0xFFFFA726); // Amber

  static const Color dangerColor = Color(0xFFe54644);

// Additional professional colors...
}
