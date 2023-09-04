import 'package:bv/model/User.dart';
import 'package:bv/pages/users/modifierUser.dart';
import 'package:bv/utils/constant.dart';
import 'package:bv/widgets/ligne_horizontale.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowUsers extends StatefulWidget {

  UserM user, useConnecte;
  ShowUsers({required this.user, required this.useConnecte});

  @override
  State<ShowUsers> createState() => _ShowUsersState();
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

class _ShowUsersState extends State<ShowUsers> {
  UserM? userm, userConnecte;
  String? image, pseudo, roles, adresse, contact, email, genre;
  @override
  void initState() {
    super.initState();
    userm = widget.user;
    image = userm!.image;
    pseudo = userm!.pseudo;
    roles = userm!.roles;
    adresse = userm!.adresse;
    contact = userm!.contact;
    email = userm!.email;
    genre = userm!.genre;
    userConnecte = widget.useConnecte;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("A propos"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.account_box_rounded)),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  elevation: 1,
                  shape: Border(left: BorderSide(color: Colors.green, width: 5)),
                  child: Container(
                      width: double.infinity,
                      height: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Informations", style: Theme.of(context).textTheme.headline4),
                        ],
                      )),
                ),
                Card(
                  shape: Border(left: BorderSide(color: Colors.green, width: 5)),
                  elevation: 1,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 75,
                              height: 75,
                              color: Colors.transparent,
                              child: (image == null) ?
                              CircleAvatar(
                                foregroundColor: Colors.green, radius: 20.0,
                                backgroundImage: AssetImage("assets/photo.png"),
                              ): CircleAvatar(
                                foregroundColor: Colors.green,
                                radius: 20.0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: CachedNetworkImage(
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                    imageUrl: image!,
                                    placeholder: (context, url) => CircularProgressIndicator(), // Widget de chargement affiché pendant le chargement de l'image
                                    errorWidget: (context, url, error) => Icon(Icons.error), // Widget d'erreur affiché si l'image ne peut pas être chargée
                                  ),
                                ),
                                ),
                              ),
                            Column(
                              children: [
                                Text("${pseudo}", style: Theme.of(context).textTheme.headline4),
                              ],
                            )
                          ],
                        ),
                      ),
                      Ligne(color: Colors.grey),
                      _info(iconData: Icons.account_box_rounded, value: "${genre ?? "Aucun"}"),
                      Ligne(color: Colors.grey),
                      InkWell(
                          onTap: () => _Actions(numero: "${email}", action: "mailto"),
                          child: _info(iconData: Icons.email, value: "${email}")),
                      Ligne(color: Colors.grey),
                      InkWell(
                          onTap: () => _Actions(numero: "${contact}", action: "tel"),
                          child: _info(iconData: Icons.phone, value: "${contact}")
                      ),
                      Ligne(color: Colors.grey),
                        _info(iconData: Icons.location_on_outlined, value: "${adresse ?? "Aucun"}"),
                      Ligne(color: Colors.grey),
                      _info(iconData: (roles == "Administrateurs") ? Icons.key : Icons.key_off, value: "${roles ?? "Utilisateurs"}"),
                      userConnecte!.roles == "Administrateurs"
                        ?
                      Ligne(color: Colors.grey)
                        :
                      Container(),
                      userConnecte!.roles == "Administrateurs"
                          ?
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => ModifierUsers(userM: userm)));
                              print("Modifier");
                            },
                              child:  RichText(text: TextSpan(
                                  children: [
                                    WidgetSpan(child: Icon(Icons.update, color: Colors.blue, size: 18)),
                                    TextSpan(text: "   Modifier", style: Theme.of(context).textTheme.headline5),
                                  ]
                              ),
                              ),),
                            Text("|", style: style.copyWith(fontWeight: FontWeight.bold, color: Colors.green),),
                            TextButton(onPressed: (){
                              SupprimerUsers(context, userm);
                              print("Supprimer");
                            },
                              child:  RichText(text: TextSpan(
                                  children: [
                                    WidgetSpan(child: Icon(Icons.delete, color: Colors.red, size: 18,)),
                                    TextSpan(text: "   Supprimer", style: TextStyle(color: Theme.of(context).primaryColorDark)),
                                  ]
                              ),
                              ),),
                          ],
                        ),
                      )
                          :
                      Container()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Alert pour la déconnection
  void SupprimerUsers(BuildContext context, UserM? userm){
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
                  SizedBox(height: 5,),
                  Ligne(color: Colors.blueGrey,),
                  SizedBox(height: 10,),
                  Text("Voulez-vous vraiment supprimer cet utilisateur?", textAlign: TextAlign.center,style: GoogleFonts.roboto(color: Colors.blueGrey, fontSize: 17),),
                  SizedBox(height: 5,),
                ],
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 15),
            actions: [
              Row(
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
                      }, child: Text("Oui",style: TextStyle(color: Theme.of(context).primaryColorDark),)),
                ],
              )
            ],
          );
        });
  }

  Padding _info({IconData? iconData, String? value}){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(iconData, color: Colors.green,),
          SizedBox(width: 5,),
          Text("${value}", style: Theme.of(context).textTheme.headline5),
        ],
      ),
    );
  }
}
