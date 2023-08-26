import 'package:flutter/material.dart';

class navMenu extends StatelessWidget {
  const navMenu({Key? key, required this.name, required this.onTap, required this.iconData}) : super(key: key);
  final String name;
  final IconData iconData;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(iconData, color:  Colors.green,),
      title: Text("${name}",style: TextStyle(color: Colors.blueGrey),),
      onTap: onTap(),
    );
  }
}
