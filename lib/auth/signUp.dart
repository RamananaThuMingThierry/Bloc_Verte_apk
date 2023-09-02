import 'package:bv/auth/signIn.dart';
import 'package:bv/services/authservices.dart';
import 'package:bv/utils/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _key,
                child: Column(
                  children: [
                    Image(image: AssetImage("assets/fond.png"), width: 200),
                    Text("Trano Maitso", style: GoogleFonts.bebasNeue(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.green),),
                    SizedBox(height: 10,),
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
                            return "Veuillez saisir votre pseudo!";
                          }else if(value!.length < 6){
                            return "Votre pseudo doit avoir au moins 6 caractères!";
                          }
                        },
                        iconData: Icons.account_box,
                        textInputType: TextInputType.name),
                    SizedBox(height: 10,),
                    // Email
                    MyTextFieldForm(
                        edit: false,
                        value: "",
                        name: "Adresse e-mail",
                        onChanged: () => (value) => {
                          setState(() {
                            email = value;
                          })
                        },
                        validator: () => (value){
                          if(value == ""){
                            return "Veuillez saisir votre adresse e-mail!";
                          }else if(!regExp.hasMatch(value!)){
                            return "Votre adresse e-mail est invalide!";
                          }
                        },
                        iconData: Icons.email,
                        textInputType: TextInputType.emailAddress),
                    SizedBox(height: 10,),
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
                            return "Veuillez saisir votre contact!";
                          }else if(value!.length != 10){
                            return "Votre numéro doit-être composé de 10 chiffres!";
                          }
                        },
                        iconData: Icons.phone,
                        textInputType: TextInputType.phone),
                    SizedBox(height: 10,),
                    // Mot de passe
                    PasswordFieldForm(
                        visibility: visibilite,
                        validator: () => (value){
                          if(value == ""){
                            return "Veuillez saisir votre mot de passe!";
                          }else if(value!.length < 8){
                            return "Votre mot de passe doit avoir au moins 8 caractères!";
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
                    SizedBox(height: 20,),
                    //Button
                    Container(
                      width: 350,
                      child: Button(
                          color: Colors.green,
                          onPressed: () => validation,
                          name: "S'inscrire"),
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
              Text("J'ai déjà un compte!", style: TextStyle(color: Colors.grey),),
              SizedBox(width: 5,),
              GestureDetector(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext ctx){
                    return Login1();
                  }));
                },
                child: Text("se connecter", style: TextStyle(
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
            Navigator.pop(context);
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
