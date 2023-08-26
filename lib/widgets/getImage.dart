import 'dart:io';
import 'dart:math';

import 'package:bv/widgets/ligne_horizontale.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GetImage extends StatelessWidget{
  // Déclaration des variables

  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      color: Colors.green,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Photo de profile",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close, color:  Colors.white,))
            ],
          ),
          Divider(color: Colors.white,thickness: 1,),
          SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  onPressed: ()async{
                    final result = await picker.getImage(source: ImageSource.camera);
                    Navigator.of(context).pop(File(result!.path));
                  },
                  color: Colors.white,
                  icon: Icon(Icons.camera_alt, color: Colors.green,),
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  onPressed: () async{
                    final result = await picker.getImage(source: ImageSource.gallery);
                    Navigator.of(context).pop(File(result!.path));
                  },
                  icon: Icon(Icons.photo_library, color: Colors.green,),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}