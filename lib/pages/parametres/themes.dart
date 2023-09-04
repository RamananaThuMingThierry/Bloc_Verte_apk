// import 'package:bv/themes/themes_provider.dart';
// import 'package:bv/widgets/button.dart';
// import 'package:bv/widgets/ligne_horizontale.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class Themes extends StatefulWidget {
//   const Themes({Key? key}) : super(key: key);
//
//   @override
//   State<Themes> createState() => _ThemesState();
// }
//
// class _ThemesState extends State<Themes> {
//
//   String? theme = 'c';
//
//   Color? color = Colors.white;
//   Color? color2 = Colors.green;
//   Color? texte = Colors.blueGrey;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: color,
//       appBar: AppBar(
//         title: Text("Sélectionner un thème"),
//         backgroundColor: color2,
//         actions: [
//           IconButton(onPressed: (){}, icon: Icon(Icons.wb_twighlight)),
//         ],
//       ),
//       body: Container(
//         color: color,
//         height: 300,
//         margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         child: Column(
//           children: [
//             Ligne(color : texte),
//             listeTheme(valeur: "c",name : "Claire"),
//             listeTheme(valeur: "s",name : "Sombre"),
//             Ligne(color: texte,),
//             Container(
//                 width: 325,
//                 child: MaterialButton(
//                   height: 45,
//                   color: color2,
//                   onPressed: () {
//                     if(theme == 'c'){
//                       setState(() {
//                         color = Colors.white;
//                         color2 = Colors.green;
//                         texte = Colors.blueGrey;
//                       });
//                     }else{
//                       setState(() {
//                         color = Colors.grey;
//                         color2 = Colors.blueGrey;
//                         texte = Colors.white;
//                       });
//                     }
//                     print("La valuer sélectionner est : ${theme}");
//                   },
//                   child: Text("Valider", style: TextStyle(color: Colors.white),),
//                 )
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//
//         },
//         child: Icon(Icons.brightness_4), // Add a suitable icon for theme switching
//       ),
//     );
//   }
//
//   Padding listeTheme({String? valeur, String? name}){
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 30),
//       child: Row(
//         children: [
//           Radio(
//               activeColor: color2,
//               value: valeur,
//               groupValue: theme,
//               onChanged: (value){
//                 setState(() {
//                   theme = value;
//                 });
//               }),
//           Text("${name}", style: TextStyle(color: texte),),
//         ],
//       ),
//     );
//   }
// }
