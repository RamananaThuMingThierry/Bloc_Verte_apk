import 'package:bv/utils/constant.dart';
import 'package:flutter/material.dart';

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
      title: Text(titre!, style: TextStyle(color: Colors.brown),textAlign: TextAlign.center,),
      content: Text(message!, style: TextStyle(color: Colors.grey,), textAlign: TextAlign.center,),
      actions: [
        TextButton(
          onPressed: ok,
          child: Text("oui", style: TextStyle(color: Colors.lightBlue),)),
        TextButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text("non", style: TextStyle(color: Colors.redAccent),)),
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

showAlertDialog(BuildContext context, String? title, String? message){
    var color;
    var iconData;
    if(title == "Success"){
      color = Colors.green;
      iconData = Icons.check;
    }else if(title == "Warning"){
      color = Colors.orangeAccent;
      iconData = Icons.warning;
    }else{
      color = Colors.blue;
      iconData = Icons.info_outlined;
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
        content: Text(message!, style: TextStyle(color: Colors.blueGrey),),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context) , child: Text("Ok", style: TextStyle(color: Colors.blue))),
        ],
      );
    }
  );
}

