
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_google_maps_ex/product/model/app_user.dart';
import 'package:flutter_google_maps_ex/product/utility/constants/firebase_constants.dart';

class SignUpService{


  static final _authInstance = FirebaseAuth.instance;
  static final _storeInstance = FirebaseFirestore.instance.collection(FirebaseConstants.kullaniciCollection);

  static void createUser({email, password}) async{
    await _authInstance.createUserWithEmailAndPassword(email: email, password: password);
  }

  static void firestoreAddUser({email, password,ad, soyad, tc, fotoAdress}) async{
    AppUser _newUser = AppUser(ad: ad,soyad: soyad,tc: tc,email: email,sifre: password,id: "id", foto: 'assets/default.jpg');
    await _storeInstance.add(_newUser.toJson());
  }




}