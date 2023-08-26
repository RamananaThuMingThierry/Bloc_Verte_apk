import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  Button({required this.onPressed, required this.name, required this.color});

  // Déclarations des variables
  final Function onPressed;
  final String name;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: color,
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Text(name, style: TextStyle(color: Colors.white,fontSize: 15),),
      onPressed: onPressed(),
    );
  }
}
