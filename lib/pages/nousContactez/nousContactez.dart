import 'package:bv/model/Chat.dart';
import 'package:bv/services/db.dart';
import 'package:bv/utils/loading.dart';
import 'package:bv/widgets/button.dart';
import 'package:bv/widgets/myTextFieldForm.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class NousContactez extends StatefulWidget {
  const NousContactez({Key? key}) : super(key: key);

  @override
  State<NousContactez> createState() => _NousContactezState();
}

class _NousContactezState extends State<NousContactez> {
  // Déclarations des variables;
  String? nom;
  String? email;
  String? contact;
  String? message;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  RegExp regExp = RegExp(r'''
(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$''');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nous Contactez"),
        backgroundColor: Colors.green,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child:Form(
            key: _key,
            child: Container(
              child: Column(
                children: [
                  Container(
                    height: 350,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Pseudo
                        MyTextFieldForm(name: "Nom",
                            edit: false,
                            value: "",
                            onChanged: () => (value) => {
                              setState(() {
                                nom = value;
                              })
                            },
                            validator:() => (value){
                              if(value.isEmpty){
                                return "Veuillez remplir ce champs!";
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
                        TextFormField(
                          onChanged: (value){
                            setState(() {
                              message = value;
                            });
                          },
                          validator: (value){
                            if(value!.isEmpty){
                              return "Veuillez entrer votre message!";
                            }
                          },
                          style: TextStyle(color: Colors.blueGrey),
                          decoration: InputDecoration(
                            hintText: "Message",
                            suffixIcon: Icon(Icons.message_outlined),
                            hintStyle: TextStyle(color: Colors.blueGrey),
                            suffixIconColor: Colors.grey,
                            enabledBorder : UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green,
                              ),
                            ),
                          ),
                          maxLines: 4,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 5,),
                  //Button
                  Container(
                    width: 325,
                    child: Button(
                        color: Colors.green,
                        onPressed: () => validation,
                        name: "Envoyer"),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(child: Divider(color: Colors.green,thickness: 1,)),
                        Text(" Or ", style: GoogleFonts.roboto(color: Colors.blueGrey, fontSize: 15),),
                        Expanded(child: Divider(color: Colors.green,thickness: 1,)),
                      ],
                    ),
                  ),
                  SizedBox(height: 5,),
                  //Button
                  Container(
                    width: 325,
                    child: Button(
                        color: Colors.blueGrey,
                        onPressed: () => AppelezNous,
                        name: "Appellez-nous"),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }

  void validation() async{
    final FormState _formkey = _key!.currentState!;
    if(_formkey.validate()){
      loading(context);
      final identifiant = await DbServices().countChats();
      Chats chats = Chats();
      chats.id = (identifiant == 0 ) ? "1" : "${identifiant + 1}";
      chats.nom = nom;
      chats.email = email;
      chats.contact = contact;
      chats.message = message;
      chats.date = DateTime.now().toString();
      bool saveChat = await DbServices().saveChats(chats);
      if(saveChat == true){
        Navigator.pop(context);
        Navigator.pop(context);
        showAlertDialog(context, "Success", "Message envoyer avec succès!");
      }else{
        showAlertDialog(context, "Warning", "Erreur d'envoyer!");
      }
    }else{
      print("Non");
    }
  }

  void AppelezNous() async {
    final Uri url = Uri(
      scheme: 'tel',
      path: "+261 32 75 637 70"
    );
    if(await canLaunchUrl(url)){
      await launchUrl(url);
    }else{
      print("${url}");
    }
  }
}
