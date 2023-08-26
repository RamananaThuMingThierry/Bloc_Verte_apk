import 'package:bv/model/Index.dart';
import 'package:bv/services/db.dart';
import 'package:bv/utils/loading.dart';
import 'package:bv/widgets/button.dart';
import 'package:bv/widgets/ligne_horizontale.dart';
import 'package:bv/widgets/myTextFieldForm.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModifierIndex extends StatefulWidget {
  Indexs indexs;
  ModifierIndex({required this.indexs});

  @override
  State<ModifierIndex> createState() => _ModifierIndexState();
}

class _ModifierIndexState extends State<ModifierIndex> {
  Indexs? data;
  String? _mois, _portes, _depart, _fin;
  @override
  void initState() {
    super.initState();
    data = widget.indexs;
    _mois = widget.indexs.mois_id;
    _portes = widget.indexs.portes_id;
    _depart = widget.indexs.ancien_index;
    _fin = widget.indexs.nouvel_index;
  }

  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modifier un Index"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(2.0),
        child: Form(
          key: _key,
          child: Column(
            children: [
              Card(
                shape: Border(bottom: BorderSide(color: Colors.green, width: 3)),
                elevation: 3.0,
                child: Container(
                  height: 50.0,
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 15.0),
                  child: Text("Informations", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 18.0),),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 1)),
              Card(
                elevation: 3.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        children: [
                          Expanded(child: Divider(color: Colors.green,thickness: 1,)),
                          Text(" Mois ", style: GoogleFonts.roboto(color: Colors.green, fontSize: 15, fontWeight: FontWeight.bold),),
                          Expanded(child: Divider(color: Colors.green,thickness: 1,)),
                        ],
                      ),
                    ),
                    // Champs pour le mois
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: DropdownButton<String>(
                        value: _mois,
                        underline: SizedBox(height: 0,),
                        hint: Container(
                          child: Text("Choisir le mois                                            ", style: TextStyle(color: Colors.blueGrey),),
                        ),
                        icon: Container(
                          child: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.blueGrey,
                          ),
                        ),
                        onChanged: (String? new_value){
                          setState(() {
                            _mois = new_value;
                          });
                        },
                        items: <String>["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"]
                            .map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                              value: value,
                              child: Tooltip(message: value, child: Container(margin: EdgeInsets.only(left: 4, right: 4),child: Text(value, style: TextStyle(color: Colors.blueGrey),),),));
                        }).toList(),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          children: [
                            Expanded(child: Divider(color: Colors.green,thickness: 1,)),
                            Text(" Portes ", style: GoogleFonts.roboto(color: Colors.green, fontSize: 15, fontWeight: FontWeight.bold),),
                            Expanded(child: Divider(color: Colors.green,thickness: 1,)),
                          ],
                        ),
                    ),
                    // Champs pour la porte
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: DropdownButton<String>(
                        value: _portes,
                        underline: SizedBox(height: 0,),
                        hint: Container(
                          child: Text("Choisir le numéro de votre portes            ",style: TextStyle(color: Colors.blueGrey)),
                        ),
                        icon: Container(
                          child: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.blueGrey,
                          ),
                        ),
                        onChanged: (String? new_value){
                          setState(() {
                            _portes = new_value;
                          });
                        },
                        items: <String>["1","2", "3", "4", "5", "6", "7", "8", "9", "10","11"]
                            .map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                              value: value,
                              child: Tooltip(message: value, child: Container(margin: EdgeInsets.only(left: 4, right: 4),child: Text(value, style: TextStyle(color: Colors.blueGrey),),),));
                        }).toList(),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Ligne(color: Colors.green,)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: MyTextFieldForm(
                        name: "Ancien Index",
                        textInputType: TextInputType.number,
                        onChanged: () => (value){ setState(() {
                          _depart = value;
                        });},
                        value: _depart ?? "",
                        edit: true,
                        validator: () => (value){
                          if(value.isEmpty){
                            return "Veuillez saisir l'ancien index";
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
                              _fin = value;
                            });
                          }, validator: () => (value){
                        if(value.isEmpty){
                          return "Veuillez saisir la nouvel index";
                        }
                      },
                          iconData: Icons.note_alt,
                          textInputType: TextInputType.number,
                          edit: true,
                          value: _fin ?? ""
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Button(
                              color: Colors.redAccent,
                              onPressed: () => () => Navigator.pop(context),
                              name: "Annuler"
                          ),
                          Button(
                              color: Colors.blue,
                              onPressed: () => () => _modifier_index(data),
                              name : "Valider"
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

  void _modifier_index(Indexs? data) async{
    final FormState _formkey = _key!.currentState!;
    if(_formkey.validate()){
      loading(context);
      if(_mois == null){
        Navigator.pop(context);
        showAlertDialog(context, "Warning", "Veuillez séléctionner le mois!");
      }else if(_portes == null){
        Navigator.pop(context);
        showAlertDialog(context, "Warning", "Veuillez séléctionner le numéro de porte!");
      }
      data!.mois_id = _mois;
      data!.ancien_index = _depart;
      data!.nouvel_index = _fin;
      data!.portes_id = _portes;
      bool updateIndex = await DbServices().updateIndexs(data);
      if(updateIndex == true){
        Navigator.pop(context);
        Navigator.pop(context);
        showAlertDialog(context, "Success", "Mofication avec succès!");
      }else{
        showAlertDialog(context, "Warning", "Erreur de sauvegarde!");
      }
    }else{
      print("Non");
    }
  }
}
