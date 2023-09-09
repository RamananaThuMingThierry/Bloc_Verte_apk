import 'dart:io';
import 'dart:async';
import 'package:bv/model/Portes.dart';
import 'package:bv/services/db.dart';
import 'package:bv/utils/loading.dart';
import 'package:bv/widgets/button.dart';
import 'package:bv/widgets/myTextFieldForm.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ModifierPortes extends StatefulWidget{

  Portes portes;
  ModifierPortes({required this.portes});

  @override
  State<StatefulWidget> createState() {
    return ModifierPortesState();
  }
}

class ModifierPortesState extends State<ModifierPortes>{

  Portes? data;
  String? image;
  String? nom;
  String? numero_porte;
  String? contact;
  bool? existe;
  String? image_update;
  File? imageFiles;
  File? selectedImage;
  CroppedFile? croppedImage;
  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    nom = widget.portes.nom;
    numero_porte = widget.portes.numero_porte;
    contact = widget.portes.contact;
    existe = widget.portes.image == null ? false : true;
    image_update = widget.portes.image;
    data = widget.portes;
    image = image_update;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text("Modifier une Porte"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Form(
              key: _key,
              child: Column(
                children: [
                  Card(
                    shape: Border(),
                    elevation: 1.0,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
                      child: Text("Informations", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline4),
                    ),
                  ),
                  Card(
                    shape: Border(),
                    elevation: 1.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        (existe == false)
                            ?  Image.asset("assets/no_image.jpg")
                            : (image_update != null)
                                ? Container(
                                  child:  CachedNetworkImage(
                                    imageUrl: image_update!,
                                    placeholder: (context, url) => CircularProgressIndicator(), // Widget de chargement affiché pendant le chargement de l'image
                                    errorWidget: (context, url, error) => Icon(Icons.error), // Widget d'erreur affiché si l'image ne peut pas être chargée
                                    ),
                                  )
                                : (croppedImage == null) ? Image.asset("assets/no_image.jpg") : Image.file(File(croppedImage!.path)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                onPressed: () => getImage(ImageSource.camera),
                                icon: Icon(Icons.camera_enhance, color: Colors.brown,)
                            ),
                            IconButton(
                                onPressed: (){
                                    if(existe == false){
                                      setState(() {
                                        existe = true;
                                      });
                                    }
                                    getImage(ImageSource.gallery);
                                  },
                                icon: Icon(Icons.photo_library, color: Colors.greenAccent,)
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child:MyTextFieldForm(
                              edit: true,
                              value: numero_porte! ?? "",
                              name: "Numéro porte",
                              onChanged: () => (value){
                                setState(() {
                                  numero_porte = value;
                                });
                              },
                              validator: () => (value){
                                if(value!.isEmpty){
                                  return "Veuillez saisir le numéro du porte!";
                                }else if(value.toString().length < 1 || value.toString().length > 11){
                                  return "Le numéro du porte doit-être compris entre 1 et 11!";
                                }
                              },
                              iconData: Icons.door_back_door_outlined,
                              textInputType: TextInputType.number),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child:MyTextFieldForm(
                              edit: true,
                              value: nom! ?? "",
                              name: "Nom",
                              onChanged: () => (value){
                                setState(() {
                                  nom = value;
                                });
                              },
                              validator: () => (value){
                                if(value!.isEmpty){
                                  return "Veuillez saisir votre nom!";
                                }
                              },
                              iconData: Icons.account_box,
                              textInputType: TextInputType.name
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 5.0, left: 5.0, bottom: 10.0),
                          child:
                          TextFormField(
                            initialValue: contact,
                            maxLength: 10,
                            onChanged: (value){
                              setState(() {
                                contact = value;
                              });
                            },
                            style: Theme.of(context).textTheme.headline6,
                            decoration: InputDecoration(
                              hintText: "Contact",
                              suffixIcon: Icon(Icons.phone),
                              hintStyle: Theme.of(context).textTheme.headline6,
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
                            validator: (value){
                              if(value!.isEmpty){
                                return "Veuillez saisir votre contact!";
                              }else if(value.length > 11){
                                return "Votre numéro doit être comporte par 10 chiffres!";
                              }
                            },
                            keyboardType: TextInputType.number,
                          )
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 160,
                                child: Button(onPressed: () => () => Navigator.pop(context), name: "Annuler", color: Colors.red),
                              ),
                              Container(
                                width: 160,
                                child: Button(onPressed: () => () => _modifier_porte(), name: "Valider", color: Colors.blue),
                              ),
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
        ),
      ),
    );
  }

  void _modifier_porte() async{
    final FormState _formkey = _key!.currentState!;
    if(_formkey.validate()){
      var numero_porte_existe = await DbServices().recupererNumeroPortes(numero_porte!);
      loading(context);
     // final identifiant = await DbServices().countPortes();
       if(numero_porte_existe != null){
         if(numero_porte_existe['numero_porte'] != data!.numero_porte){
           Navigator.pop(context);
           print("${numero_porte_existe['numero_porte']}  ${data!.numero_porte}");
           showAlertDialog(context, "Warning", "Ce numéro de porte existe déjà!");
         }
       }
      print("Nous sommes la!");
      data!.nom = nom;
      data!.numero_porte = numero_porte;
      data!.contact = contact;
      if(image != null){
        String? urlImages = await DbServices().uploadImage(File(image!), path: "portes");
        if(urlImages != null){
          data!.image = urlImages;
        }
      }else{
        data!.image = image_update;
      }
      bool editPortes = await DbServices().updatePortes(data!);
      if(editPortes == true){
        Navigator.pop(context);
        Navigator.pop(context);
        showAlertDialog(context, "Success", "Modification avec succès!");
      }else{
        showAlertDialog(context, "Warning", "Erreur de Modification!");
      }
    }else{
      print("Non");
    }
  }

  Future getImage(ImageSource source) async{
    final newImage = await ImagePicker().pickImage(source: source);
    if(newImage != null){
      final File image = File(newImage!.path);
      setState(() {
        image_update = null;
      });
      cropImage(image);
    }
  }

  Future cropImage(File imageR) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageR.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Recadrez l\'image',
            toolbarColor: Colors.green,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: Colors.green,
            hideBottomControls: false,
            cropGridColumnCount: 3,
            cropGridRowCount: 3,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    if (croppedFile != null) {
      print("******************************************************************************** ${croppedFile}");
      setState(() {
        croppedImage = croppedFile;
        image = croppedFile.path;
        imageFiles = File(croppedFile!.path);
      });
      print("******************************************************************************** ${croppedImage}");
    }
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