import 'package:bv/model/Index.dart';
import 'package:bv/model/Mois.dart';
import 'package:bv/model/User.dart';
import 'package:bv/pages/index/ajouterIndex.dart';
import 'package:bv/pages/index/modifierIndex.dart';
import 'package:bv/services/db.dart';
import 'package:bv/utils/constant.dart';
import 'package:bv/utils/loading.dart';
import 'package:bv/widgets/donnees_vide.dart';
import 'package:bv/widgets/ligne_horizontale.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

class IndexController extends StatefulWidget{
 UserM? userM;
 IndexController({required this.userM});

  @override
  State<StatefulWidget> createState() {
    return IndexState();
  }

}

class IndexState extends State<IndexController>{

  // Déclarations des variables
  UserM? utilisateurs;
  String? roles;

  List<Indexs> _allIndex = [];
  List<Indexs> _resultListIndex = [];

  getIndexsStream() async{
    var data = await FirebaseFirestore.instance.collection("index").get();
    setState(() {
      _allIndex = data.docs.map((e) {
        return Indexs.fromJson(e.data() as Map<String, dynamic>);
      }).toList();
      _resultListIndex = List.from(_allIndex);
    });
  }

  @override
  void initState() {
    super.initState();
    getIndexsStream();
    utilisateurs = widget.userM;
    roles = utilisateurs!.roles!;
  }

  // Déclarations des variables
  String? mois;
  List<Mois>? moisall;
  List<Indexs>? index;

  @override
  Widget build(BuildContext context) {
    getIndexsStream();
    return Scaffold(
      appBar: AppBar(
        title: Text("Index Facture"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
              onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (BuildContext b){
                return AjouterIndex();
              })),
              icon: Icon(Icons.add)),
        ],
      ),
      body: _resultListIndex.length == 0
        ?
      Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Veuillez patientez...", style: GoogleFonts.roboto(fontSize: 18, color: Colors.green),),
          SpinKitThreeBounce(
            color: Colors.green,
            size: 30,
          ),
        ],
      ),)
        :
      RefreshIndicator(
        onRefresh: () => getIndexsStream(),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('mois').snapshots(),
          builder: (context, AsyncSnapshot snapshot){
            if(snapshot.hasData){
              if(snapshot.data.docs.length < 1){
                return DonneesVide();
              }
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, i){
                    String nomMois = snapshot.data.docs[i]['nom_mois'];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Card(
                        color: Colors.blueGrey,
                        elevation: 5.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(padding: EdgeInsets.only(top: 20.0)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${nomMois}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0))
                              ],
                            ),
                            Ligne(color: Colors.grey,),
                            SizedBox(
                              height: 250,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _resultListIndex.length,
                                  itemBuilder: (context, j){
                                    Indexs index = _resultListIndex[j];
                                    String? key = _resultListIndex[j].id;
                                    double? ancien = double.parse(index.ancien_index!);
                                    double? news = double.parse(index.nouvel_index!);
                                    double? consommer = (news - ancien) as double?;
                                    return (nomMois == index.mois_id)
                                        ? Container(
                                      color: Colors.grey,
                                      width: 350,
                                      child: InkWell(
                                        onLongPress: (){
                                          roles == "Administrateurs"
                                              ?
                                          _modifierOuSupprimer(context, indexs: index)
                                              :
                                              showAlertDialog(context, "Info", "Vous n'êtes pas un administrateur! Vous n'avez pas eu accès!");
                                        },
                                        child: Card(
                                          color: Colors.white,
                                          elevation: 0,
                                          shape: Border(),
                                          child: Column(
                                            children: [
                                              Padding(padding: EdgeInsets.only(top: 20.0)),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  RichText(text: TextSpan(
                                                      children: [
                                                        TextSpan(text: "Portes : ", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)),
                                                      ]
                                                  ),
                                                  ),
                                                  RichText(text: TextSpan(
                                                      children: [
                                                        WidgetSpan(child: Padding(padding: EdgeInsets.only(left:125.0),)),
                                                        TextSpan(text: "${index.portes_id}", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)),
                                                      ]
                                                  ),
                                                  ),
                                                ],
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
                                              Padding(padding: EdgeInsets.only(top: 2.0)),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  RichText(text: TextSpan(
                                                      children: [
                                                        WidgetSpan(child: Padding(padding: EdgeInsets.only(right: 5.0), child: Icon(Icons.note_alt_outlined, color: Colors.blueGrey,),)),
                                                        TextSpan(text: "${index.ancien_index}", style: TextStyle(color: Colors.blueGrey)),
                                                      ]
                                                  ),

                                                  ),
                                                  RichText(text: TextSpan(
                                                      children: [
                                                        WidgetSpan(child: Padding(padding: EdgeInsets.only(left:80.0, right: 5.0), child: Icon(Icons.note_alt, color: Colors.blueGrey,),)),
                                                        TextSpan(text: "${index.nouvel_index}", style: TextStyle(color: Colors.blueGrey)),
                                                      ]
                                                  ),

                                                  ),

                                                ],
                                              ),
                                              Ligne(color: Colors.grey),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Switch(
                                                    value: index!.payer!,
                                                    onChanged: (value) async {
                                                      setState((){
                                                        index!.payer = value;
                                                      });
                                                      bool updateIndex = await DbServices().updateIndexs(index);
                                                      if(updateIndex == true){
                                                        showAlertDialog(context, "Success","Mofication avec succès!");
                                                      }else{
                                                        showAlertDialog(context, "Warning","Erreur de sauvegarde!");
                                                      }
                                                    },
                                                    activeColor: Colors.green,
                                                    inactiveTrackColor: Colors.grey,
                                                    activeTrackColor: Colors.blueGrey,
                                                  ),
                                                  Text("Payer : ${index!.payer == true ? "Oui" : "Non"}")
                                                ],
                                              ),
                                              Ligne(color: Colors.grey,),
                                              cardRow(name: "Consommer", value: "${consommer!.toStringAsFixed(2)}"),
                                            ],
                                          ),
                                        ),
                                      )
                                    )
                                        : Container(
                                    );
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }
            return Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Veuillez patientez...", style: GoogleFonts.roboto(fontSize: 18, color: Colors.green),),
                SpinKitThreeBounce(
                  color: Colors.green,
                  size: 30,
                ),
              ],
            ),);
          },
        ),
      ),
    );
  }

  Padding cardRow({String? name, String? value}){
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${name}", style: TextStyle(color: Colors.blueGrey),),
          Text("${value}", style: TextStyle(color: Colors.blueGrey),),
        ],
      ),
    );
  }

  // Alert pour la déconnection
  void SupprimerIndex(BuildContext context, Indexs? index){
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext buildContext){
          return AlertDialog(
            title: Text("Confirmation", textAlign:TextAlign.center,style: TextStyle(color: Colors.green),),
            content: SizedBox(
              height: 80,
              child: Column(
                children: [
                  Ligne(color: Colors.blueGrey,),
                  SizedBox(height: 10,),
                  Text("Voulez-vous vraiment supprimer cet index?", textAlign: TextAlign.center,style: GoogleFonts.roboto(color: Colors.blueGrey, fontSize: 17),),
                  SizedBox(height: 5,),
                ],
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 15),
            actions: [
              Card(
                shape: Border(top: BorderSide(color: Colors.green, width: 1)),
                elevation: 0,
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

  void _modifierOuSupprimer(BuildContext context, {Indexs? indexs}){
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
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) => ModifierIndex(indexs: indexs!)));
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
                    SupprimerIndex(context, indexs);
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