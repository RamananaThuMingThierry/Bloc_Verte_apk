import 'package:flutter/material.dart';

class Ligne extends StatelessWidget {
  Ligne({Key? key, required this.color}) : super(key: key);
  Color?  color;
  @override
  Widget build(BuildContext context) {
    return  Divider(
      color:  Colors.grey,
      thickness: 1,
    );
  }
}
