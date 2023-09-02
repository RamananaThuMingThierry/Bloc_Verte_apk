import 'package:bv/utils/constant.dart';
import 'package:bv/widgets/ligne_horizontale.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


// Apropos de cette application
void aproposFunction(BuildContext context){
   showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext buildContext){
        return AlertDialog(
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outlined, color: Colors.green,),
                SizedBox(width: 10,),
                Text("Informations", textAlign:TextAlign.center,style: TextStyle(color: Colors.green),),
              ],
            ),
          ),
          content: Container(
            height: 300,
            child: Column(
              children: [
                Ligne(color: Colors.grey,),
                SizedBox(height: 10,),
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        children: [
                          TextSpan(text: "Trano Maitso", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15)),
                          TextSpan(text: "  est une application de gestions de factures.", style: TextStyle(color: Colors.blueGrey, fontSize: 15)),
                        ]
                    )),
                Ligne(color: Colors.grey,),
                info(name: "Nom"),
                donnees(value: "RAMANANA Thu Ming Thierry"),
                SizedBox(height: 10,),
                info(name: "Email"),
                donnees(value: "ramananathumingthierry@gmail.com"),
                SizedBox(height: 10,),
                info(name: "Adresse"),
                donnees(value: "VT 29 RAI bis"),
                SizedBox(height: 10,),
                info(name: "Contact"),
                donnees(value: "032 75 637 70"),
                Ligne(color: Colors.grey,),
                SizedBox(height: 10,),
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        children: [
                          TextSpan(text: "Version : ", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15)),
                          TextSpan(text: "1.0.16", style: TextStyle(color: Colors.grey, fontSize: 15)),
                        ]
                    )),
              ],
            ),
          ),
          contentPadding: EdgeInsets.only(top: 2.0, left: 5.0, right: 5.0),
          actions: [
            Ligne(color: Colors.grey,),
            TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text("Ferme", style: TextStyle(color: Colors.redAccent),)),
          ],
        );
      });
}

Row info({String? name}){
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text("${name} :", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 15)),
    ],
  );
}

Row donnees({String? value}){
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text("${value}", style: TextStyle(color: Colors.grey , fontSize: 15)),
    ],
  );
}

// Alert pour la déconnection
void deconnectionAlertDialog(BuildContext context){
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext buildContext){
        return AlertDialog(
          title: Text("Déconnexion ?", textAlign:TextAlign.center,style: TextStyle(color: Colors.green),),
          content: SizedBox(
            height: 80,
            child: Column(
              children: [
                Ligne(color: Colors.blueGrey,),
                SizedBox(height: 5,),
                Text("Souhaitez-vous vraiment vous déconnecter?", textAlign: TextAlign.center,style: GoogleFonts.roboto(color: Colors.blueGrey, fontSize: 17),),
                SizedBox(height: 5,),
              ],
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 5),
          actions: [
            Card(
              elevation: 0,
              shape: Border(top: BorderSide(width: 1, color: Colors.blueGrey)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                        print("Annuler");
                      },
                      child: Text("Annuler", style: TextStyle(color: Colors.redAccent),)),
                  Text("|", style: TextStyle(color: Colors.green),),
                  TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                        onLoading(context);
                      }, child: Text("Ok",style: TextStyle(color: Colors.blueGrey),)),
                ],
              ),
            ),
          ],
        );
      });
}

// Alert pour un mauvaise mot de passe
void badPassword(BuildContext context){
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext buildContext){
        return AlertDialog(
          title: Center(child: Text("Avertissement", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),)),
          content: SizedBox(
            height: 130,
            child: Column(
              children: [
                Ligne(color: Colors.blueGrey,),
                SizedBox(height: 5,),
                Text("Votre ancien mot de passe n'est pas valide!", textAlign: TextAlign.center,style: GoogleFonts.roboto(color: Colors.blueGrey, fontSize: 17),),
                SizedBox(height: 5,),
                Ligne(color: Colors.blueGrey),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(onPressed: () => Navigator.pop(context), child:  Text("Ok", style: TextStyle(color: Colors.blue),),),
                    ],
                  ),
                ),
              ],
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        );
      });
}

void onLoading(BuildContext context){
  showDialog(
      context: context,
      builder: (BuildContext context){
        Future.delayed(Duration(seconds: 3), () async {
          Navigator.pop(context);
          await FirebaseAuth.instance.signOut();
        });
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          contentPadding: EdgeInsets.all(0.0),
          insetPadding: EdgeInsets.symmetric(horizontal: 100),
          content: Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Colors.green,),
                SizedBox(height: 16,),
                Text("Déconnection...", style: TextStyle(color: Colors.grey),)
              ],
            ),
          ),
        );
      });
}

String formatAmount(String price){
  String priceText = "";
  int counter = 0;
  for(int i = (price.split(".")[0].length - 1); i >= 0 ; i--){
    counter++;
    String str = price[i];
    if((counter % 3 ) != 0 && i != 0){
      priceText = "$str$priceText";
    }else if(i == 0){
      priceText = "$str$priceText";
    }else{
      priceText = " $str$priceText";
    }
  }
  priceText = priceText +"." +price.split(".")[1];
  return priceText.trim();
}

Padding TextTitre({String? name}){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 18),
    child: Row(
      children: [
        Text("${name}", style: style.copyWith(color: Colors.green, fontWeight: FontWeight.bold),),
      ],
    ),
  );
}

Widget CardText({IconData? iconData, String? value}){
  return TextFormField(
    enabled: false,
    style: TextStyle(color: Colors.blueGrey),
    onFieldSubmitted: (arg){},
    decoration: InputDecoration(
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      hintText: "${value}",
      hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
      prefixIcon: Icon(iconData, color: Colors.blueGrey, size: 20,),
    ),
    textInputAction: TextInputAction.search,
    textAlignVertical: TextAlignVertical.center,
  );
}

