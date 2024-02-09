import 'package:alaa_admin/helpers/scheme.dart';
import 'package:flutter/material.dart';

class StatisticBox extends StatelessWidget {
  final Color color;
  final String text;
  final int count;
  final Widget route;
  final IconData boxIcon;

  const StatisticBox({
    Key? key,
    required this.color,
    required this.text,
    required this.count,
    required this.route,
    required this.boxIcon
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => route),
        );
      },
      child: Container(
        height: 120,
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),

          color: color,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  count.toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            Icon(boxIcon,size: 30,color: Colors.white,)
          ],
        ),
      ),
    );
  }
}
