import 'package:bv/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

loading(context) => showDialog(
    context: context,
    builder: (BuildContext context){
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
              Text("Veuillez patientez...", style: TextStyle(color: Colors.grey),),
            ],
          ),
        ),
      );
    }
);

void _showDialog(BuildContext context,String titre, String message){
  showDialog(
      context: context,
      builder: (ctx){
        return AlertDialog(
          title: Text(titre, style: TextStyle(color: Colors.brown),textAlign: TextAlign.center,),
          content: Text(message, style: TextStyle(color: Colors.grey,), textAlign: TextAlign.center,),
          actions: [
            TextButton(
                onPressed: () async{
                  Navigator.of(context).pop();
                },
                child: Text("oui", style: TextStyle(color: Colors.lightBlue),)),
          ],
        );
      });
}

showMessage(BuildContext context,{String? titre, String? message, VoidCallback? ok}) async =>
  showDialog(
    context: context,
    builder: (ctx){
    return AlertDialog(
      title: Text(titre!, style: GoogleFonts.roboto(color: Colors.red),textAlign: TextAlign.center,),
      content: Text(message!, style: GoogleFonts.roboto(color: Colors.blueGrey,), textAlign: TextAlign.center,),
      actions: [
        TextButton(
          onPressed: ok,
          child: Text("OK", style: GoogleFonts.roboto(color: Colors.lightBlue),)),
        TextButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text("Annuler", style: GoogleFonts.roboto(color: Colors.red),)),
    ],
  );
});

void Message(BuildContext context){
  showDialog(
    context: context,
    builder: (BuildContext ctx){
      return AlertDialog(
        title: Row( mainAxisAlignment: MainAxisAlignment.center,children: [Icon(Icons.wifi_off, size: 80,color: Colors.greenAccent,),],),
        content: Text("Pas de connection internet", style: style.copyWith(color: Colors.grey,fontSize: 18),textAlign: TextAlign.center,),
        actions: [
          TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text("OK")),
        ],
      );
    });
}

showAlertDialog(BuildContext context, String? type, String? message){

    var color;
    var iconData;
    String? title;
    if(type == "Success"){
      color = Colors.green;
      title = "Confirmation";
      iconData = Icons.check;
    }else if(type == "Warning"){
      color = Colors.orangeAccent;
      iconData = Icons.warning;
      title = "Avertissement";
    }else if(type == "Info"){
      color = Colors.blue;
      iconData = Icons.info;
      title = "Information";
    }else if(type == "Danger"){
      color = Colors.red;
      title = "Erreur";
      iconData = Icons.dangerous_outlined;
    }

  showDialog(
    context: context,
    builder: (BuildContext context){
      return AlertDialog(
        title:Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, color: color,),
            SizedBox(width: 10,),
            Text(title!,textAlign: TextAlign.center ,style: style.copyWith(color: color),),
          ],
        ),
        content: Text(message!, style: TextStyle(color: Colors.blueGrey),textAlign: TextAlign.center,),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context) , child: Text("Ferme", style: TextStyle(color: Colors.blue))),
        ],
      );
    }
  );
}

