import 'package:bv/auth/signIn.dart';
import 'package:bv/pages/HomePage.dart';
import 'package:bv/screen/splash_screen.dart';
import 'package:bv/services/authservices.dart';
import 'package:bv/widgets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Status extends StatefulWidget{
  @override
  StatusState createState() {
    return StatusState();
  }

}

class StatusState extends State<Status>{
// Déclaration des variables
  User? user;
  AuthServices auth = AuthServices();

  Future<void> getUser() async {
    final userResult = await auth.user;
    setState(() {
      user = userResult;
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
            ],
          ),);
        }else{
          if(snapshot.hasData){
            return HomePage();
          }else{
            return Login1();
          }
        }
      });
  }
}