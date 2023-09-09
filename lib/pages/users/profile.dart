import 'dart:io';

import 'package:bv/model/User.dart';
import 'package:bv/services/db.dart';
import 'package:bv/utils/constant.dart';
import 'package:bv/utils/functions.dart';
import 'package:bv/utils/loading.dart';
import 'package:bv/widgets/button.dart';
import 'package:bv/widgets/getImage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {

  UserM userM;
  Profile({required this.userM});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Déclartions des variables
  bool onloading = false;
  UserM? data;
  bool edit = false;
  String? genre;
  String? pseudo;
  String? email;
  String? adresse;
  String? contact;
  String? image;
  String? image_update;
  String? roles;
  String? urlImage;

  final picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = widget.userM;
    pseudo = widget.userM.pseudo;
    email = widget.userM.email;
    adresse = widget.userM.adresse;
    contact = widget.userM.contact;
    image = widget.userM.image;
    image_update = image;
    genre = widget.userM.genre;
    roles = widget.userM.roles;
  }

  final _keys = GlobalKey<FormState>();
  RegExp regExp = RegExp(r'''
(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$''');
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _key,
      appBar: AppBar(
        elevation: 1,
        leading: edit == true
            ?  IconButton(onPressed: (){ setState(() {
              edit = !edit;
            });}, icon: Icon(Icons.close))
            : IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back)),
        actions: [
          edit == false
              ? IconButton(onPressed: (){
                setState(() {
                  edit = !edit;
                });
          }, icon: Icon(Icons.edit))
              : Container(),
        ],
        backgroundColor: Colors.green,
        title: Text("${edit == false ? "Profile": "Modifier le profile"}"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 150,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CircleAvatar(
                              maxRadius: 65,
                              backgroundColor: Colors.blueGrey,
                              child:
                              Stack(
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
                                  if(edit == true)
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
                                          if(urlImage != null){
                                            UserM.current!.image = urlImage;
                                            bool isupdate = await DbServices().updateUser(UserM.current!);
                                            if(isupdate){
                                              onloading = false;
                                              setState(() {
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
                  Column(
                    children: [
                      edit == true
                        ? Container(
                          child: Form(
                            key: _keys,
                            child: Column(
                              children: [
                                SizedBox(height: 20,),
                                TextTitre(name: "Pseudo"),
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                    initialValue: "Pseudo",
                                    onChanged:(value){
                                      setState(() {
                                        pseudo = value;
                                      });
                                    },
                                    validator:(value){
                                      if(value!.isEmpty){
                                        return "Veuillez saisir votre nom!";
                                      }
                                    },
                                  style: Theme.of(context).textTheme.headline6,
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
                                  style: Theme.of(context).textTheme.headline6,
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
                                  color: Theme.of(context).backgroundColor,
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
                                            hint: Text(" Genre                                                                ", style: Theme.of(context).textTheme.headline6),
                                            onChanged: (String? value){
                                              setState(() {
                                                genre = value;
                                              });
                                            },
                                            dropdownColor: Colors.white,
                                            value: genre,
                                            items: [
                                              DropdownMenuItem(value: "Homme", child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Icon(Icons.man,color: Colors.blueGrey,size: 25,),
                                                  Text("     Homme", style: TextStyle(color: Colors.blueGrey)),
                                                ],)
                                              ),
                                              DropdownMenuItem(value: "Femme", child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Icon(Icons.woman,color: Colors.pinkAccent,),
                                                  Text("     Femme", style: TextStyle(color: Colors.pinkAccent),),
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
                                  style: Theme.of(context).textTheme.headline6,
                                  onFieldSubmitted: (arg){},
                                  decoration: InputDecoration(
                                    hintText: "${contact ?? "Aucun"}",
                                    hintStyle: Theme.of(context).textTheme.headline6,
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
                                   initialValue: "${adresse ?? "Aucun"}",
                                    style: Theme.of(context).textTheme.headline6,
                                    onFieldSubmitted: (arg){},
                                    decoration: InputDecoration(
                                      hintText: "${adresse ?? "Aucun"}",
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
                                TextFormField(
                                  enabled: false,
                                  initialValue: "${roles}",
                                  style: Theme.of(context).textTheme.headline6,
                                  onFieldSubmitted: (arg){},
                                  decoration: InputDecoration(
                                    hintText: "${roles}",
                                    hintStyle: Theme.of(context).textTheme.headline6,
                                    prefixIcon: Icon( roles == "Administrateurs" ? Icons.key : Icons.key_off, color: Colors.blueGrey, size: 20,),
                                  ),
                                  textInputAction: TextInputAction.search,
                                  textAlignVertical: TextAlignVertical.center,
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  width: 350,
                                  child: Button(onPressed: () => () =>   modifierProfile(context), name: "Modifier", color: Colors.blue),
                                ),
                              ],
                            ),
                          ),
                        )
                        :  Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Container(
                            child: Column(
                              children: [
                                TextTitre(name: "Pseudo"),
                                CardText(context, iconData: Icons.account_box_rounded, value: "${pseudo}"),
                                SizedBox(height: 10,),
                                TextTitre(name: "Email"),
                                CardText(context, iconData: Icons.mail, value: "${email}"),
                                SizedBox(height: 10,),
                                TextTitre(name: "Genre"),
                                CardText(context,iconData: Icons.person, value: "${genre ?? "Néant"}"),
                                SizedBox(height: 10,),
                                TextTitre(name: "Contact"),
                                CardText(context,iconData: Icons.phone, value: "${contact}"),
                                SizedBox(height: 10,),
                                TextTitre(name: "Adresse"),
                                CardText(context,iconData: Icons.local_library, value: "${adresse ?? "Néant"}"),
                                SizedBox(height: 10,),
                                TextTitre(name: "Rôles"),
                                CardText(context,iconData: roles == "Administrateurs" ? Icons.key : Icons.key_off , value: "${roles}"),
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void modifierProfile(BuildContext context) async {
    final FormState _formkey = _keys!.currentState!;
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
      if(urlImage == null){
        data!.image = image_update;
      }
      bool editUsers = await DbServices().updateUser(data!);
      if(editUsers == true){
        Navigator.pop(context);
        showAlertDialog(context, "Success", "Modification avec succès!");
      }else{
        showAlertDialog(context, "Erreur", "Erreur de Modification!");
      }
    }else{
      print("Non");
    }
  }
}
