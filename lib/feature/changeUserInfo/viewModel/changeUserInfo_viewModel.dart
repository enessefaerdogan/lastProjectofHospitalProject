


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_ex/product/model/app_user.dart';
import 'package:flutter_google_maps_ex/product/utility/constants/firebase_constants.dart';

class ChangeUserInfoViewModel {

  static Future<AppUser> updateUserSifre({currentUser, controllerSifreText})async{
    AppUser newUser = AppUser(
      ad: currentUser.ad, 
      email: currentUser.email, 
      foto: currentUser.foto, 
      id: currentUser.id, 
      sifre: controllerSifreText, 
      soyad: currentUser.soyad, 
      tc: currentUser.tc);
    await FirebaseFirestore.instance.collection("kullanici").doc(currentUser.id).update(newUser.toJson());

    await FirebaseAuth.instance.currentUser!.updatePassword(controllerSifreText);
    
    return newUser;
  }

  static Future<AppUser> updateUserTC({currentUser, controllerTCText})async{
    AppUser newUser = AppUser(
      ad: currentUser.ad, 
      email: currentUser.email, 
      foto: currentUser.foto, 
      id: currentUser.id, 
      sifre: currentUser.sifre, 
      soyad: currentUser.soyad, 
      tc: controllerTCText);
    await FirebaseFirestore.instance.collection(FirebaseConstants.kullaniciCollection).doc(currentUser.id).update(newUser.toJson());
    return newUser;
  }

  static Future<AppUser> updateUserAd({currentUser, controllerAdText})async{
    AppUser newUser = AppUser(
      ad: controllerAdText, 
      email: currentUser.email, 
      foto: currentUser.foto, 
      id: currentUser.id, 
      sifre: currentUser.sifre, 
      soyad: currentUser.soyad, 
      tc: currentUser.tc);
    await FirebaseFirestore.instance.collection("kullanici").doc(currentUser.id).update(newUser.toJson());
    return newUser;
  }

  static Future<AppUser> updateUserSoyad({currentUser, controllerSoyadText})async{
    AppUser newUser = AppUser(
      ad: currentUser.ad, 
      email: currentUser.email, 
      foto: currentUser.foto, 
      id: currentUser.id, 
      sifre: currentUser.sifre, 
      soyad: controllerSoyadText, 
      tc: currentUser.tc);
    await FirebaseFirestore.instance.collection(FirebaseConstants.kullaniciCollection).doc(currentUser.id).update(newUser.toJson());
    return newUser;
  }


}