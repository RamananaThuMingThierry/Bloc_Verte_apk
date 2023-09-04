import 'dart:io';

import 'package:bv/model/User.dart';
import 'package:bv/pages/HomePage.dart';
import 'package:bv/services/db.dart';
import 'package:bv/utils/functions.dart';
import 'package:bv/utils/loading.dart';
import 'package:bv/widgets/button.dart';
import 'package:bv/widgets/donnees_vide.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../widgets/getImage.dart';

class ModifierUsers extends StatefulWidget {
  UserM? userM;
  ModifierUsers({required this.userM});

  @override
  State<ModifierUsers> createState() => _ModifierUsersState();
}

class _ModifierUsersState extends State<ModifierUsers> {

  // Déclarations des variables
  UserM? data;
  bool onloading = false;
  String? pseudo, image, contact, email, adresse, roles, genre, image_update;
  String? urlImage;

  RegExp regExp = RegExp(r'''
(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$''');

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    data = widget.userM;
    pseudo = data!.pseudo;
    image = data!.image;
    contact = data!.contact;
    email = data!.email;
    adresse = data!.adresse;
    roles = data!.roles;
    genre = data!.genre;
    image_update = image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text("Modifier un utilisateur"),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Form(
              key: _key,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 150,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            (image == null) ?
                                CircleAvatar(
                                  maxRadius: 65,
                                  backgroundImage: Image.asset("assets/photo.png").image,
                                  child: Stack(
                                    children: [
                                      if(onloading)
                                        Center(
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                          ),
                                        ),
                                      Positioned(
                                        top: 80,
                                        left: 85,
                                        child: IconButton(
                                          onPressed: () async{
                                            final data = await
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (ctx){
                                                  return GetImage();
                                                });
                                            if(data != null){
                                              onloading  = true;
                                              setState(() {
                                              });
                                              urlImage = await DbServices().uploadImage(data ,path: "profile");
                                              print(urlImage!);
                                              if(urlImage != null){
                                                widget.userM!.image = urlImage;
                                                bool isupdate = await DbServices().updateUser(widget.userM!);
                                                if(isupdate){
                                                  onloading = false;
                                                  setState(() {
                                                    image = widget!.userM!.image;
                                                  });
                                                }
                                              }
                                            }
                                          },
                                          icon: Icon(Icons.camera_alt, color: Colors.green,size: 35,),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                :
                            CircleAvatar(
                              maxRadius: 65,
                              backgroundColor: Colors.blueGrey,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: CachedNetworkImage(
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                      imageUrl: image!,
                                      placeholder: (context, url) => CircularProgressIndicator(), // Widget de chargement affiché pendant le chargement de l'image
                                      errorWidget: (context, url, error) => Icon(Icons.error), // Widget d'erreur affiché si l'image ne peut pas être chargée
                                    ),
                                  ),
                                  if(onloading)
                                    Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                      ),
                                    ),
                                    Positioned(
                                      top: 80,
                                      left: 85,
                                      child: IconButton(
                                        onPressed: () async{
                                          final data = await
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (ctx){
                                                return GetImage();
                                              });
                                          if(data != null){
                                            onloading  = true;
                                            setState(() {
                                            });
                                            urlImage = await DbServices().uploadImage(data ,path: "profile");
                                            print(urlImage!);
                                            if(urlImage != null){
                                              widget.userM!.image = urlImage;
                                              bool isupdate = await DbServices().updateUser(widget.userM!);
                                              if(isupdate){
                                                onloading = false;
                                                setState(() {
                                                  image = widget!.userM!.image;
                                                });
                                              }
                                            }
                                          }
                                        },
                                        icon: Icon(Icons.camera_alt, color: Colors.green,size: 35,),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  TextTitre(name: "Pseudo"),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    initialValue: pseudo,
                    onChanged:(value){
                      setState(() {
                        pseudo = value;
                      });
                    },
                    validator:(value){
                      if(value!.isEmpty){
                        return "Veuillez saisir votre pseudo!";
                      }
                    },
                    style: TextStyle(color: Theme.of(context).primaryColorDark),
                    onFieldSubmitted: (arg){},
                    decoration: InputDecoration(
                      hintText: "${pseudo}",
                      hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                      prefixIcon: Icon(Icons.account_box_rounded, color: Colors.blueGrey, size: 20,),
                    ),
                    textInputAction: TextInputAction.search,
                    textAlignVertical: TextAlignVertical.center,
                  ),
                  SizedBox(height: 10,),
                  TextTitre(name: "Email"),
                  TextFormField(
                    style: TextStyle(color: Theme.of(context).primaryColorDark),
                    onFieldSubmitted: (arg){},
                    decoration: InputDecoration(
                      hintText: "${email}",
                      hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                      prefixIcon: Icon(Icons.mail, color: Colors.blueGrey, size: 20,),
                    ),
                    textInputAction: TextInputAction.search,
                    textAlignVertical: TextAlignVertical.center,
                    onChanged:(value){
                      setState(() {
                        email = value;
                      });
                    },
                    validator:(value){
                      if(value!.isEmpty){
                        return "Veuillez saisir votre adresse e-mail!";
                      }else if(!regExp.hasMatch(value!)){
                        return "Votre adresse e-mail est invalide!";
                      }
                    },
                    initialValue: email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 10,),
                  TextTitre(name: "Genre"),
                  Card(
                    elevation: 0,
                    shape: Border(bottom: BorderSide(width: 1, color: Colors.grey)),
                    child: Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DropdownButtonHideUnderline(
                            child: DropdownButton(
                              borderRadius: BorderRadius.circular(5),
                              hint: Text(" Genre                                                                ", style: TextStyle(color: Colors.blueGrey),),
                              onChanged: (String? value){
                                setState(() {
                                  genre = value;
                                });
                              },
                              value: genre,
                              items: [
                                DropdownMenuItem(value: "Homme", child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.man,color: Colors.blueGrey,size: 25,),
                                    Text("     Homme", style: TextStyle(color: Theme.of(context).primaryColorDark),),
                                  ],)
                                ),
                                DropdownMenuItem(value: "Femme", child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.woman,color: Colors.pinkAccent,),
                                    Text("     Femme", style: TextStyle(color: Theme.of(context).primaryColorDark),),
                                  ],)
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextTitre(name: "Contact"),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: "${contact ?? "Aucun"}",
                    style: TextStyle(color: Theme.of(context).primaryColorDark),
                    onFieldSubmitted: (arg){},
                    decoration: InputDecoration(
                      hintText: "${contact ?? "Aucun"}",
                      hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                      prefixIcon: Icon(Icons.phone, color: Colors.blueGrey, size: 20,),
                    ),
                    textInputAction: TextInputAction.search,
                    textAlignVertical: TextAlignVertical.center,
                    onChanged:(value){
                      setState(() {
                        contact = value;
                      });
                    },
                    validator:(value){
                      if(value!.isEmpty){
                        return "Veuillez saisir votre contact";
                      }
                    },
                  ),
                  SizedBox(height: 10,),
                  TextTitre(name: "Adresse"),
                  TextFormField(
                    initialValue: "${adresse ?? ""}",
                    style: TextStyle(color: Theme.of(context).primaryColorDark),
                    onFieldSubmitted: (arg){},
                    decoration: InputDecoration(
                      hintText: "${adresse ?? ""}",
                      hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                      prefixIcon: Icon(Icons.location_on_outlined, color: Colors.blueGrey, size: 20,),
                    ),
                    textInputAction: TextInputAction.search,
                    textAlignVertical: TextAlignVertical.center,
                    onChanged:(value){
                      setState(() {
                        adresse = value;
                      });
                    },
                    validator:(value){
                      if(value!.isEmpty){
                        return "Veuillez saisir votre adresse e-mail";
                      }
                    },
                  ),
                  SizedBox(height: 10,),
                  TextTitre(name: "Rôles"),
                  Card(
                    elevation: 0,
                    shape: Border(bottom: BorderSide(width: 1, color: Colors.grey)),
                    child: Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DropdownButtonHideUnderline(
                            child: DropdownButton(
                              borderRadius: BorderRadius.circular(5),
                              hint: Text(" Rôles                                                                     ", style: TextStyle(color: Theme.of(context).primaryColorDark),),
                              onChanged: (String? value){
                                setState(() {
                                  roles = value;
                                });
                              },
                              value: roles,
                              items: [
                                DropdownMenuItem(value: "Administrateurs", child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.key,color: Colors.blueGrey,size: 25,),
                                    Text("     Administrateurs", style: TextStyle(color: Theme.of(context).primaryColorDark),),
                                  ],)
                                ),
                                DropdownMenuItem(value: "Utilisateurs", child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.key_off,color: Colors.blueGrey,),
                                    Text("     Utilisateurs", style: TextStyle(color: Theme.of(context).primaryColorDark),),
                                  ],)
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 350,
                    child: Button(onPressed: () => () => modifierProfile(context), name: "Modifier", color: Colors.green),
                  ),
                ],
              ),
            ),
            ),
          ),
        ),
      ),
    );
  }

  void modifierProfile(BuildContext context) async {
    final FormState _formkey = _key!.currentState!;
    if(_formkey.validate()){
      loading(context);
      if(genre == null){
        showAlertDialog(context, "Warning", "Veuillez séléctionner votre sexe!");
      }
      data!.pseudo = pseudo;
      data!.genre = genre;
      data!.email = email;
      data!.adresse = adresse;
      data!.contact = contact;
      data!.roles = roles;
      bool editUsers = await DbServices().updateUser(data!);
      if(editUsers == true){
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (ctx) => HomePage()));
        showAlertDialog(context, "Success", "Modification avec succès!");
      }else{
        Navigator.pop(context);
        showAlertDialog(context, "Erreur", "Erreur de Modification!");
      }
    }else{
      print("Non");
    }
  }
}
