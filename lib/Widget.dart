import 'package:flutter/material.dart';

class FirstBtn extends StatelessWidget{

  VoidCallback press;
  String text;
  Color color;
  FirstBtn({required this.text , required this.press , required this.color});

  Widget build(BuildContext context){
    return Column(
      children: [
        Material(
          elevation: 5,
          shape: StadiumBorder(),
          color: color,
          child: MaterialButton(
            elevation: 0,
            shape: StadiumBorder(),
            color: color,
            onPressed: press,
            child: Text(text, style: TextStyle(color: Colors.white , fontSize: 17 ),),
          ),
        ),
      ],
    );
  }
}


class SignBtn extends StatelessWidget{

  VoidCallback press;
  String text;
  Color color;

  SignBtn({required this.color , required this.text , required this.press});

  Widget build(BuildContext context){

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Material(
            shape: StadiumBorder(),
            color: color,
            elevation: 5,
            child: MaterialButton(
              child: Text(text , style: TextStyle(color: Colors.white , fontSize: 20),),
              onPressed: press,
            ),
          ),
        )
      ],
    );
  }
}