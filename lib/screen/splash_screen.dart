import 'package:bv/services/authservices.dart';
import 'package:bv/services/statusAuth.dart';
import 'package:bv/utils/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';


class SplashScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen>{

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2)).then((value) => {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => Status()))
    });
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage("assets/b2.png"),
            width: 300,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(child: Divider(color: Colors.green,thickness: 1,)),
                Text(" Trano Maitso ", style: GoogleFonts.roboto(color: Colors.green, fontSize: 25, fontWeight: FontWeight.bold),),
                Expanded(child: Divider(color: Colors.green,thickness: 1,)),
              ],
            ),
          ),
          SizedBox(height: 30,),
          SpinKitThreeBounce(
            color: Colors.green,
            size: 30,
          ),
        ],
      ),
    ),
    );
  }
}