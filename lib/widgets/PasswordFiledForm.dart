import 'package:flutter/material.dart';

class PasswordFieldForm extends StatelessWidget {

  final String name;
  final bool visibility;
  final Function validator;
  final Function onChanged;
  final Function onTap;

  const PasswordFieldForm({Key? key, required this.visibility, required this.validator, required this.name, required this.onTap, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return    TextFormField(
      style: TextStyle(color: Colors.blueGrey),
      decoration: InputDecoration(
        hintText: name,
        suffixIconColor: Colors.blueGrey,
        enabledBorder : UnderlineInputBorder(
          borderSide: BorderSide(
              color: Colors.grey
          ),
        ),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blueGrey,
            )
        ),
        suffixIcon: GestureDetector(
          onTap: onTap(),
          child: visibility ? Icon(Icons.visibility_outlined, color: Colors.grey,) : Icon(Icons.visibility_off_outlined),
        ),
        hintStyle: TextStyle(color: Colors.blueGrey),
      ),
      obscureText: visibility,
      keyboardType: TextInputType.text,
      onChanged: onChanged(),
      validator: validator(),
    );
  }
}
