import 'package:bv/model/Mois.dart';
import 'package:bv/services/db.dart';
import 'package:bv/utils/loading.dart';
import 'package:bv/widgets/button.dart';
import 'package:bv/widgets/ligne_horizontale.dart';
import 'package:bv/widgets/myTextFieldForm.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ModifierMois extends StatefulWidget {

  Mois mois;
  ModifierMois({required this.mois});

  @override
  State<ModifierMois> createState() => _ModifierMoisState();
}

class _ModifierMoisState extends State<ModifierMois> {

  // Déclaration des variables
  String? _mois;
  String? _depart;
  String? _fin;
  String? _montant;
  String? _date;
  Mois? data;
  DateTime? selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
     data = widget.mois;
    _mois = widget.mois.nom_mois;
    _depart = widget.mois.nouvel_index;
    _fin = widget.mois.ancien_index;
    _montant = widget.mois.montant_mois;
    _date = widget.mois.date_mois;
  }

  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Modifier mois"),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.calendar_month)),
        ],
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
                    Padding(
                      padding: EdgeInsets.only(right: 5.0, left: 5.0),
                      child: DropdownButton<String>(
                        value: _mois,
                        underline: SizedBox(height: 0,),
                        hint: Container(
                          child: Text("Choisir le mois                                      "),
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
                      padding: EdgeInsets.only(right: 5.0, left: 5.0),
                      child: Ligne(color: Colors.grey,),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 5.0, left: 5.0, bottom: 15),
                      child: MyTextFieldForm(
                        name: "Départ d'index",
                        edit: true,
                        value: _depart! ?? "",
                        onChanged: () => (value){
                          setState(() {
                            _depart = value;
                          });
                        },
                        validator: () => (value){
                          if(value.isEmpty){
                            return "Veuillez saisir l'index de départ";
                          }
                        },
                        iconData: Icons.note_alt_outlined,
                        textInputType: TextInputType.number,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 5.0, left: 5.0, bottom: 5.0),
                      child:MyTextFieldForm(
                        name: "Fin d'index",
                        edit: true,
                        value: _fin! ?? "",
                        onChanged: () => (value){
                          setState(() {
                            _fin = value;
                          });
                        },
                        validator: () => (value){
                          if(value.isEmpty){
                            return "Veuillez saisir la fin d'index!";
                          }
                        },
                        iconData: Icons.note_alt,
                        textInputType: TextInputType.number,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 5.0, left: 5.0, bottom: 5.0),
                      child:MyTextFieldForm(
                        name: "Montant du facture",
                        edit: true,
                        value: _montant! ?? "",
                        onChanged: () => (value){
                          setState(() {
                            _montant = value;
                          });
                        },
                        validator: () => (value){
                          if(value.isEmpty){
                            return "Veuillez saisir le montant du facture!";
                          }
                        },
                        iconData: Icons.note_alt,
                        textInputType: TextInputType.number,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 1.0, left: 1.0),
                      child: ListTile(
                        onTap: () => _selectedDate(context, selectedDate: DateTime.parse(_date!)),
                        title: Text("Date d'aujourd'hui", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),),
                        subtitle: Text("${DateFormat.yMEd('fr').format(DateTime.parse(_date!))}"),
                        trailing: IconButton(
                          icon: Icon(Icons.date_range),
                          onPressed: () => _selectedDate(context),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 5.0, left: 5.0),
                      child: Ligne(color: Colors.grey,),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Button(
                              onPressed: () => () => Navigator.pop(context),
                              name: "Annuler",
                              color: Colors.red
                          ),
                          Button(
                              onPressed: () => () => _modifier_mois(data),
                              name: "Valider",
                              color: Colors.blue),
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

  void _modifier_mois(Mois? data) async{

    final FormState _formkey = _key!.currentState!;

    if(_formkey.validate()){
      loading(context);
      if(_mois == null){
        Navigator.pop(context);
        showAlertDialog(context, "Warning", "Veuillez séléctionner le mois!");
      }else if(selectedDate == null){
        print(selectedDate);
        Navigator.pop(context);
        showAlertDialog(context, "Warning", "Veuillez séléctionner la date!");
      }

      data!.nom_mois = _mois;
      data!.ancien_index = _depart;
      data!.nouvel_index = _fin;
      data!.montant_mois = _montant;
      data!.date_mois = _date;

      bool updateMois = await DbServices().updateMois(data);

      if(updateMois == true){
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

  Future<void> _selectedDate(BuildContext context, {DateTime? selectedDate}) async{

  final DateTime? picked = await showDatePicker(
      context: context,
      helpText: "Selectionner la data d'ajout",
      initialDate: selectedDate!,
      firstDate: DateTime(2020, 8),
      lastDate: DateTime(2101),
      cancelText: "Annuler",
      confirmText: "Valider",
      fieldLabelText: "Date",
      fieldHintText: "Mois/jour/année",
      errorFormatText: "Entrer la date valide",
      errorInvalidText: "Enter date in valid range",
      builder: (BuildContext context, Widget? child){
        return Theme(data: ThemeData.light(), child: child!);
      }
  );

    if(picked != null && picked != selectedDate){
      setState(() {
        _date = picked.toString();
      });
    }
  }

}
