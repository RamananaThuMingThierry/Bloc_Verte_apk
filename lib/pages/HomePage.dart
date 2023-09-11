import 'package:bv/auth/updatePassword.dart';
import 'package:bv/class/Drawer.dart';
import 'package:bv/class/Facture.dart';
import 'package:bv/model/Chat.dart';
import 'package:bv/model/User.dart';
import 'package:bv/pages/factures/factureIndex.dart';
import 'package:bv/pages/homePageLoading.dart';
import 'package:bv/pages/index/indexIndex.dart';
import 'package:bv/pages/loyer/loyerIndex.dart';
import 'package:bv/pages/messages/chat.dart';
import 'package:bv/pages/mois/moisIndex.dart';
import 'package:bv/pages/nousContactez/nousContactez.dart';
import 'package:bv/pages/parametres/langue.dart';
import 'package:bv/pages/portes/indexPortes.dart';
import 'package:bv/pages/users/indexUsers.dart';
import 'package:bv/pages/users/profile.dart';
import 'package:bv/services/authservices.dart';
import 'package:bv/services/db.dart';
import 'package:bv/themes/themes_provider.dart';
import 'package:bv/utils/functions.dart';
import 'package:bv/widgets/ligne_horizontale.dart';
import 'package:bv/widgets/nav_menu.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // Déclaration des variables
  UserM? userm;

  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  AuthServices auth = AuthServices();
  var theme;
  var connectionStatus;
  late InternetConnectionChecker connectionChecker;

  Future<void> getUser() async{
    User? user = await auth.user;
    final userResult = await DbServices().getUser(user!.uid);
    setState(() {
      userm = userResult;
      UserM.current = userResult;
    });
  }

  List<Facture> factures = [
    Facture("Portes", Icons.door_front_door_outlined),
    Facture("Mois", Icons.calendar_month),
    Facture("Factures", Icons.fact_check_outlined),
    Facture("Index", Icons.list_alt),
    Facture("Loyer", Icons.home),
    Facture("Utilisateurs", Icons.people),
  ];

  bool ChangeMode(BuildContext context){
    return Theme.of(context).brightness == Brightness.light  ? true : false;
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text("Accueil", style: TextStyle(color: Colors.white),),
        centerTitle: false,
        leading: IconButton(
          onPressed: (){
            _key.currentState!.openDrawer();
          },
          icon: Icon(Icons.menu, color: Colors.white,),),
        elevation: 2.5,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        actions: [
          IconButton(
              onPressed: () {
              final themeProvider = Provider.of<BlocVerteTheme>(context, listen: false);
              themeProvider.toggleTheme();
            },
              icon: ChangeMode(context) == false ? Icon(Icons.light_mode) : Icon(Icons.dark_mode)
          ),
          IconButton(onPressed: (){}, icon: Icon(Icons.notifications_none, color: Colors.white,)),
        ],
      ),

      drawer: userm == null ? null :
        ClipPath(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        clipper: OvalRightBorderClipper(),
        child: Drawer(
          width: 275.0,
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                     child:  ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child:  CachedNetworkImage(
                        fit: BoxFit.cover,
                        width: 250,
                        height: 250,
                        imageUrl: userm!.image!,
                        placeholder: (context, url) => CircularProgressIndicator(), // Widget de chargement affiché pendant le chargement de l'image
                        errorWidget: (context, url, error) => Icon(Icons.error), // Widget d'erreur affiché si l'image ne peut pas être chargée
                      ),
                    ),
                    // backgroundImage: (userm!.image == null) ? Image.asset("assets/photo.png").image : Image.network(userm!.image!).image
                ),
                accountName: Text("${userm!.pseudo ?? "Aucun"}", style: GoogleFonts.roboto(color: Colors.white),),
                accountEmail: Text("${userm!.email ?? "Aucun"}", overflow: TextOverflow.ellipsis, style: GoogleFonts.roboto(color: Colors.white),),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/no_image.jpg"),
                        fit: BoxFit.cover
                    )
                ),
              ),
              navMenu(name: "Accueil", onTap: () => () => _key.currentState!.openEndDrawer(), iconData: Icons.home),
              Ligne(color: Colors.grey,),
              navMenu(name: "Profile", onTap: () => (){ _key.currentState!.openEndDrawer(); Navigator.push(context, MaterialPageRoute(builder: (ctx){
                return Profile(userM: userm!,);
              }));}, iconData: Icons.account_box_rounded),
              Ligne(color: Colors.grey,),
              navMenu(name: "Apropos", onTap: () => (){ _key.currentState!.openEndDrawer(); _showAlertDialogAbout(context);}, iconData: Icons.info),
              Ligne(color: Colors.grey,),
              navMenu(name: "Paramètre", onTap: () => (){ _key.currentState!.openEndDrawer(); _parametre(context);}, iconData: Icons.settings),
              Ligne(color: Colors.grey,),
              (userm!.roles =="Administrateurs")
                  ?
              navMenu(name: "Messages", onTap: () => (){ _key.currentState!.openEndDrawer(); Navigator.push(context, MaterialPageRoute(builder: (context){
                return StreamProvider<List<Chats>>.value(
                  child: Chat(),
                  value: DbServices().getChats,
                  initialData: [],
                );
              }));
              }, iconData: Icons.message)
                  :
              navMenu(name: "Contactez-nous", onTap: () => (){ _key.currentState!.openEndDrawer(); Navigator.push(context, MaterialPageRoute(builder: (context){
                return NousContactez();
              }));
              }, iconData: Icons.phone),
              Ligne(color: Colors.grey,),
              navMenu(name: "Déconnection", onTap: () => (){ _key.currentState!.openEndDrawer(); deconnectionAlertDialog(context);}, iconData: Icons.logout),
              Ligne(color: Colors.grey,),
            ],
          ),
        ),
      ),
      body:   (userm == null) ? HomePageLoading() : Center(
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: factures.length,
            itemBuilder: (context, i){
              Facture facture = factures[i];
              String? key = facture.nom;
              return Container(
                margin: EdgeInsets.all(2.0),
                child: Card(
                  elevation: 2.0,
                  child: InkWell(
                    onTap: (){
                      if(facture.nom == "Portes"){
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext buildContexxt){
                          return  PortesController(users: userm!,);
                        }));
                      }else if(facture.nom == "Factures"){
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext buildContexxt){
                          return FacturesController();
                        }));
                      }else if(facture.nom == "Mois"){
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext buildContexxt){
                          return MoisController(userM: userm!,);
                        }));
                      }else if(facture.nom == "Loyer"){
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext buildContexxt){
                          return LoyerIndex();
                        }));
                      }
                      else if(facture.nom == "Utilisateurs"){
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext buildContexxt){
                          return Utilisateurs(userM: userm!,);
                        }));
                      }
                      else{
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext buildContexxt){
                          return IndexController(userM: userm!,);
                        }));
                      }
                    },
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(facture.iconData, size: 40.0, color: Theme.of(context).primaryColor,),
                        Text("${facture.nom}", style: Theme.of(context).textTheme.headline6),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
  // Future _aprops(BuildContext context){
  //   return showModalBottomSheet(context: context,
  //       backgroundColor: Colors.white,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
  //       ),
  //       builder: (ctx){
  //         return Container(
  //           height: 160,
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Text("Apropos", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 25),),
  //                 ],
  //               ),
  //               Ligne(color: Colors.green),
  //               RichText(
  //                   textAlign: TextAlign.center,
  //                   text: TextSpan(
  //                       children: [
  //                         TextSpan(text: "Trano Maitso", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 15)),
  //                         TextSpan(text: "  est une application de gestions de factures.", style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
  //                       ]
  //                   )),
  //               Ligne(color: Colors.grey,),
  //               RichText(
  //                   textAlign: TextAlign.center,
  //                   text: TextSpan(
  //                       children: [
  //                         TextSpan(text: "Version : ", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15)),
  //                         TextSpan(text: "1.12.0", style: TextStyle(color: Colors.grey, fontSize: 15)),
  //                       ]
  //                   )),
  //             ],
  //           ),
  //         );
  //       });
  // }

  void _showAlertDialogAbout(BuildContext context){
    showAboutDialog(
        context: context,
      applicationName: "Trano Maitso",
      applicationVersion: "1.3.2",
      applicationIcon: Icon(Icons.info, color: Colors.green,),
      applicationLegalese: "@ 2023 Vision-Dev",
      children: [
        SizedBox(height: 10,),
        Text("Information supplémentaires sur l'application.", style: GoogleFonts.roboto(color: Colors.blueGrey),),
      ]
    );
  }

  Future _parametre(BuildContext context){
    return showModalBottomSheet(context: context,
        builder: (ctx){
          return Container(
            height: 200,
            color: Colors.transparent,
            child: Column(
              children: [
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.settings, color: Colors.blueGrey,),
                    SizedBox(width: 10,),
                    Text("Paramètres", style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
                  ],
                ),
                Ligne(color: Colors.grey,),
               Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.wb_twighlight, color: Colors.blueGrey,),
                      SizedBox(width: 10,),
                      TextButton(onPressed: (){
                        Navigator.pop(context);
                        }, child:  Text("Sélectionner un thème", style: TextStyle(color: Colors.grey),),)
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.language, color: Colors.blueGrey,),
                      SizedBox(width: 10,),
                      TextButton(onPressed: (){
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (ctx) => Langue()));
                        print("Changer de langue");
                      }, child:  Text("Changer de langue", style: TextStyle(color: Colors.grey),),)
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.password, color: Colors.blueGrey,),
                      SizedBox(width: 10,),
                      TextButton(onPressed: (){
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (ctx) => updatePassword()));
                        print("Changer le mot passe");
                      }, child:  Text("Changer le mot de passe", style: TextStyle(color: Colors.grey),),)
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

