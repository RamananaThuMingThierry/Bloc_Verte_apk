import 'package:bv/model/Index.dart';
import 'package:bv/shimmer/loadingFactures.dart';
import 'package:bv/utils/constant.dart';
import 'package:bv/utils/functions.dart';
import 'package:bv/utils/loading.dart';
import 'package:bv/widgets/donnees_vide.dart';
import 'package:bv/widgets/ligne_horizontale.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';

class FacturesController extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return FacturesState();
  }
}

class FacturesState extends State<FacturesController>{
  // Déclarations des variables
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
    fetchPortes();
    fetchIndex();
    fetchMois();
  }

  var position = 0;
  List Listesportes = [];
  List Listesmois = [];
  List Listesindexs = [];
  List ListesSomme = [];
  List ListesSommeIndex = [];

  fetchIndex() async{
    QuerySnapshot qn = await FirebaseFirestore.instance.collection("index").get();
    setState(() {
      for(int i = 0; i < qn.docs.length; i++){
        Listesindexs.add(
            {
              "nouvel_index": qn.docs[i]["nouvel_index"],
              "ancien_index": qn.docs[i]["ancien_index"],
              "payer": qn.docs[i]["payer"],
              "mois_id" : qn.docs[i]["mois_id"],
              "portes_id": qn.docs[i]["portes_id"],
            }
        );
      }
    });
  }

  fetchMois() async{
    QuerySnapshot qn = await FirebaseFirestore.instance.collection("mois").get();
    setState(() {
      for(int i_mois = 0; i_mois < qn.docs.length; i_mois++){
        Listesmois.add(
            {
              "nom_mois": qn.docs[i_mois]["nom_mois"],
              "nouvel_index": qn.docs[i_mois]["nouvel_index"],
              "ancien_index": qn.docs[i_mois]["ancien_index"],
              "montant_mois": qn.docs[i_mois]["montant_mois"],
            }
        );
      } // fin du boucle mois
    });
  }

  fetchPortes() async {
    QuerySnapshot qn = await FirebaseFirestore.instance.collection("portes").get();
    setState(() {
        for(int i = 0; i < qn.docs.length; i++){
          Listesportes.add(
              {
                "numero_porte": qn.docs[i]["numero_porte"],
                "nom": qn.docs[i]["nom"],
                "image": qn.docs[i]["image"]
              }
          );
        }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Factures"),
        actions: [
          IconButton(
              onPressed: (){},
              icon: Icon(Icons.fact_check_outlined)
          ),
        ],
      ),
      body: _resultListIndex.length == 0
          ?
      LoadingFactures()
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
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, i){
                    String nomMois = snapshot.data.docs[i]['nom_mois'];
                    double? ancien_index_mois = double.parse(snapshot.data.docs[i]['ancien_index']);
                    double? nouvel_index_mois = double.parse(snapshot.data.docs[i]['nouvel_index']);
                    double? consommer_mois = (nouvel_index_mois - ancien_index_mois) as double?;
                    double? montant_mois = double.parse(snapshot.data.docs[i]['montant_mois']);
                    double? montant_mois_fmg = montant_mois * 5;
                    String date = snapshot.data.docs[i]['date_mois'];
                    for(int i_mois = 0; i_mois < Listesmois.length; i_mois++){
                      if(Listesmois[i_mois]["nom_mois"] == nomMois){
                        double? sommeIndex = 0;
                        for(int i_index = 0; i_index < Listesindexs.length; i_index++){
                          if(Listesmois[i_mois]["nom_mois"] == Listesindexs[i_index]["mois_id"]){
                            sommeIndex = sommeIndex! + (double.parse(Listesindexs[i_index]["nouvel_index"]) - (double.parse(Listesindexs[i_index]["ancien_index"])));
                          }
                        }


                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          child: Container(
                            width: 350,
                            child: Card(
                              elevation: 2.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(padding: EdgeInsets.only(top: 20.0)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("${nomMois}", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20.0))
                                    ],
                                  ),
                                  Ligne(color: Colors.blueGrey,),
                                  SizedBox(height: 5,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(Icons.calendar_month, color: Theme.of(context).primaryColorDark, size: 30.0,),
                                      Text("${DateFormat.yMMMMEEEEd('fr').format(DateTime.parse(date))}", style: TextStyle(color: Theme.of(context).primaryColorDark, fontSize: 15.0))
                                    ],
                                  ),
                                  SizedBox(height: 5,),
                                  Ligne(color: Colors.blueGrey,),
                                  SizedBox(height: 5,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: [
                                          Text("Ancien Index", style: style.copyWith(color: Colors.green, fontSize: 15, fontWeight: FontWeight.bold),),
                                          Text("${formatAmount(ancien_index_mois.toString())}", style: Theme.of(context).textTheme.headline5),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text("Nouvel Index", style: style.copyWith(color: Colors.green, fontSize: 15, fontWeight: FontWeight.bold)),
                                          Text("${formatAmount(nouvel_index_mois.toString())}", style: Theme.of(context).textTheme.headline5),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text("Consommé", style: style.copyWith(color: Colors.green, fontSize: 15, fontWeight: FontWeight.bold)),
                                          Text("${consommer_mois!.toStringAsFixed(2)}", style: Theme.of(context).textTheme.headline5),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5,),
                                  Ligne(color: Colors.blueGrey),
                                  SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: [
                                          Text("Total consommer", style: style.copyWith(color: Colors.green, fontSize: 15, fontWeight: FontWeight.bold)),
                                          //                Text("${somme_index}", style: style.copyWith(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.bold))
                                          Text("${sommeIndex!.toStringAsFixed(2)}" , style: Theme.of(context).textTheme.headline6),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text("Reste compteur", style: style.copyWith(color: Colors.green, fontSize: 15, fontWeight: FontWeight.bold)),
                                          //                Text("${somme_index}", style: style.copyWith(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.bold))
                                          Text("${(consommer_mois - sommeIndex).toStringAsFixed(2)}", style: Theme.of(context).textTheme.headline6),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Ligne(color: Colors.grey),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Text("Payer compteur", style: style.copyWith(color: Colors.green, fontSize: 15, fontWeight: FontWeight.bold)),
                                          Text("${ formatAmount(((montant_mois * (consommer_mois - sommeIndex)) / consommer_mois ).toStringAsFixed(2)) }", style: Theme.of(context).textTheme.headline6),
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      Expanded(child: Divider(color: Colors.blueGrey,)),
                                      SizedBox(width: 16),
                                      Text("Détails des portes", style: Theme.of(context).textTheme.headline6),
                                      SizedBox(width: 16,),
                                      Expanded(child: Divider(color: Colors.blueGrey,)),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 300,
                                    child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: _resultListIndex.length,
                                        itemBuilder: (context, j){
                                          Indexs index = _resultListIndex[j];
                                          double? ancien = double.parse(index.ancien_index!);
                                          double? news = double.parse(index.nouvel_index!);
                                          double? consommerIndex = (news - ancien) as double?;
                                          double? payer = (montant_mois * consommerIndex!) / consommer_mois;
                                          String? valide = index.payer == true ? "Payer" : "Non payer";
                                          if ((nomMois == index.mois_id)) {
                                              return Container(
                                                color: Colors.grey,
                                                width: 350,
                                                child: Column(
                                                  children: [
                                                    for(int i = 0 ; i < Listesportes.length ; i++)
                                                      if(Listesportes[i]["numero_porte"] == index.portes_id)
                                                        ShowPortes(
                                                            compteur: (((montant_mois * (consommer_mois - sommeIndex!)) / consommer_mois ) / Listesportes.length).toStringAsFixed(2),
                                                            payer: "${payer!.toStringAsFixed(2)}",
                                                            payer_ar: ( (((montant_mois * (consommer_mois - sommeIndex!)) / consommer_mois ) / Listesportes.length) + payer).toStringAsFixed(2),
                                                            payer_fmg: (( (((montant_mois * (consommer_mois - sommeIndex!)) / consommer_mois ) / Listesportes.length) + payer) * 5).toStringAsFixed(2),
                                                            nom: "${Listesportes[i]["nom"]}",
                                                            porte: "${Listesportes[i]["numero_porte"]}",
                                                            debut: "${ancien}", fin: "${news}", consommer: "${consommerIndex!.toStringAsFixed(2)}",
                                                            image: "${Listesportes[i]["image"]}",
                                                            valide: "${valide}"
                                                        ),
                                                  ],
                                                ),
                                              );
                                          } else {
                                            return Container(
                                            );
                                          }
                                        }),
                                  ),
                                  Ligne(color: Colors.blueGrey),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Total en Ar", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15)),
                                        Text("${formatAmount(montant_mois.toString())}", style: Theme.of(context).textTheme.headline5),
                                        ]
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Total en Fmg", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15)),
                                        Text("${formatAmount(montant_mois_fmg.toString())}", style: Theme.of(context).textTheme.headline5),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    }

                  });
            }
            return LoadingFactures();
          },
        ),
      ),
    );
  }

  Widget ShowPortes({String? nom, String? porte, String? debut, String? fin, String? consommer, String? image, String? payer, String? compteur, String? payer_ar, String? payer_fmg, String? valide}){
    return  Container(
      margin: EdgeInsets.only(top: 5),
      color: Theme.of(context).primaryColorLight,
      child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            backgroundColor: Theme.of(context).primaryColorLight,
            title:  RichText(text: TextSpan(
                children: [
                  TextSpan(text: "Portes : ", style: TextStyle(color: Colors.green)),
                  TextSpan(text: "${porte}", style: Theme.of(context).textTheme.headline4),
                ]
            )),
            leading: (image == "null")
                ?  CircleAvatar(
                    foregroundColor: Colors.green, radius: 20.0,
                   backgroundImage: Image.asset("assets/photo.png").image,
                  )
                :  CircleAvatar(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child:  CachedNetworkImage(
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  imageUrl: image!,
                  placeholder: (context, url) => CircularProgressIndicator(), // Widget de chargement affiché pendant le chargement de l'image
                  errorWidget: (context, url, error) => Icon(Icons.error), // Widget d'erreur affiché si l'image ne peut pas être chargée
                ),
              ),
            ),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            childrenPadding: EdgeInsets.only(right: 80,bottom: 20),
            children: [
              _listePortes(name: "Nom : ",value: "${nom}"),
              _listePortes(name: "Début : ",value: "${debut}"),
              _listePortes(name: "Fin : ",value: "${fin}"),
              _listePortes(name: "Consommé : ", value: "${consommer}"),
              _listePortes(name: "Compteur : ", value: "${formatAmount(compteur.toString())}"),
              _listePortes(name: "Tarif : ", value: "${formatAmount(payer!)}"),
              _listePortes(name: "Payer en Ar: ", value: "${formatAmount(payer_ar!)}"),
              _listePortes(name: "Payer en Fmg: ", value: "${formatAmount(payer_fmg!)}"),
              _listePortes(name: "Status: ", value: "${valide}"),
            ],
          )
      ),
    );
  }

  Widget _listePortes({String? name, String? value}){
    return Padding(
      padding: EdgeInsets.only(top: 4),
      child:  RichText(text: TextSpan(
          text: "${name}",
          style: TextStyle(color: Theme.of(context).primaryColorDark),
          children: [
            TextSpan(text: "${value}", style: TextStyle(color: Colors.grey)),
          ]
      )),
    );
  }
}