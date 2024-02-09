//contains the text and bottons in the first page
import'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:log/presentation/screens/register/register_screen.dart';

import '../../components/rounded_button.dart';
import '../login/login_screen.dart';
import 'background.dart';

class Body extends StatelessWidget {
@override
Widget build (BuildContext context)
{
   
Size size = MediaQuery.of(context).size; // this size provides us total height and width of screen
//class background contains the pic in the first page, top+bottom
return Background (
  child:SingleChildScrollView(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children:<Widget>[
      Text(
        "Welcome to BRAINYBUDDIES!!",
    style:TextStyle(fontWeight:FontWeight.bold,
    color: Color.fromARGB(255, 55, 164, 241),
    ),
    ),
  
    SizedBox(height: size.height* 0.03),
    SvgPicture.asset(
      "android/icons/welcome.svg",
      height: size.height * 0.45,
    ),
    SizedBox(height: size.height* 0.03),
  
   RoundedButton(
    text:"LOGIN",
    color: Color.fromARGB(228, 205, 245, 250),
    textColor: Color.fromARGB(255, 55, 164, 241),
    press:() {
      Navigator.push(
        context,
         MaterialPageRoute(
          builder: (context){
            return LoginScreen();
            },
            ),
            );
            },
  
   ),
  // THIS IS FOR THE NEXT BOTTON IN THE FIRST PAGE
   RoundedButton(
    text:"SIGNUP",
    color: Color.fromARGB(228, 205, 245, 250),
    textColor: Color.fromARGB(255, 55, 164, 241),
    press:() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RegisterScreen()
        )
      );
    },
  
   ),
  
  
    ],
  ),
  ),
);
}
}
