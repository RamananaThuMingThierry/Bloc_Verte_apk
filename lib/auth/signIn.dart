import 'package:bv/auth/resetPassword.dart';
import 'package:bv/auth/signUp.dart';
import 'package:bv/services/authservices.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../utils/loading.dart';
import '../widgets/PasswordFiledForm.dart';
import '../widgets/button.dart';
import '../widgets/myTextFieldForm.dart';

class Login1 extends StatefulWidget {
  const Login1({Key? key}) : super(key: key);

  @override
  State<Login1> createState() => _LoginState();
}

class _LoginState extends State<Login1> {
  // Déclarations des variables
  AuthServices authServices = AuthServices();

  bool visibility = true;

  var connectionStatus;
  late InternetConnectionChecker connectionChecker;

  @override
  void initState() {
    super.initState();
    connectionChecker = InternetConnectionChecker();
    connectionChecker.onStatusChange.listen((status) {
      setState(() {
        connectionStatus = status.toString();
      });
      if (connectionStatus ==
          InternetConnectionStatus.disconnected.toString()) {
        Message(context);
      }
    });
  }

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String? email;
  String? mot_de_passe;

  RegExp regExp = RegExp(r'''
(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$''');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 300,
                      child: Image(image: AssetImage("assets/fond.png"),),
                    ),
                    Text("Trano Maitso", style: GoogleFonts.bebasNeue(fontSize: 52, fontWeight: FontWeight.bold, color: Colors.green),),
                    SizedBox(height: 25,),
                    MyTextFieldForm(
                        edit: false,
                        value: "",
                        name: "Email",
                        onChanged: () => (value) => setState(() {
                          email = value;
                        }),
                        validator:() =>  (value){
                          if(value == ""){
                            return "Veuillez saisir votre adresse e-mail!";
                          }else if(!regExp.hasMatch(value!)){
                            return "Votre adresse e-mail est invalide!";
                          }
                        },
                        iconData: Icons.mail,
                        textInputType: TextInputType.emailAddress
                    ),
                    SizedBox(height: 20,),
                    // Password
                    PasswordFieldForm(
                        visibility: visibility,
                        validator: () => (value){
                          if(value == ""){
                            return "Veuillez remplir ce champs";
                          }else if(value!.length < 8){
                            return "Votre mot de passe doit avoir au moins 8 caractères";
                          }
                        },
                        name: "Mot de passe",
                        onTap: () => (){
                          FocusScope.of(context).unfocus();
                          setState(() {
                            visibility = !visibility;
                          });
                          print("${visibility}");
                        },
                        onChanged: () => (value) => setState(() {
                          mot_de_passe = value;
                        })
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (ctx) => resetPassword()));
                          },
                          child: Text("Mot de passe oublie?", style: GoogleFonts.roboto(color: Colors.blue,),),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Container(
                      width: 350,
                      child: Button(
                          onPressed: () => validation,
                          name: "Se conntecter",
                          color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Je n'ai pas de compte!", style: TextStyle(color: Colors.grey),),
              SizedBox(width: 5,),
              GestureDetector(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext ctx){
                    return SignUp();
                  }));
                },
                child: Text("s'inscrire", style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),),
              ),
            ]),
      ),
    );
  }

  void validation() async{
    final FormState _formkey = _key!.currentState!;
    if(_formkey.validate()){
      if (connectionStatus ==
          InternetConnectionStatus.disconnected
              .toString()) {
        Message(context);
      }else{
        loading(context);
        bool login = await authServices.signin(email!, mot_de_passe!);
        if (!login) {
          Navigator.pop(context);
          showMessage(
              context,
              titre: "Erreur",
              message: "email ou mot de passe incorrect!",
              ok: () {
                Navigator.pop(context);
              }
          );
        } else {
          Navigator.pop(context);
          print("Vous êtes connecter");
        }
      }
    }else{
      print("Non");
    }
  }
}
