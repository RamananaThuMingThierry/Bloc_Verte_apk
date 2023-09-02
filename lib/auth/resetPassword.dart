import 'package:bv/widgets/button.dart';
import 'package:bv/widgets/myTextFieldForm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class resetPassword extends StatefulWidget {
  const resetPassword({Key? key}) : super(key: key);

  @override
  State<resetPassword> createState() => _resetPasswordState();
}

class _resetPasswordState extends State<resetPassword> {

  String? email;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  RegExp regExp = RegExp(r'''
(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$''');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text("Trano Maitso", style: GoogleFonts.cabin(color: Colors.white),),
        elevation: 1,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Form(
          key: _key,
          child: Column(
            children: [
                 Text("Entrez votre e-mail et nous vous enverrons un lien de réinitialisation de mot de passe", style: GoogleFonts.cabin(color: Colors.black87, fontSize: 20),),
              SizedBox(height: 20,),
              Row(
                children: [
                  Text("Entrer votre adresse e-mail", style: TextStyle(color: Colors.grey),)
                ],
              ),
              MyTextFieldForm(
                  edit: false,
                  value: "",
                  name: "",
                  onChanged: () => (value) => setState(() {
                    email = value;
                  }),
                  validator:() =>  (value){
                    if(value == ""){
                      return "Veuillez saisir votre adresse e-mail";
                    }else if(!regExp.hasMatch(value!)){
                      return "Votre adresse e-mail est invalide!";
                    }
                  },
                  iconData: Icons.mail,
                  textInputType: TextInputType.emailAddress
              ),
              SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 168,
                    child: Button(
                      onPressed: () => (){
                        Navigator.pop(context);
                        // Nagnano bouton
                      } , name: "Annuler",
                        color: Colors.grey,
                    ),
                  ),
                  Container(
                    width: 168,
                    child: Button(
                        onPressed: () => () => validation(),
                      name: "Modifiier",
                      color: Colors.blue,
                  ),
                  ),
                ]
              ),
            ],
          ),
        ),
      ),
    );
  }

  void validation() async{
    final FormState _formkey = _key!.currentState!;
    if(_formkey.validate()){
      try{
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email!.trim());
            showDialog(context: context, builder: (context){
              return AlertDialog(
                content: Text("Réinitialiser votre mot de passe grâce au lien que nous avons envoyé! Vérifiez votre e-mail."),
              );
            });
      } on FirebaseAuthException catch(e){
         showDialog(context: context, builder: (context){
           return AlertDialog(
             content: Text("Il n'y a aucun enregistrement d'utilisateur correspondant à cet identifiant. L'utilisateur a peut-être été supprimé.", style: GoogleFonts.cabin(color: Colors.black38),),
           );
         });
      }
    }else{
      print("Non");
    }
  }

}
