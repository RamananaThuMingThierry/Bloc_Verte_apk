import 'package:bv/auth/updatePassword.dart';
import 'package:bv/model/User.dart';
import 'package:bv/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthServices{

  FirebaseAuth auth = FirebaseAuth.instance;

  Future signinAnonymous() async{
    try{
      final result = await auth.signInAnonymously();
      return result.user;
    }catch(e){
      print(e);
    }
  }

  Future<User?> get user async{
    // Envoyer l'utilisateur connecter.
    final user = await FirebaseAuth.instance.currentUser;
    return user;
  }

  Future<bool> signup(String email, String pass, String pseudo, String contact, String roles) async{
    try{
      final result = await auth.createUserWithEmailAndPassword(email: email, password: pass);
      if(result.user != null){
        await DbServices().saveUser(UserM(id: result.user!.uid, email: email, pseudo: pseudo, contact: contact, roles: roles));
        return true;
      }else{
        return false;
      }
    }catch(e){
      return false;
    }
  }

  Future<bool> signin(String email, String pass) async{
    try{
      final result = await auth.signInWithEmailAndPassword(email: email, password: pass);
      if(result != null){
        return true;
      }else{
        return false;
      }
    }catch(e){
      return false;
    }
  }

  Future<bool> validationPassword(String password) async{
    var firebaseUser = await auth.currentUser;
    var authCredential = EmailAuthProvider.credential(email: firebaseUser!.email!, password: password);
    try{
      var authResultat = await firebaseUser.reauthenticateWithCredential(authCredential);
      return authResultat!.user! != null;
    }catch(e){
      print(e);
      return false;
    }
  }

  Future<bool> updatePassword(String email, String password) async{
    try{
      final result =  auth.currentUser!.updatePassword(password);
      if(result != null){
        return true;
      }else{
        return false;
      }
    }catch(e){
      return false;
    }
  }

  Future signOut() async{
    try{
      return auth.signOut();
    }catch(e){
      return null;
    }
  }
}