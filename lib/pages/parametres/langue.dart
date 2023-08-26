import 'package:bv/widgets/button.dart';
import 'package:bv/widgets/ligne_horizontale.dart';
import 'package:flutter/material.dart';

class Langue extends StatefulWidget {
  const Langue({Key? key}) : super(key: key);

  @override
  State<Langue> createState() => _LangueState();
}

class _LangueState extends State<Langue> {

  String? langue = 'fr';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choix de langue"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.language)),
        ],
      ),
      body: Container(
        height: 300,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Ligne(color: Colors.grey,),
            listeLangue(valeur: "fr",name : "Français"),
            listeLangue(valeur: "en",name : "Anglais"),
            listeLangue(valeur: "mlg",name : "Malagasy"),
            Ligne(color: Colors.grey,),
            Container(
              width: 325,
              child: MaterialButton(
                height: 45,
                color: Colors.green,
                onPressed: () { print("La valuer sélectionner est : ${langue}"); },
                child: Text("Valider", style: TextStyle(color: Colors.white),),
              )
            ),
          ],
        ),
      ),
    );
  }

  Padding listeLangue({String? valeur, String? name}){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Radio(
              activeColor: Colors.green,
              value: valeur,
              groupValue: langue,
              onChanged: (value){
                setState(() {
                  langue = value;
                });
              }),
          Text("${name}", style: TextStyle(color: Colors.blueGrey),),
        ],
      ),
    );
  }
}
