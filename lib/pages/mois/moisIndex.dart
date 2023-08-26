import 'dart:ffi';

import 'package:bv/class/Mois.dart';
import 'package:bv/model/Mois.dart';
import 'package:bv/pages/mois/ajouterMois.dart';
import 'package:bv/pages/mois/modifierMois.dart';
import 'package:bv/services/db.dart';
import 'package:bv/utils/constant.dart';
import 'package:bv/utils/functions.dart';
import 'package:bv/utils/loading.dart';
import 'package:bv/widgets/donnees_vide.dart';
import 'package:bv/widgets/ligne_horizontale.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MoisController extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MoisState();
  }
}

class MoisState extends State<MoisController>{

  var connectionStatus;
  late InternetConnectionChecker connectionChecker;

  @override
  void initState() {
    super.initState();
    connectionChecker = InternetConnectionChecker();
    connectionChecker.onStatusChange.listen((status) {
      setState(() {
        connectionStatus = status.toString();
      });
      if (connectionStatus ==
          InternetConnectionStatus.disconnected.toString()) {
        Message(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Mois> moisFacture = Provider.of<List<Mois>>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Mois"),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => AjouterMois())),
              icon: Icon(Icons.add))
        ],
      ),
      body: ListView.builder(
          itemCount: moisFacture.length,
          itemBuilder: (context , i){
            Mois mois = moisFacture[i];
            return mois == null
            ? DonneesVide()
            : Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: InkWell(
                onLongPress: (){
                  _modifierOuSupprimer(context, mois: mois);
                },
                child: Card(
                  elevation: 5.0,
                  shape: Border(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.only(top: 20.0)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${mois.nom_mois}", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 20.0))
                        ],
                      ),
                      Ligne(color: Colors.grey,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.calendar_month, color: Colors.lightBlue,),
                            Text("${DateFormat.yMMMMEEEEd('fr').format(DateTime.parse(mois!.date_mois!))}", style: TextStyle(color: Colors.lightBlue))
                          ],
                        ),
                      ),
                      Ligne(color: Colors.grey,),
                      Padding(padding: EdgeInsets.only(top: 20.0)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(text: TextSpan(
                              children: [
                                TextSpan(text: "Départ", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)),
                              ]
                          ),
                          ),
                          RichText(text: TextSpan(
                              children: [
                                WidgetSpan(child: Padding(padding: EdgeInsets.only(left:125.0),)),
                                TextSpan(text: "Fin", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)),
                              ]
                          ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 5.0)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(text: TextSpan(
                              children: [
                                WidgetSpan(child: Padding(padding: EdgeInsets.only(right: 5.0), child: Icon(Icons.note_alt_outlined, color: Colors.grey,),)),
                                TextSpan(text: "${formatAmount(double.parse(mois.ancien_index!).toString())}", style: TextStyle(color: Colors.blueGrey)),
                              ]
                          ),

                          ),
                          RichText(text: TextSpan(
                              children: [
                                WidgetSpan(child: Padding(padding: EdgeInsets.only(left:80.0, right: 5.0), child: Icon(Icons.note_alt, color: Colors.grey,),)),
                                TextSpan(text: "${formatAmount(double.parse(mois.nouvel_index!).toString())}", style: TextStyle(color: Colors.blueGrey)),
                              ]
                          ),

                          ),

                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 20.0)),
                      Ligne(color: Colors.grey,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Switch(
                              value: mois.payer!,
                              onChanged: (v) async {
                                setState((){
                                  mois!.payer = v;
                                });
                                bool updateMois = await DbServices().updateMois(mois);
                                if(updateMois == true){
                                  showAlertDialog(context, "Success", "Mofication avec succès!");
                                }else{
                                  showAlertDialog(context, "Warning", "Erreur de sauvegarde!");
                                }
                              },
                              activeColor: Colors.green,
                              inactiveTrackColor: Colors.grey,
                              activeTrackColor: Colors.blueGrey,
                            ),
                            Text("Status : ${mois!.payer == true ? "Payer" : "Non payer"}"),
                          ],
                        ),
                      ),
                      Ligne(color: Colors.grey,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.payments_outlined, color: Colors.green,),
                            Text("${formatAmount(mois.montant_mois!) ?? "0"} Ar", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 20.0)),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  // Alert pour la déconnection
  void SupprimerMois(BuildContext context, Mois? mois){
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext buildContext){
          return AlertDialog(
            title: Text("Confirmation", textAlign:TextAlign.center,style: TextStyle(color: Colors.green),),
            content: SizedBox(
              height: 75,
              child: Column(
                children: [
                  Ligne(color: Colors.blueGrey,),
                  SizedBox(height: 10,),
                  Text("Voulez-vous vraiment supprimer ce mois?", textAlign: TextAlign.center,style: GoogleFonts.roboto(color: Colors.blueGrey, fontSize: 15),),
                  SizedBox(height: 5,),
                ],
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 5),
            actions: [
              Card(
                elevation: 0,
                shape: Border(top: BorderSide(color: Colors.green, width: 1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                          print("Annuler");
                        },
                        child: Text("Non", style: TextStyle(color: Colors.redAccent),)),
                    Text("|", style: TextStyle(color: Colors.green, fontSize: 25, fontWeight: FontWeight.bold),),
                    TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        }, child: Text("Oui",style: TextStyle(color: Colors.blueGrey),)),
                  ],
                ),
              )
            ],
          );
        });
  }

  void _modifierOuSupprimer(BuildContext context, {Mois? mois}){
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext buildContext){
          return AlertDialog(
            content: SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                      TextButton(onPressed: (){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (ctx) => ModifierMois(mois: mois!)));
                              print("Modifier");
                            },
                          child:  RichText(text: TextSpan(
                              children: [
                                WidgetSpan(child: Icon(Icons.update, color: Colors.blue, size: 18)),
                                TextSpan(text: "   Modifier", style: style.copyWith(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                              ]
                          ),
                      ),),
                      Text("|", style: style.copyWith(fontWeight: FontWeight.bold, color: Colors.green),),
                      TextButton(onPressed: (){
                          Navigator.pop(context);
                          SupprimerMois(context, mois);
                          print("Supprimer");
                        },
                        child:  RichText(text: TextSpan(
                            children: [
                              WidgetSpan(child: Icon(Icons.delete, color: Colors.red, size: 18,)),
                              TextSpan(text: "   Supprimer", style: TextStyle(color: Colors.blueGrey)),
                            ]
                        ),
                        ),),
                  ],
              ),
            ),
          );
        });
  }
}
