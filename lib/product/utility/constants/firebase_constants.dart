import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

@immutable
class FirebaseConstants{

  ///collection names
  static const kullaniciCollection = "kullanici";
  static const degerlendirmeCollection = "degerlendirme";
  static const favorilerCollection = "favoriler";
  static const hastaneCollection = "hastane";
  static const bildirCollection = "bildir";
  static const begeniCollection = "begeni";
  static const mesajCollection = "mesaj";

}