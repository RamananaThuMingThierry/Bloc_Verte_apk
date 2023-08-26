import 'package:flutter/material.dart';

class DonneesVide extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Text(
             "Aucun donnée n'est présent!",
             textAlign: TextAlign.center,
             style: TextStyle(
                 fontSize: 20.0,
                 color: Colors.blueGrey,
                 fontStyle: FontStyle.italic
             ),
           ),
         ],
       ),
    );
  }


}