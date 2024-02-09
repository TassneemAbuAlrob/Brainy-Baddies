import 'package:alaa_admin/helpers/scheme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  buildMenuItem(
                    iconData: Icons.qr_code_scanner,
                    text: 'Scan qrode',
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) {
                      //   return const QrCodeScanner();
                      // }));
                    },
                  ),
                  buildMenuItem(
                    iconData: FontAwesomeIcons.shieldHalved,
                    text: 'Conditions & Terms',
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) {
                      //   return TermsAndConditionsScreen();
                      // }));
                    },
                  ),
                  buildMenuItem(
                    iconData: FontAwesomeIcons.info,
                    text: 'About JPC',
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) {
                      //   return AboutScreen();
                      // }));
                    },
                  ),
                  // buildMenuItem(
                  //   iconData: FontAwesomeIcons.solidStar,
                  //   text: 'Wish List',
                  //   onTap: () async {
                  //     Navigator.of(context).push(
                  //       MaterialPageRoute(builder: (context) => WishlistScreen()),
                  //     );
                  //   },
                  // ),

                  buildMenuItem(
                    iconData: FontAwesomeIcons.clockRotateLeft,
                    text: 'History',
                    onTap: () async {
                      // Navigator.pushNamed(context,PurchaseHistoryScreen.history);
                    },
                  ),
                  // buildMenuItem(
                  //   iconData: FontAwesomeIcons.boxesPacking,
                  //   text: 'Orders',
                  //   onTap: () async {
                  //     Navigator.of(context).push(
                  //       MaterialPageRoute(builder: (context) => OrdersListScreen()),
                  //     );
                  //   },
                  // ),
                  buildMenuItem(
                      iconData: FontAwesomeIcons.arrowRightFromBracket,
                      text: 'Logout',
                      onTap: () {
                        // context.read<AuthStatusBloc>().add(
                        //     SignOutEvent()
                        // );
                      },
                      textColor: Colors.red,
                      trailingIconColor: Colors.red,
                      leadingIconColor: Colors.red
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required IconData iconData,
    required String text,
    required VoidCallback onTap,
    Color? leadingIconColor,
    Color? trailingIconColor,
    Color? textColor,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 6,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          iconData,
          size: 26,
          color: leadingIconColor ?? AppColors.primaryColor,
        ),
        title: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor ?? AppColors.primaryColor,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 20,
          color: trailingIconColor ?? AppColors.primaryColor,
        ),
        onTap: onTap,
      ),
    );
  }
}
