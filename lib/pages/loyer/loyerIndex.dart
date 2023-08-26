import 'package:bv/widgets/donnees_vide.dart';
import 'package:flutter/material.dart';

class LoyerIndex extends StatefulWidget {
  const LoyerIndex({Key? key}) : super(key: key);

  @override
  State<LoyerIndex> createState() => _LoyerIndexState();
}

class _LoyerIndexState extends State<LoyerIndex> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Loyer"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.money))
        ],
      ),
      body: DonneesVide(),
    );
  }
}
