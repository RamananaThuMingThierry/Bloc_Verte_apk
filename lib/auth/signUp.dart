import 'package:bv/auth/signIn.dart';
import 'package:bv/services/authservices.dart';
import 'package:bv/utils/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/PasswordFiledForm.dart';
import '../widgets/button.dart';
import '../widgets/myTextFieldForm.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  // Déclarations des variables
  bool visibilite = true;

  AuthServices auth = AuthServices();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  RegExp regExp = RegExp(r'''
(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$''');

  String? email;
  String? pseudo;
  String? contact;
  String? mot_de_passe;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child:Form(
            key: _key,
            child: Container(
              child: Column(
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Inscription",
                          style: TextStyle(
                              fontSize: 50,
                              color: Colors.green,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            height: 2,
                            width: 100,
                            color: Colors.brown,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    height: 300,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Pseudo
                        MyTextFieldForm(name: "Pseudo",
                            edit: false,
                            value: "",
                            onChanged: () => (value) => {
                              setState(() {
                                pseudo = value;
                              })
                            },
                            validator:() => (value){
                              if(value == ""){
                                return "Veuillez remplir ce champs!";
                              }else if(value!.length < 6){
                                return "Pseudo doit avoir au moins 6 caractères!";
                              }
                            },
                            iconData: Icons.account_box,
                            textInputType: TextInputType.name),
                        // Email
                        MyTextFieldForm(
                             edit: false,
                            value: "",
                            name: "Adresse Email",
                            onChanged: () => (value) => {
                              setState(() {
                                email = value;
                              })
                            },
                            validator: () => (value){
                              if(value == ""){
                                return "Veuillez remplir ce champs!";
                              }else if(!regExp.hasMatch(value!)){
                                return "Email invalide!";
                              }
                            },
                            iconData: Icons.email,
                            textInputType: TextInputType.emailAddress),
                        // Contact
                        MyTextFieldForm(
                            edit: false,
                            value: "",
                            name: "Contact",
                            onChanged: () => (value) => {
                              setState(() {
                                contact = value;
                              })
                            },
                            validator: () => (value){
                              if(value == ""){
                                return "Veuillez remplir ce champs!";
                              }else if(value!.length != 10){
                                return "Votre numéro doit-être composé de 10 chiffres!";
                              }
                            },
                            iconData: Icons.phone,
                            textInputType: TextInputType.phone),
                        // Mot de passe
                        PasswordFieldForm(
                            visibility: visibilite,
                            validator: () => (value){
                              if(value == ""){
                                return "Veuillez remplir ce champs!";
                              }else if(value!.length < 8){
                                return "Le mot de passe doit avoir au moins 8 caractères!";
                              }
                            },
                            name: "Mot de passe",
                            onTap: () => (){
                              setState(() {
                                visibilite = !visibilite;
                              });
                              print("${visibilite}");
                            },
                            onChanged: () => (value) => {
                              setState(() {
                                mot_de_passe = value;
                              })
                            }),
                      ],
                    ),
                  ),

                  SizedBox(height: 20,),
                  //Button
                  Button(
                      color: Colors.green,
                      onPressed: () => validation,
                      name: "S'inscrire")
                ],
              ),
            ),
          )
      ),
      bottomNavigationBar: Container(
        height: 50,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("J'ai déjà un compte!", style: TextStyle(color: Colors.grey),),
              SizedBox(width: 5,),
              GestureDetector(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext ctx){
                    return Login1();
                  }));
                },
                child: Text("se connecte", style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),),
              )
            ]),
      ),
    );
  }


  void validation() async{
    final FormState _formkey = _key!.currentState!;
    if(_formkey.validate()){
       loading(context);
          print(email! + " " + mot_de_passe!);
          bool register = await auth.signup(email!, mot_de_passe!, pseudo!, contact!, "Utilisateurs");
          if(register != null){
            Navigator.of(context).pop();
            if(register){
              Navigator.pop(context);
            } else{
              showAlertDialog(context, "Warning","Ce compte existe déjà!");
            }
          }
         //
         // UserCredential result = await FirebaseAuth.
         // instance.
         //  createUserWithEmailAndPassword(email: email!, password: mot_de_passe!);
         // print("************************* "+ result.user!.uid);
      // }catch(e){
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Utilisateur exite déjà !",textAlign: TextAlign.center, ), duration: Duration(milliseconds: 1000),));
      // }
    }else{
      print("Non");
    }
  }
}
