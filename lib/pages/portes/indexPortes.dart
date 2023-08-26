import 'dart:io';
import 'package:bv/model/Portes.dart';
import 'package:bv/model/User.dart';
import 'package:bv/pages/portes/ajouterPortes.dart';
import 'package:bv/pages/portes/modifierPortes.dart';
import 'package:bv/services/db.dart';
import 'package:bv/utils/loading.dart';
import 'package:bv/widgets/button.dart';
import 'package:bv/widgets/donnees_vide.dart';
import 'package:bv/widgets/ligne_horizontale.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PortesController extends StatefulWidget{
  UserM? users;
  PortesController({required this.users});

  @override
  State<StatefulWidget> createState() {
    return PortesState();
  }
}

class PortesState extends State<PortesController>{
  UserM? utilisateurs;
  var connectionStatus;
  late InternetConnectionChecker connectionChecker;
  // Déclarations des variables
  String? nom, image, contact, numero;

  /* -- début du teste --*/
  List<Portes> _allPortes = [];
  List<Portes> _resultList = [];

  final TextEditingController _searchController = TextEditingController();

  getPortesStream() async{
    var data = await FirebaseFirestore.instance.collection("portes").orderBy("nom").get();
    setState(() {
      _allPortes = data.docs.map((e) {
        return Portes.fromJson(e.data() as Map<String, dynamic>);
      }).toList();
    });
    searchResultList();
  }

  searchResultList(){
    List<Portes> showResults = [];
    if(_searchController.text != ""){
      for(var portesSnapShot in _allPortes){
        var nom = portesSnapShot.nom.toString().toLowerCase();
        if(nom.contains(_searchController.text.toLowerCase())){
          showResults.add(portesSnapShot);
        }
      }
    }else{
      showResults = List.from(_allPortes);
    }
    setState(() {
      _resultList = showResults;
    });
  }

  _onSearchChanged(){
    print(_searchController.text);
   searchResultList();
  }

