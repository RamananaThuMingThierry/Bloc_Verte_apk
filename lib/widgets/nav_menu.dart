import 'package:flutter/material.dart';

class navMenu extends StatelessWidget {
  const navMenu({Key? key, required this.name, required this.onTap, required this.iconData}) : super(key: key);
  final String name;
  final IconData iconData;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(iconData, color:Theme.of(context).primaryColor),
      title: Text("${name}",style: Theme.of(context).textTheme.headline6),
      onTap: onTap(),
    );
  }
}
