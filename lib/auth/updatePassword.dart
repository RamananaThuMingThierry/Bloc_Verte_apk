import 'package:bv/services/authservices.dart';
import 'package:bv/utils/functions.dart';
import 'package:bv/utils/loading.dart';
import 'package:bv/widgets/PasswordFiledForm.dart';
import 'package:bv/widgets/myTextFieldForm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class updatePassword extends StatefulWidget {
  const updatePassword({Key? key}) : super(key: key);

  @override
  State<updatePassword> createState() => _updatePasswordState();
}

class _updatePasswordState extends State<updatePassword> {

  AuthServices auth = AuthServices();

  // Déclarations des variables
  bool a_visibility = true;
  bool r_visibility = true;
  bool c_visibility = true;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  String? ancien_password, recent_password, new_password;
  bool verificationPasswordValid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text("Trano Maitso", style: TextStyle(color: Colors.white),),
        elevation: 1,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Form(
          key: _key,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Changer votre mot de passe", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),),
                ],
              ),
              SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(color: Colors.black,height: 2,width: 120,),
                ],
              ),
              SizedBox(height: 30,),
              Row(
                children: [
                  Text("Ancien mot de passe",style: TextStyle(color: Colors.grey),),
                ],
              ),
              PasswordFieldForm(
                  visibility: a_visibility,
                  validator: () => (value){
                    if(value.isEmpty){
                      return "Veuillez saisir votre ancien mot de passe";
                    }else if(value!.length < 8){
                      return "Votre mot de passe doit avoir au moins 8 caractères";
                    }
                  },
                  name: "",
                  onTap: () => (){
                    FocusScope.of(context).unfocus();
                    setState(() {
                      a_visibility = !a_visibility;
                    });
                  },
                  onChanged: () => (value) => setState(() {
                    ancien_password = value;
                  })
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Text("Nouveau mot de passe",style: TextStyle(color: Colors.grey),),
                ],
              ),
              PasswordFieldForm(
                  visibility: r_visibility,
                  validator: () => (value){
                    if(value == ""){
                      return "Veuillez saisir votre nouveau mot de passe";
                    }else if(value!.length < 8){
                      return "Votre mot de passe doit avoir au moins 8 caractères";
                    }
                  },
                  name: "",
                  onTap: () => (){
                    FocusScope.of(context).unfocus();
                    setState(() {
                      r_visibility = !r_visibility;
                    });
                  },
                  onChanged: () => (value){
                    setState(() {
                      recent_password = value;
                    });
                  }
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Text("Confirmer votre mot de passe",style: TextStyle(color: Colors.grey),),
                ],
              ),
              PasswordFieldForm(
                  visibility: c_visibility,
                  validator: () => (value){
                    if(value == ""){
                      return "Veuillez confirmer votre mot de passe";
                    }else if(value!.length < 8){
                      return "Votre mot de passe doit avoir au moins 8 caractères";
                    }else if(value != recent_password){
                      return "Votre mot de passe doit-être identique!";
                    }
                  },
                  name: "",
                  onTap: () => (){
                    FocusScope.of(context).unfocus();
                    setState(() {
                      c_visibility = !c_visibility;
                    });
                  },
                  onChanged: () => (value){

                    setState(() {
                      new_password = value;
                    });
                  }
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 165,
                    child: MaterialButton(
                      shape: Border(),
                      onPressed: (){
                      Navigator.pop(context);
                      // Nagnano bouton
                    } , child: Text("Annuler", style: TextStyle(fontWeight: FontWeight.bold),),color: Colors.grey,),
                  ),
                  Container(
                      width: 165,
                      child: MaterialButton(
                        shape: Border(),
                        onPressed: () async {
                          final FormState _formkey = _key!.currentState!;
                          if(_formkey.validate()){
                            loading(context);
                            print(FirebaseAuth.instance.currentUser!.email);
                            if(await auth.validationPassword(ancien_password!)){
                              await auth.updatePassword(FirebaseAuth.instance.currentUser!.email!, new_password!);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              showAlertDialog(context,"Success","Votre mot de passe a été bien modifier!");
                            }else{
                              Navigator.pop(context);
                              badPassword(context);
                            }
                          }else{
                            print("Non");
                          }
                      } , child: Text("Modifier", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),color: Colors.blue,)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}
