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
    var width = MediaQuery.of(context).size.width;
    var heigth = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      key: _key,
      appBar: AppBar(
        elevation: 0,
        leading: edit == true
            ? Container()
            : IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back)),
        actions: [
          edit == false
              ? IconButton(onPressed: (){print("Nofications");}, icon: Icon(Icons.notifications_none))
              : Container(),
        ],
        backgroundColor: Colors.green,
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Card(
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
                      height: 150,
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
                                        String? urlImage = await DbServices().uploadImage(data ,path: "profile");
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
                Column(
                  children: [
                    edit == true
                      ? Container(
                        height: 530,
                        child: Form(
                          key: _keys,
                          child: Column(
                            children: [
                              SizedBox(height: 25,),
                              _TextTitre(name: "Pseudo"),
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
                                      return "Veuillez entrer votre nom!";
                                    }
                                  },
                                style: TextStyle(color: Colors.blueGrey),
                                onFieldSubmitted: (arg){},
                                decoration: InputDecoration(
                                  hintText: "${pseudo}",
                                  hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                                  prefixIcon: Icon(Icons.account_box_rounded, color: Colors.blueGrey, size: 20,),
                                ),
                                textInputAction: TextInputAction.search,
                                textAlignVertical: TextAlignVertical.center,
                                ),
                              SizedBox(height: 5,),
                              _TextTitre(name: "Email"),
                              TextFormField(
                                style: TextStyle(color: Colors.blueGrey),
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
                                      return "Veuillez entrer votre contact!";
                                    }else if(!regExp.hasMatch(value!)){
                                      return "Email invalide!";
                                    }
                                  },
                                initialValue: email,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              _TextTitre(name: "Genre"),
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
                                          dropdownColor: Colors.white,
                                          value: genre,
                                          items: [
                                            DropdownMenuItem(value: "Homme", child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Icon(Icons.man,color: Colors.blueGrey,size: 25,),
                                                Text("     Homme", style: TextStyle(color: Colors.blueGrey),),
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
                              _TextTitre(name: "Contact"),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                initialValue: "${contact ?? "Néant"}",
                                style: TextStyle(color: Colors.blueGrey),
                                onFieldSubmitted: (arg){},
                                decoration: InputDecoration(
                                  hintText: "${contact ?? "Néant"}",
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
                              SizedBox(height: 5,),
                              _TextTitre(name: "Adresse"),
                              TextFormField(
                                 initialValue: "${adresse ?? "Néant"}",
                                  style: TextStyle(color: Colors.blueGrey),
                                  onFieldSubmitted: (arg){},
                                  decoration: InputDecoration(
                                    hintText: "${adresse ?? "Néant"}",
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
                                      return "Veuillez entrer votre adresse";
                                    }
                                  },
                              ),
                              SizedBox(height: 5,),
                              _TextTitre(name: "Rôles"),
                              TextFormField(
                                enabled: false,
                                initialValue: "${roles}",
                                style: TextStyle(color: Colors.blueGrey),
                                onFieldSubmitted: (arg){},
                                decoration: InputDecoration(
                                  hintText: "${roles}",
                                  hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                                  prefixIcon: Icon( roles == "Administrateurs" ? Icons.key : Icons.key_off, color: Colors.blueGrey, size: 20,),
                                ),
                                textInputAction: TextInputAction.search,
                                textAlignVertical: TextAlignVertical.center,
                              ),
                              SizedBox(height: 35,),
                              Container(
                                width: double.infinity,
                                color: Colors.green,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(onPressed: (){
                                        setState(() {
                                          edit = !edit;
                                        });
                                        print("Anuller");
                                      },
                                        child:  RichText(text: TextSpan(
                                            children: [
                                              WidgetSpan(child: Icon(Icons.arrow_back, color: Colors.white, size: 18,)),
                                              TextSpan(text: "   Annuler", style: TextStyle(color: Colors.white)),
                                            ]
                                        ),
                                        ),),

                                      Text("|", style: style.copyWith(fontWeight: FontWeight.bold, color: Colors.white),),
                                      TextButton(onPressed: (){
                                        print("Modifier");
                                      },
                                        child:  RichText(text: TextSpan(
                                            children: [
                                              WidgetSpan(child: Icon(Icons.update, color: Colors.white, size: 18)),
                                              TextSpan(text: "   Modifier", style: style.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
                                            ]
                                        ),
                                        ),),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      :  Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Container(
                        height: 450,
                          child: Column(
                            children: [
                              _TextTitre(name: "Pseudo"),
                              _CardText(iconData: Icons.account_box_rounded, value: "${pseudo}"),
                              SizedBox(height: 5,),
                              _TextTitre(name: "Email"),
                              _CardText(iconData: Icons.mail, value: "${email}"),
                              SizedBox(height: 5,),
                              _TextTitre(name: "Genre"),
                              _CardText(iconData: Icons.person, value: "${genre ?? "Néant"}"),
                              SizedBox(height: 5,),
                              _TextTitre(name: "Contact"),
                              _CardText(iconData: Icons.phone, value: "${contact}"),
                              SizedBox(height: 5,),
                              _TextTitre(name: "Adresse"),
                              _CardText(iconData: Icons.local_library, value: "${adresse ?? "Néant"}"),
                              SizedBox(height: 5,),
                              _TextTitre(name: "Rôles"),
                              _CardText(iconData: roles == "Administrateurs" ? Icons.key : Icons.key_off , value: "${roles}"),
                              SizedBox(height: 5,),
                            ],
                          ),
                        ),
                      )
                  ],
                ),
                 Container(
                   width: 330,
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

  Padding _TextTitre({String? name}){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Text("${name}", style: style.copyWith(color: Colors.green, fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }

  Widget _CardText({IconData? iconData, String? value}){
    return TextFormField(
      enabled: false,
      style: TextStyle(color: Colors.blueGrey),
      onFieldSubmitted: (arg){},
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        hintText: "${value}",
        hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
        prefixIcon: Icon(iconData, color: Colors.blueGrey, size: 20,),
      ),
      textInputAction: TextInputAction.search,
      textAlignVertical: TextAlignVertical.center,
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