  @override
  void didChangeDependencies() {
    getPortesStream();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getPortesStream();
    utilisateurs = widget.users;
    _searchController.addListener(_onSearchChanged);
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Portes"),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => AjouterPortes())),
              icon: Icon(Icons.add)
          )
        ],
      ),
      body:
      Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2),
            child: Card(
              shape: Border(bottom: BorderSide(width: 2, color: Colors.green)),
              elevation: 2,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: TextFormField(
                  style: TextStyle(color: Colors.blueGrey),
                  controller: _searchController,
                  onFieldSubmitted: (arg){},
                  decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    suffixIcon: Icon(Icons.account_box_rounded, color: Colors.blueGrey,),
                    hintText: "Recherche",
                    hintStyle: TextStyle(fontSize: 15, color: Colors.blueGrey),
                    prefixIcon: Icon(Icons.search, color: Colors.blueGrey, size: 20,),
                  ),
                  textInputAction: TextInputAction.search,
                  textAlignVertical: TextAlignVertical.center,
                ),
                // child: CupertinoSearchTextField(
                //
                //   controller: _searchController,
                //   backgroundColor: Colors.transparent,
                // ),
              ),
            ),
          ),
          Expanded(child:  ListView.builder(
              itemCount: _resultList!.length,
              itemBuilder: (context, i){
                Portes p = _resultList[i];
                nom = p.nom;
                image = p.image;
                contact = p.contact;
                numero = p.numero_porte;
                return p == null ?
                DonneesVide()
                    :
                Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: Card(
                        shape: Border(left: BorderSide(color: Colors.green, width: 5)),
                        elevation: 5.0,
                        child: ListTile(
                          onTap: () => voirPortes(p),
                          trailing: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(text : "${numero}", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey, fontSize: 25)),
                                WidgetSpan(child: Icon(Icons.door_front_door_outlined, color: Colors.grey,),),
                              ],
                            ),
                          ),
                          leading: (image == null)
                              ?  CircleAvatar(
                              foregroundColor: Colors.green, radius: 20.0,
                              backgroundImage: Image.asset("assets/photo.png").image)
                              :  CircleAvatar(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child:  CachedNetworkImage(
                                imageUrl: image!,
                                placeholder: (context, url) => CircularProgressIndicator(), // Widget de chargement affiché pendant le chargement de l'image
                                errorWidget: (context, url, error) => Icon(Icons.error), // Widget d'erreur affiché si l'image ne peut pas être chargée
                              ),
                            ),
                          ),
                          //              backgroundImage: (portesPersonnes.image == null) ? Image.asset("assets/photo.png").image : Image.network(portesPersonnes!.image!).image),
                          title: Text("${nom}", maxLines: 1, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey), overflow: TextOverflow.ellipsis,),
                          subtitle: Container(
                            margin: EdgeInsets.only(top: 4.0),
                            child: Text("${contact}", style: TextStyle(color: Colors.grey),),
                          ),
                          //trailing: IconButton(icon: Icon(Icons.navigate_next_rounded),onPressed: () => print(portesPersonnes.nom_personne),),
                        ),
                      ),
                    );
              }),),
          // Expanded(child: ListView.builder(
          //     itemCount: _resultList.length,
          //     itemBuilder: (context, i){
          //       return _resultList == null ? DonneesVide(): ListTile(
          //         title: Text(_resultList[i]["nom"]),
          //       );
          //     }))
        ],
      ),
    );
  }

  void voirPortes(Portes? portes){
    showDialog(
        context: context,
        builder: (BuildContext buildContext){
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.0),
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black26,blurRadius: 10.0, offset: Offset(0.0,10.0)),
                ],
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(2.0),
              ),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Apropos", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),),
                          Icon(Icons.close, color: Colors.red,),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: (portes!.image == null )
                        ? Image.asset("assets/photo.png", fit: BoxFit.contain,)
                        : CachedNetworkImage(
                      imageUrl: portes!.image!,
                      placeholder: (context, url) => CircularProgressIndicator(), // Widget de chargement affiché pendant le chargement de l'image
                      errorWidget: (context, url, error) => Icon(Icons.error), // Widget d'erreur affiché si l'image ne peut pas être chargée
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left:20, top: 5.0, bottom: 10),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(child: Icon(Icons.door_front_door_outlined, color: Colors.grey,),),
                              TextSpan(text : "  ${portes.numero_porte}", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey, fontSize: 25)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left:20, top: 5.0, bottom: 10),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(child: Icon(Icons.account_box_sharp, color: Colors.grey,),),
                              TextSpan(text : "  ${portes.nom}", style: TextStyle(color: Colors.blueGrey, fontSize: 15, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => _Actions(numero: "${portes.contact}", action: "tel"),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left:20, top: 5.0, bottom: 10),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(child: Icon(Icons.phone, color: Colors.grey,),),
                                TextSpan(text : "  ${portes.contact}", style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  utilisateurs!.roles == "Administrateurs"
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) {
                            return ModifierPortes(portes: portes,);
                          })),
                          child: RichText(
                            text: TextSpan(
                                children: [
                                  WidgetSpan(child: Icon(Icons.edit, color: Colors.blueGrey,)),
                                  TextSpan(text: " Modifiier", style: TextStyle(color: Colors.blueGrey))
                                ]
                            ),
                          )),
                      Text("|", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20),),
                      TextButton(
                          onPressed: () => print("Supprimer"),
                          child: RichText(
                            text: TextSpan(
                                children: [
                                  WidgetSpan(child: Icon(Icons.delete, color: Colors.redAccent,)),
                                  TextSpan(text: " Supprimer", style: TextStyle(color: Colors.blueGrey))
                                ]
                            ),
                          )),
                    ],
                  )
                      : SizedBox(height: 0,)
                ],
              ),
            ),
          );
        });
  }

  void _Actions({String? numero, String? action}) async {
    final Uri url = Uri(
        scheme: action,
        path: numero
    );
    if(await canLaunchUrl(url)){
      await launchUrl(url);
    }else{
      print("${url}");
    }
  }
}