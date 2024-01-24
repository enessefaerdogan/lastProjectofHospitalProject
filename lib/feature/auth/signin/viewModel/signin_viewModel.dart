

/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_ex/product/model/app_user.dart';
import 'package:flutter_google_maps_ex/product/utility/constants/firebase_constants.dart';

class SigninViewProvider extends ChangeNotifier{
  //fields
  bool _showPass = true;
  List<AppUser> _users = [];
  AppUser _currentUser = AppUser(ad: "ad", email: "email", foto: "foto", id: "id", sifre: "sifre", soyad: "soyad", tc: "tc");
  String _docId = "";
  
  //get methods
  bool get showPass => _showPass; 
  List<AppUser> get users => _users;
  //AppUser get currentUser => _currentUser;
  //String get docId => _docId;

  //constructor
  /*SigninViewProvider(){
    fetchUser();
  }*/

  void changeShowPass(){
    _showPass = !_showPass;
    notifyListeners();
  }


  /*Future<void> fetchUser()async{
    var response = await FirebaseFirestore.instance.collection(FirebaseConstants.kullaniciCollection).get();
    mapUser(response);
  }
  
  mapUser(QuerySnapshot<Map<String,dynamic>> datas){
    final _datas = datas.docs.map((item) => 
    AppUser(ad: item["ad"], email: item["email"], foto: item["foto"], id: item.id, 
    sifre: item["sifre"], soyad: item["soyad"], tc: item["tc"])).toList();

    _users = _datas;
    notifyListeners();

  }*/


 /* findCurrentUser(String userMail, List<AppUser> users) {
    print("İÇERDEYİMMMMMMM FİNDCURRENTUSERR");
    for(int i=0;i<users.length;i++){
      print("ELEMENA $i adı: "+users[i].ad);
                        if(users[i].email == userMail){
                          
                         
                           _currentUser = users[i];
                           newcurrentUserr(_currentUser);
                           print("BULDUK MU ? "+_currentUser.ad);
                           //print("CURRENT USER :"+_currentUser.ad);
                           _docId = users[i].id;
                           notifyListeners();
    
                        }
                      }
  }*/
  
  /*newcurrentUserr(AppUser newCurrentUser){
      _currentUser = newCurrentUser;
      notifyListeners();
  }*/
  
  /*zeroedUser(){
    _currentUser = AppUser(ad: "ad", email: "email", foto: "foto", id: "id", sifre: "sifre", soyad: "soyad", tc: "tc");
    notifyListeners();
  }*/
  
}*/