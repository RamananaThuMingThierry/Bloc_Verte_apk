import 'package:bv/model/User.dart';
import 'package:bv/pages/users/showUsers.dart';
import 'package:bv/utils/loading.dart';
import 'package:bv/widgets/donnees_vide.dart';
import 'package:bv/widgets/ligne_horizontale.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

class Utilisateurs extends StatefulWidget {
  const Utilisateurs({Key? key}) : super(key: key);

  @override
  State<Utilisateurs> createState() => _UtilisateursState();
}


class _UtilisateursState extends State<Utilisateurs> {
  /*-- Déclarations des variables --*/
  String? pseudo, email, genre, adresse, contact, image, roles;

  List<UserM> _allUsers = [];
  List<UserM> _resultList = [];

  final TextEditingController _searchController = TextEditingController();

  getUsersStream() async{
    var data = await FirebaseFirestore.instance.collection("users").orderBy("pseudo").get();
    setState(() {
      _allUsers = data.docs.map((e) {
        return UserM.fromJson(e.data() as Map<String, dynamic>);
      }).toList();
    });
    searchResultList();
  }

  searchResultList(){
    List<UserM> showResults = [];
    if(_searchController.text != ""){
      for(var usersSnapShot in _allUsers){
        var pseudo = usersSnapShot.pseudo.toString().toLowerCase();
        if(pseudo.contains(_searchController.text.toLowerCase())){
          showResults.add(usersSnapShot);
        }
      }
    }else{
      showResults = List.from(_allUsers);
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
    getUsersStream();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  var connectionStatus;
  late InternetConnectionChecker connectionChecker;

  @override
  void initState() {
    super.initState();
    getUsersStream();
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
        title: Text("Utilisateurs"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.people)),
        ],
      ),
      body: Column(
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
                ),
              ),
          ),
          Expanded(child: ListView.builder(
              itemCount: _resultList!.length,
              itemBuilder: (context, i){
                UserM user = _resultList![i];
                pseudo = user.pseudo;
                image = user.image;
                roles = user.roles;
                contact = user.contact;
                email = user.email;
                genre = user.genre;
                return user == null ?
                DonneesVide()
                    : Padding(
                  padding: EdgeInsets.only(left: 2.0, right: 2.0),
                  child: InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => ShowUsers(user: user,))),
                    child: Card(
                      shape:  Border(left: BorderSide(color: Colors.green, width: 5)),
                      elevation: 3.0,
                      child: ListTile(
                        trailing: Icon(Icons.chevron_right, color:  Colors.green,),
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
                        title: Text("${pseudo}", maxLines: 1, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey), overflow: TextOverflow.ellipsis,),
                        subtitle: Container(
                          margin: EdgeInsets.only(top: 4.0),
                          child: Text("${email}", style: TextStyle(color: Colors.grey),overflow: TextOverflow.ellipsis,),
                        ),
                        //trailing: IconButton(icon: Icon(Icons.navigate_next_rounded),onPressed: () => print(portesPersonnes.nom_personne),),
                      ),
                    ),
                  ),
                );
              }),),
        ],
      )
    );
  }
}
