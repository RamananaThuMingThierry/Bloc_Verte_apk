import 'package:bv/model/Chat.dart';
import 'package:bv/utils/constant.dart';
import 'package:bv/widgets/ligne_horizontale.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowChats extends StatefulWidget {

  Chats c;
  ShowChats({required this.c});

  @override
  State<ShowChats> createState() => _ShowChatsState();
}

class _ShowChatsState extends State<ShowChats> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Message"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(2.0),
        child: Column(
          children: [
            Card(
              elevation: 5,
              shape: Border(left: BorderSide(color: Colors.green, width: 5)),
              child: Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Text("Nom", style: style.copyWith(color: Colors.green, fontSize: 15, fontWeight: FontWeight.bold),),
                         Icon(Icons.person, color: Colors.green,)
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        Text("${widget.c.nom}", style: Theme.of(context).textTheme.headline5),
                      ],
                    ),
                    Ligne(color: Colors.green),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Adrese e-mail", style: style.copyWith(color: Colors.green, fontSize: 15, fontWeight: FontWeight.bold)),
                        Icon(Icons.mail, color: Colors.green,)
                      ],
                    ),
                    SizedBox(height: 4,),
                    Row(
                      children: [
                        Text("${widget.c.email}", style: Theme.of(context).textTheme.headline6),
                      ],
                    ),
                    Ligne(color: Colors.green),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Contact", style: style.copyWith(color: Colors.green, fontSize: 15, fontWeight: FontWeight.bold),),
                        Text("${widget.c.contact}", style: Theme.of(context).textTheme.headline5),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.green,thickness: 1,)),
                        Text(" Message ", style: style.copyWith(color: Colors.green, fontSize: 15, fontWeight: FontWeight.bold),),
                        Expanded(child: Divider(color: Colors.green,thickness: 1,)),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SizedBox(
                        width: double.infinity,
                        child:Text("${widget.c.message}"),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.green)]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: () => _Actions(numero: "${widget.c.contact}", action: "tel"), icon: Icon(Icons.phone, color: Colors.white,)),
            IconButton(onPressed: () => _Actions(numero: "${widget.c.contact}", action: "sms"), icon: Icon(Icons.sms, color: Colors.white,)),
            IconButton(onPressed: () => _Actions(numero: "${widget.c.email}", action: "mailto"), icon: Icon(Icons.email, color: Colors.white,)),
          ],
        ),
      ),
    );
  }

  void _Actions({String? numero, String? action}) async {
    final Uri url = Uri(
        scheme: action,
        path: numero
    );
    if(await canLaunchUrl(url)){
      await launchUrl(url);
    }else{
      print("${url}");
    }
  }
}
