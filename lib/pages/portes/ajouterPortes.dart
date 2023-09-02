import 'dart:io';
import 'dart:async';
import 'package:bv/model/Portes.dart';
import 'package:bv/services/db.dart';
import 'package:bv/utils/loading.dart';
import 'package:bv/widgets/button.dart';
import 'package:bv/widgets/myTextFieldForm.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AjouterPortes extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return AjouterPortesState();
  }
}

class AjouterPortesState extends State<AjouterPortes>{

  String? image;
  String? nom;
  String? numero_porte;
  String? contact;
  File? images;
  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text("Ajouter une Porte"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _key,
          child: Column(
            children: [
              Card(
                elevation: 2.0,
                child: Container(
                  height: 50.0,
                  width: 340.0,
                  padding: EdgeInsets.only(top: 15.0),
                  child: Text("Informations", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 18.0),),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 2)),
              Card(
                elevation: 5.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    (image == null)
                        ? Image.asset("assets/no_image.jpg")
                        : Image.file(File(image!)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: () => getImage(ImageSource.camera),
                            icon: Icon(Icons.camera_enhance, color: Colors.brown,)
                        ),
                        IconButton(
                            onPressed: () => getImage(ImageSource.gallery),
                            icon: Icon(Icons.photo_library, color: Colors.greenAccent,)
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    Padding(
                        padding: EdgeInsets.only(right: 5.0, left: 5.0),
                        child:MyTextFieldForm(
                            edit: false,
                            value: "",
                            name: "Numéro porte",
                            onChanged: () => (value){
                              setState(() {
                                numero_porte = value;
                              });
                            },
                            validator: () => (value){
                              if(value!.isEmpty){
                                return "Veuillez entrer le numéro du porte!";
                              }else if(int.parse(value) < 1 || int.parse(value) > 11){
                                return "Le numéro du porte doit-être compris entre 1 et 11!";
                              }
                            },
                            iconData: Icons.door_back_door_outlined,
                            textInputType: TextInputType.number),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 5.0, left: 5.0),
                      child:MyTextFieldForm(
                          edit: false,
                          value: "",
                          name: "Nom",
                          onChanged: () => (value){
                            setState(() {
                              nom = value;
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
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 5.0, left: 5.0, bottom: 10.0),
                      child:MyTextFieldForm(
                          edit: false,
                          value: "",
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
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 160,
                            child: Button(
                              onPressed: () => () => Navigator.pop(context),
                              color: Colors.red,
                              name: "Annuler",
                            ),
                          ),
                          Container(
                            width: 160,
                            child: Button(
                              onPressed: () => () => _ajouter_porte(),
                              color: Colors.blue,
                              name: "Valider",
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _ajouter_porte() async{
    final FormState _formkey = _key!.currentState!;
    if(_formkey.validate()){
        loading(context);
        final identifiant = await DbServices().countPortes();
        Portes portes = Portes();
        portes.id = (identifiant == 0 ) ? "1" : "${identifiant + 1}";
        portes.nom = nom;
        portes.numero_porte = numero_porte;
        portes.contact = contact;
        if(image != null){
          String? urlImages = await DbServices().uploadImage(File(image!), path: "portes");
          if(urlImages != null){
            portes.image = urlImages;
          }
        }else{
          portes.image = null;
        }
        if(await DbServices().VerfierPortes(numero_porte!)){
          Navigator.pop(context);
          showAlertDialog(context, "Warning", "Ce numéro de porte existe déjà!");
        }else{
          bool savePortes = await DbServices().savePortes(portes);
          if(savePortes == true){
            Navigator.pop(context);
            Navigator.pop(context);
            showAlertDialog(context, "Success", "Sauvegarde avec succès!");
          }else{
            showAlertDialog(context, "Warning", "Erreur de sauvegarde!");
          }
        }
    }else{
      print("Non");
    }
  }

  Future getImage(ImageSource source) async{
    final newImage = await ImagePicker().pickImage(source: source);
    setState(() {
      image = newImage!.path;
      images = File(newImage!.path);
    });
  }

  TextField textField(TypeTextField type, String label){
    return TextField(
        decoration: InputDecoration(labelText: label),
        onChanged: (String str){
          switch(type){
            case TypeTextField.nom:
              nom = str;
              break;
            case TypeTextField.telephone:
              contact = str;
              break;
            case TypeTextField.porte:
              numero_porte = str;
              break;
          }
        }
    );
  }
}

enum TypeTextField {nom, telephone, porte}