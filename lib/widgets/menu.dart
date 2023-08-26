// import 'dart:io';
// import 'package:bv/class/Drawer.dart';
// import 'package:bv/model/User.dart';
// import 'package:bv/services/authservices.dart';
// import 'package:bv/services/db.dart';
// import 'package:bv/utils/functions.dart';
// import 'package:bv/utils/loading.dart';
// import 'package:bv/widgets/getImage.dart';
// import 'package:bv/widgets/ligne_horizontale.dart';
// import 'package:bv/widgets/nav_menu.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
//
// class Menu extends StatefulWidget{
//   @override
//   State<StatefulWidget> createState() {
//     return MenuState();
//   }
//
// }
//
// class MenuState extends State<Menu>{
//   // Déclarations des variables
//   bool loading = false;
//   AuthServices auth = AuthServices();
//
//   var connectionStatus;
//   late InternetConnectionChecker connectionChecker;
//
//   final _key = GlobalKey<ScaffoldState>();
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     connectionChecker = InternetConnectionChecker();
//     connectionChecker.onStatusChange.listen((status) {
//       setState(() {
//         connectionStatus = status.toString();
//       });
//       if (connectionStatus ==
//           InternetConnectionStatus.disconnected.toString()) {
//         Message(context);
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final user = UserM.current;
//     print("**********************************************************************************");
//     return ClipPath(
//       key: _key,
//       clipBehavior: Clip.antiAliasWithSaveLayer,
//       clipper: OvalRightBorderClipper(),
//       child: Drawer(
//         width: 275.0,
//         child: ListView(
//           children: [
//             UserAccountsDrawerHeader(
//               currentAccountPicture: CircleAvatar(
//               backgroundImage: (user!.image == null) ? Image.asset("assets/photo.png").image : Image.network(user!.image!).image),
//               accountName: Text("${user!.pseudo ?? "Aucun"}"),
//               accountEmail: Text("${user!.email ?? "Aucun"}"),
//               decoration: BoxDecoration(
//                   image: DecorationImage(
//                       image: AssetImage("assets/no_image.jpg"),
//                       fit: BoxFit.cover
//                   )
//               ),
//             ),
//             navMenu(name: "Accueil", onTap: () => () => Navigator.pop(context), iconData: Icons.home),
//             Ligne(),
//             navMenu(name: "Profile", onTap: () => () => print("Profile"), iconData: Icons.account_box_rounded),
//             Ligne(),
//             navMenu(name: "Apropos", onTap: () => () => aproposFunction(), iconData: Icons.info),
//             Ligne(),
//             navMenu(name: "Déconnection", onTap: () => () => deconnectionAlertDialog(), iconData: Icons.logout),
//             Ligne(),
//           ],
//         ),
//       ),
//     );
//   }
// }

