import 'package:flutter/material.dart';

class BasicButton extends StatelessWidget {
  const BasicButton({super.key, required this.onPressed, required this.text, required this.color});
  final VoidCallback onPressed;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}

class CustomFullWidthButton extends StatelessWidget {
  const CustomFullWidthButton(
      {super.key, required this.onPressed, required this.text,required this.color});
  final VoidCallback onPressed;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 4,
          minimumSize: Size(double.infinity, 50)),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}


class InfoTemplateButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  double? height;
  double? width;

  InfoTemplateButton({super.key,this.height,this.width, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, 
      style: infoButtonStyle.copyWith(
        minimumSize: MaterialStatePropertyAll(
          Size(width ?? 0, height ?? 40)
        )
      ),
      child: Text(text, style: normalButtonTextStyle)
    );
  }
}

const Color primaryColor =const Color(0xFF018afe);
const Color secondaryColor =const Color(0xFF2b435d);

ButtonStyle normalButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: primaryColor,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.0)
  ),
    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
  elevation: 0,
);

ButtonStyle infoButtonStyle = normalButtonStyle.copyWith(
  backgroundColor: MaterialStatePropertyAll(secondaryColor)
);

TextStyle normalButtonTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.white
);