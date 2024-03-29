//class background contains the pic in the first page, top+bottom

import'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child ;
  const Background({
     Key? key,
    required this.child,
  }): super(key:key);


  @override
  Widget build(BuildContext context) {
  Size size = MediaQuery.of(context).size; // this size provides us total height and width of screen

    return Container(
    
      height:size.height,
    
      width: double.infinity,
    
      child:Stack (
    
        alignment: Alignment.center,
    
        children:<Widget>[
    
    Positioned(
    
      top:0,
    
      left:0,
    
    child: Image.asset("android/images/main_top.png",
    
    width:size.width *0.3,)
    
    ),
    
    
    
    Positioned
    
    (  bottom: 0,
    
       left:0,
    
       child:Image.asset("android/images/main_bottom.png",
    
       width:size.width *0.2,)
    
    ),
    child,
    ],
    
    ),
    
    );
  }
}