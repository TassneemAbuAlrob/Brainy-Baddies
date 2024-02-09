import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';

class TemplateContainerCardWithIcon extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData icon;
  final String title;
  Color? backgroundColor;  
  double widthFactor;
  double? height;

  TemplateContainerCardWithIcon({super.key,this.height, this.widthFactor = 1, this.onTap, required this.icon, required this.title, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: media.width * widthFactor,
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: backgroundColor ?? primaryColor,
          borderRadius: BorderRadius.circular(0.0),

        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon, // Replace with category-specific icons
              color: Colors.white,
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
