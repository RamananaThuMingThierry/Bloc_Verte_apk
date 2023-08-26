import 'dart:io';
import 'package:bv/model/Mois.dart';
import 'package:bv/model/Portes.dart';
import 'package:bv/model/User.dart';
import 'package:bv/model/Index.dart';
import 'package:bv/model/Chat.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as Path;

class DbServices{

  final CollectionReference userCol = FirebaseFirestore.instance.collection("users");
  final CollectionReference portesCol = FirebaseFirestore.instance.collection("portes");
  final CollectionReference moisCol = FirebaseFirestore.instance.collection("mois");
  final CollectionReference indexCol = FirebaseFirestore.instance.collection("index");
  final CollectionReference chatCol = FirebaseFirestore.instance.collection("chats");

  Future saveUser(UserM user) async{
    try{
      await userCol.doc(user.id).set(user.toMap());
      return true;
    }catch(e){
      return false;
    }
  }

  Future savePortes(Portes portes) async{
    try{
      await portesCol.doc(portes.id).set(portes.toMap());
      return true;
    }catch(e){
      return false;
    }
  }


  Future saveChats(Chats chats) async{
    try{
      await chatCol.doc(chats.id).set(chats.toMap());
      return true;
    }catch(e){
      return false;
    }
  }

  Future saveMois(Mois mois) async{
    try{
      await moisCol.doc(mois.id).set(mois.toMap());
      return true;
    }catch(e){
      return false;
    }
  }

  Future saveIndex(Indexs index) async{
    try{
      await indexCol.doc(index.id).set(index.toMap());
      return true;
    }catch(e){
      return false;
    }
  }

  Future updatePortes(Portes portes) async{
    try{
      await portesCol.doc(portes.id).update(portes.toMap());
      return true;
    }catch(e){
      return false;
    }
  }

  Future updateIndexs(Indexs indexs) async{
    try{
      await indexCol.doc(indexs.id).update(indexs.toMap());
      return true;
    }catch(e){
      return false;
    }
  }

  Future updateMois(Mois mois) async{
    try{
      await moisCol.doc(mois.id).update(mois.toMap());
      return true;
    }catch(e){
      return false;
    }
  }

  // Future deleteVehicule(String id) async{
  //   try{
  //     await vehiculeCol.doc(id).delete();
  //     return true;
  //   }catch(e){
  //     return false;
  //   }
  // }

  Future<UserM?> getUser(String id) async{
    final donne = await userCol.doc(id).get();
    final user = UserM.fromJson(donne.data() as Map<String, dynamic>);
    if(user == null){
      return null;
    }else{
      return user;
    }
  }

  Stream<List<UserM>> get getUsers{
    return userCol.orderBy('pseudo').snapshots().map((user){
      return user.docs.map((e) {
        return UserM.fromJson(e.data() as Map<String, dynamic>);
      }).toList();
    });
  }


  Stream<List<Portes>> get getPortes{
    return portesCol.orderBy('numero_porte').snapshots().map((portes){
      return portes.docs.map((e) {
        return Portes.fromJson(e.data() as Map<String, dynamic>);
      }).toList();
    });
  }


  Stream<List<Mois>> get getMois{
    return moisCol.orderBy('date_mois').snapshots().map((mois){
      return mois.docs.map((e) {
        return Mois.fromJson(e.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Stream<List<Chats>> get getChats{
    return chatCol.orderBy('date', descending: true).snapshots().map((date){
      return date.docs.map((e) {
        return Chats.fromJson(e.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Stream<List<Indexs>> get getIndex{
    return indexCol.orderBy('portes_id', descending: false).snapshots().map((index){
      return index.docs.map((e) {
        return Indexs.fromJson(e.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Future<List<Portes>> getPortes() async {
  //   QuerySnapshot snapshot = await portesCol.get();
  //   return snapshot.docs.map((doc) {
  //     final data = doc.data();
  //     return Portes(
  //       id: doc.id,
  //       nom: data['nom'],
  //       numero_porte: data['numero_porte'],
  //     );
  //   }).toList();
  // }

  Future<int> countPortes() async{
    QuerySnapshot snapshot = await portesCol.get() as QuerySnapshot<Object?>;
    return snapshot.size;
  }

  Future<int> countMois() async{
    QuerySnapshot snapshot = await moisCol.get() as QuerySnapshot<Object?>;
    return snapshot.size;
  }

  Future<int> countIndex() async{
    QuerySnapshot snapshot = await indexCol.get() as QuerySnapshot<Object?>;
    return snapshot.size;
  }

  Future<int> countChats() async{
    QuerySnapshot snapshot = await chatCol.get() as QuerySnapshot<Object?>;
    return snapshot.size;
  }

  Future<bool> VerfierPortes(String numero_porte) async{
   QuerySnapshot snapshot = (await portesCol.where('numero_porte', isEqualTo: numero_porte).get()) as QuerySnapshot<Object?>;
   if(snapshot.size > 0){
     return true;
   }else{
     return false;
   }
  }


  // Future<bool> VerfierMois(String numero_porte) async{
  //   QuerySnapshot snapshot = (await portesCol.where('numero_porte', isEqualTo: numero_porte).get()) as QuerySnapshot<Object?>;
  //   if(snapshot.size > 0){
  //     return true;
  //   }else{
  //     return false;
  //   }
  // }

  // Récupér un numéro de porte
  // Future RecupererNumeroPortes(String numero_porte) async{
  //   DocumentSnapshot snapshot = (await portesCol.where('numero_porte', isEqualTo: numero_porte).get()) as DocumentSnapshot<Object?>;
  //   if(snapshot.exists){
  //     return snapshot.;
  //   }else{
  //     return null;
  //   }

  Future recupererNumeroPortes(String numero_porte)async{
    QuerySnapshot data = await portesCol.where('numero_porte', isEqualTo: numero_porte).limit(1).get();
   if(data.size > 0){
      DocumentSnapshot snapshot = data.docs[0];
      return snapshot.data();
   }else{
     null;
   }
  }

    Future<bool> updateUser(UserM userM) async{
    try{
      await userCol.doc(userM.id).update(userM.toMap());
      return true;
    }catch(e){
      return false;
    }
  }

  Future<String?> uploadImage(File file, {String? path}) async{
    var time = DateTime.now().toString();
    var ext = Path.basename(file.path).split(".")[1].toString();
    String image = path! + "_" + time + "." + ext;
    try{
      Reference ref = FirebaseStorage.instance.ref().child(path! + "/" + image);
      UploadTask uploadTask = ref.putFile(file);
      return await uploadTask.then((res) => res.ref.getDownloadURL());
    }catch(e){
      return null;
    }
  }

  Future<List<String>?> get getCarouselImage async{
    try{
      final FirebaseStorage storage = FirebaseStorage.instance;
      final Reference imagesRef = storage.ref().child('carousel');
      final ListResult result = await imagesRef.listAll();
      final List<String> imageURLs = [];
      for (final Reference ref in result.items) {
        final String downloadURL = await ref.getDownloadURL();
        imageURLs.add(downloadURL);
      }
      return imageURLs;
    }catch(e){
      return null;
    }
  }
}