import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class BlocVerteTheme extends ChangeNotifier{

  ThemeData _theme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.green,
    primaryColorDark: Colors.blueGrey,
    primarySwatch: Colors.green,
    backgroundColor: Colors.grey[300],
    fontFamily: 'Roboto',
    cardColor: Colors.white,
    textTheme: TextTheme(
      headline5: TextStyle(
          fontSize: 15,
          color: Colors.blueGrey,
          fontWeight: FontWeight.bold
      ),
      headline6: TextStyle(
        fontSize: 15,
        color: Colors.blueGrey,
      ),
    ),
  );

  ThemeData get theme => _theme;

  bool? isDark = false;

  void toggleTheme(){
    if(isDark == true){
      _theme = ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.green,
        primaryColorDark: Colors.blueGrey,
        primarySwatch: Colors.green,
        primaryColorLight: Colors.white,
        backgroundColor: Colors.grey[300],
        fontFamily: 'Roboto',
        cardColor: Colors.white,
        textTheme: TextTheme(
          headline4: TextStyle(
              fontSize: 18,
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold
          ),
          headline5: TextStyle(
            fontSize: 15,
            color: Colors.blueGrey,
            fontWeight: FontWeight.bold
          ),
          headline6: TextStyle(
            fontSize: 15,
            color: Colors.blueGrey,
          ),
        ),
      );
      print("Mazava");
      isDark = false;
    }else{
      _theme = ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        primaryColor: Colors.green,
        primaryColorDark: Colors.white,
        primaryColorLight: Colors.blueGrey,
        accentColor: Colors.green,
        backgroundColor: Colors.grey[300],
        cardColor: Colors.blueGrey,
        textTheme: TextTheme(
          headline4: TextStyle(
              fontSize: 18,
              fontFamily: 'Roboto',
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
          headline5: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
          headline6: TextStyle(
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      );
      isDark = true;
      print("Mahizigny");
    }
    notifyListeners();
  }
}