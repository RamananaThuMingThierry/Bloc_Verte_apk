import 'dart:io';
import 'dart:math';

import 'package:bv/widgets/ligne_horizontale.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class GetImage extends StatefulWidget{
  @override
  State<GetImage> createState() => _GetImageState();
}

class _GetImageState extends State<GetImage> {
  // Déclaration des variables
  final picker = ImagePicker();

  File? imageFiles;
  String? image;
  File? selectedImage;

  CroppedFile? croppedImage;

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
                    if(result != null){
                      // final File imageR = File(result!.path);
                      // cropImage(imageR);
                      // Navigator.of(context).pop(File(image!));
                      Navigator.of(context).pop(File(result!.path));
                    }
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

  Future cropImage(File imageR) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageR.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Recadrez l\'image',
            toolbarColor: Colors.green,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: Colors.green,
            hideBottomControls: false,
            cropGridColumnCount: 3,
            cropGridRowCount: 3,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    if (croppedFile != null) {
      print("******************************************************************************** ${croppedFile}");
      setState(() {
        croppedImage = croppedFile;
        image = croppedFile.path;
        imageFiles = File(croppedFile!.path);
      });
      print("******************************************************************************** ${croppedImage}");
    }
  }
}