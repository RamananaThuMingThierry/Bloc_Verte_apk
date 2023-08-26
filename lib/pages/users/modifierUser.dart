import 'package:bv/model/User.dart';
import 'package:bv/widgets/donnees_vide.dart';
import 'package:flutter/material.dart';

class ModifierUsers extends StatefulWidget {
  UserM? userM;
  ModifierUsers({required this.userM});

  @override
  State<ModifierUsers> createState() => _ModifierUsersState();
}

class _ModifierUsersState extends State<ModifierUsers> {

  // Déclarations des variables
  UserM? data;
  String? pseudo, image, contact, email, adresse, roles, genre;

  @override
  void initState() {
    data = widget.userM;
    pseudo = data!.pseudo;
    image = data!.image;
    contact = data!.contact;
    email = data!.email;
    adresse = data!.adresse;
    roles = data!.roles;
    genre = data!.genre;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text("Modifier un utilisateur"),
      ),
      body: DonneesVide(),
    );
  }
}
