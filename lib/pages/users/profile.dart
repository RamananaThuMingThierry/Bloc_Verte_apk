import 'dart:io';

import 'package:bv/model/User.dart';
import 'package:bv/services/db.dart';
import 'package:bv/utils/constant.dart';
import 'package:bv/utils/loading.dart';
import 'package:bv/widgets/button.dart';
import 'package:bv/widgets/getImage.dart';
import 'package:bv/widgets/myTextFieldForm.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {

  UserM userM;
  Profile({required this.userM});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Déclartions des variables
  bool loading = false;
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
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      key: _key,
      appBar: AppBar(
        leading: edit == true
            ? IconButton(
          onPressed: (){
            setState(() {
              edit = !edit;
            });
          },
          icon: Icon(Icons.close, color: Colors.red,),
        )
            : IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back)),
        actions: [
          edit == false
              ? IconButton(onPressed: (){print("Nofications");}, icon: Icon(Icons.notifications_none))
              : IconButton(onPressed: () => modifierProfile(context),
                icon: Icon(Icons.check, color: Colors.white,)),
        ],
        backgroundColor: Colors.green,
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Card(
          shape:  Border(
            right: BorderSide(color: Colors.green, width: 2),
            left: BorderSide(color: Colors.green, width: 2),
           // left: BorderSide(color: Colors.green, width: 5),
          ),
          elevation: 0,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 175,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CircleAvatar(
                            maxRadius: 65,
                            backgroundColor: Colors.blueGrey,
                            backgroundImage: (image == null) ? Image.asset("assets/photo.png").image : Image.network(image!).image,
                            child: Stack(
                              children: [
                                if(loading)
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
                                        loading  = true;
                                        setState(() {
                                        });
                                        String? urlImage = await DbServices().uploadImage(data ,path: "profil");
                                        print(urlImage!);
                                        if(urlImage != null){
                                          UserM.current!.image = urlImage;
                                          print(urlImage);
                                          bool isupdate = await DbServices().updateUser(UserM.current!);
                                          if(isupdate){
                                            loading = false;
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
                Container(
                  height: 450,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        height: 450,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: edit == true
                        ? Form(
                          key: _keys,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              MyTextFieldForm(
                                  edit: true,
                                  value: "${pseudo}",
                                  name: "Nom",
                                  onChanged: () => (value){
                                    setState(() {
                                      pseudo = value;
                                    });
                                  },
                                  validator: () => (value){
                                    if(value!.isEmpty){
                                      return "Veuillez entrer votre nom!";
                                    }
                                  },
                                  iconData: Icons.account_box,
                                  textInputType: TextInputType.name
                                ),
                              SizedBox(height: 5,),
                              MyTextFieldForm(
                                  edit: true,
                                  value: "${email}",
                                  name: "Email",
                                  onChanged: () => (value){
                                    setState(() {
                                      email = value;
                                    });
                                  },
                                  validator: () => (value){
                                    if(value!.isEmpty){
                                      return "Veuillez entrer votre contact!";
                                    }else if(!regExp.hasMatch(value!)){
                                      return "Email invalide!";
                                    }
                                  },
                                  iconData: Icons.email,
                                  textInputType: TextInputType.emailAddress),
                              SizedBox(height: 5,),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 0,),
                                child: Card(
                                  elevation: 0.2,
                                  child: Container(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            borderRadius: BorderRadius.circular(5),
                                            hint: Text(" Genre                                                        "),
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
                                                  Icon(Icons.man,color: Colors.blueGrey,),
                                                  Text("Homme", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),),
                                                ],)
                                              ),
                                              DropdownMenuItem(value: "Femme", child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Icon(Icons.woman,color: Colors.pinkAccent,),
                                                  Text("Femme", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pinkAccent),),
                                                ],)
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),),
                              SizedBox(height: 5,),
                              MyTextFieldForm(
                                  edit: true,
                                  value: "${adresse ?? "Néant"}",
                                  name: "Adresse",
                                  onChanged: () => (value){
                                    setState(() {
                                      adresse = value;
                                    });
                                  },
                                  validator: () => (value){
                                    if(value!.isEmpty){
                                      return "Veuillez entrer votre adresse";
                                    }
                                  },
                                  iconData: Icons.location_on_outlined,
                                  textInputType: TextInputType.text),
                              SizedBox(height: 5,),
                              MyTextFieldForm(
                                  edit: true,
                                  value: "${contact}",
                                  name: "Contact",
                                  onChanged: () => (value){
                                    setState(() {
                                      contact = value;
                                    });
                                  },
                                  validator: () => (value){
                                    if(value!.isEmpty){
                                      return "Veuillez entrer votre contact!";
                                    }else if(int.parse(value) < 11){
                                      return "Votre numéro doit être comporte par 10 chiffres!";
                                    }
                                  },
                                  iconData: Icons.phone,
                                  textInputType: TextInputType.phone),
                              (roles == "Administrateurs") ? SizedBox(height: 5,): Container(),
                              (roles == "Administrateurs") ? Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 0,),
                                  child: Card(
                                    elevation: 0.2,
                                    child: Container(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              borderRadius: BorderRadius.circular(5),
                                              hint: Text(" Roles                                                        "),
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
                                                    Icon(Icons.key,color: Colors.blueGrey,),
                                                    Text("    Administrateurs", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),),
                                                  ],)
                                                ),
                                                DropdownMenuItem(value: "Utilisateurs", child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Icon(Icons.key_off,color: Colors.blueGrey,),
                                                    Text("    Utilisateurs", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),),
                                                  ],)
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),) : Container()
                            ],
                          ),
                        )
                        :  Column(
                          children: [
                            SizedBox(height: 20,),
                            _CardText(type: "Pseudo", value: "${pseudo}"),
                            SizedBox(height: 5,),
                            _CardText(type: "Email", value: "${email}"),
                            SizedBox(height: 5,),
                            _CardText(type: "Genre", value: "${genre ?? "Néant"}"),
                            SizedBox(height: 5,),
                            _CardText(type: "Adresse", value: "${adresse ?? "Néant"}"),
                            SizedBox(height: 5,),
                            _CardText(type: "Contact", value: "${contact ?? "Vide"}"),
                            SizedBox(height: 5,),
                            _CardText(type: "Rôles", value: "${roles ?? "Utilisateurs"}"),
                          ],
                        )
                      ),
                    ],
                  ),
                ),
                 Container(
                   width: 325,
                   child: edit == false
                       ? Button(
                      name: "Modifier",
                      onPressed: () => (){ setState(() {
                        edit = !edit;
                      }); print("Modifier profile!");},
                     color: Colors.green,
                    )
                       : Container()
                 ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _TextField({String? name, String? value}){
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        hintText: "${name}",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        )
      ),
    );
  }

  Widget _CardText({String? type, String? value}){
    return Card(
      elevation: 0.4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: 55,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${type}", style: TextStyle(color: Colors.grey)),
            Text("${value}", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }

  void modifierProfile(BuildContext context) async {
    final FormState _formkey = _keys!.currentState!;
    if(_formkey.validate()){
      if(genre == null){
        showAlertDialog(context, "Warning", "Veuillez séléctionner votre sexe!");
      }
      data!.pseudo = pseudo;
      data!.genre = genre;
      data!.email = email;
      data!.adresse = adresse;
      data!.contact = contact;
      // if(image != null){
      //   String? urlImages = await DbServices().uploadImage(File(image!), path: "users");
      //   if(urlImages != null){
      //     data!.image = urlImages;
      //   }
      // }else{
      //   data!.image = image_update;
      // }
      data!.image = null;
      //print("nous somme là : ${data!.pseudo}");
       bool editUsers = await DbServices().updateUser(data!);
      if(editUsers == true){
        Navigator.pop(context);
        showAlertDialog(context, "Success", "Modification avec succès!");
      }else{
        showAlertDialog(context, "Warning", "Erreur de Modification!");
      }
    }else{
      print("Non");
    }
  }
}
