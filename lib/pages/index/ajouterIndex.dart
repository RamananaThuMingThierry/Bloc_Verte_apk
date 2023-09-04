import 'package:bv/model/Index.dart';
import 'package:bv/services/db.dart';
import 'package:bv/utils/loading.dart';
import 'package:bv/widgets/button.dart';
import 'package:bv/widgets/ligne_horizontale.dart';
import 'package:bv/widgets/myTextFieldForm.dart';
import 'package:flutter/material.dart';

class AjouterIndex extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return AjouterIndexState();
  }
}

class AjouterIndexState extends State<AjouterIndex>{

  // Déclarations des variables
  String? nouvel_index;
  String? ancien_index;
  String? portes_id;
  String? mois_id;

  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter un Index"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(2.0),
        child: Form(
          key: _key,
          child: Column(
            children: [
              Card(
                shape: Border(bottom: BorderSide(color: Colors.green, width: 2)),
                elevation: 1.0,
                child: Container(
                  height: 50.0,
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 15.0),
                  child: Text("Informations", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline4,),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 1)),
              Card(
                elevation: 1.0,
                shape: Border(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Champs pour le mois
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: DropdownButton<String>(
                        value: mois_id,
                        underline: SizedBox(height: 0,),
                        hint: Container(
                          child: Text("Choisir le mois                                                  ", style: Theme.of(context).textTheme.headline5),
                        ),
                        icon: Container(
                          child: Icon(
                            Icons.arrow_drop_down,
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                        onChanged: (String? new_value){
                          setState(() {
                            mois_id = new_value;
                          });
                        },
                        items: <String>["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"]
                            .map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                              value: value,
                              child: Tooltip(message: value, child: Center(child: Text(value, style: Theme.of(context).textTheme.headline6,)),));
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Ligne(color: Colors.grey,)
                    ),
                    // Champs pour la porte
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: DropdownButton<String>(
                        value: portes_id,
                        underline: SizedBox(height: 0,),
                        hint: Container(
                          child: Text("Choisir le numéro de votre portes                 ",style: Theme.of(context).textTheme.headline5),
                        ),
                        icon: Container(
                          child: Icon(
                            Icons.arrow_drop_down,
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                        onChanged: (String? new_value){
                          setState(() {
                            portes_id = new_value;
                          });
                        },
                        items: <String>["1","2", "3", "4", "5", "6", "7", "8", "9", "10","11"]
                            .map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                              value: value,
                              child: Tooltip(message: value, child: Center(child: Text(value, style: Theme.of(context).textTheme.headline6,)),));
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 5.0, left: 5.0),
                      child: Ligne(color: Colors.grey,)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: MyTextFieldForm(
                        name: "Ancien Index",
                        textInputType: TextInputType.number,
                        onChanged: () => (value){ setState(() {
                          ancien_index = value;
                        });},
                        value: "",
                        edit: false,
                        validator: () => (value){
                          if(value.isEmpty){
                            return "Veuillez entrer l'ancien index";
                          }
                        }, iconData: Icons.note_alt_outlined,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: MyTextFieldForm(
                          name: "Nouvel Index",
                          onChanged: () => (value){
                            setState(() {
                              nouvel_index = value;
                            });
                          }, validator: () => (value){
                            if(value.isEmpty){
                              return "Veuillez entrer la nouvel index";
                            }
                      },
                          iconData: Icons.note_alt,
                          textInputType: TextInputType.number,
                          edit: false,
                          value: ""),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 160,
                            child: Button(
                                color: Colors.redAccent,
                                onPressed: () => () => Navigator.pop(context),
                                name: "Annuler"
                            ),
                          ),
                          Container(
                            width: 160,
                            child: Button(
                                color: Colors.blue,
                                onPressed: () => () => _ajouter_index(),
                                name : "Valider"
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _ajouter_index() async{
    final FormState _formkey = _key!.currentState!;
    if(_formkey.validate()){
      loading(context);
      if(mois_id == null){
        Navigator.pop(context);
        showAlertDialog(context, "Warning","Veuillez séléctionner le mois!");
      }else if(portes_id == null){
        Navigator.pop(context);
        showAlertDialog(context, "Warning","Veuillez séléctionner le numéro de porte!");
      }
      final identifiant = await DbServices().countIndex();
      Indexs index = Indexs();
      index.id = (identifiant == 0 ) ? "1" : "${identifiant + 1}";
      index.mois_id = mois_id;
      index.ancien_index = ancien_index;
      index.nouvel_index = nouvel_index;
      index.portes_id = portes_id;
      index.payer = false;
      bool saveIndex = await DbServices().saveIndex(index);
      if(saveIndex == true){
        Navigator.pop(context);
        Navigator.pop(context);
        showAlertDialog(context, "Success","Sauvegarde avec succès!");
      }else{
        showAlertDialog(context, "Danger","Erreur de sauvegarde!");
      }
    }else{
      print("Non");
    }
  }
}