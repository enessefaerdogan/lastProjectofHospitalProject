


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_ex/feature/changeUserInfo/view/changeUserInfo_view.dart';
import 'package:flutter_google_maps_ex/product/model/app_user.dart';
import 'package:flutter_google_maps_ex/product/utility/constants/firebase_constants.dart';
import 'package:flutter_google_maps_ex/product/utility/enum/infoType_enum.dart';
import 'package:provider/provider.dart';

class UserProfileViewProvider extends ChangeNotifier{

AppUser _currentUser = AppUser(ad: "ad", email: "email", foto: "foto", id: "id", sifre: "sifre", soyad: "soyad", tc: "tc");
List<AppUser> _users = [];
AppUser _turnedAppUser = AppUser(ad: "ad", email: "email", foto: "foto", id: "id", sifre: "sifre", soyad: "soyad", tc: "tc");

AppUser get currentUser => _currentUser;
List<AppUser> get users => _users;
AppUser get turnedAppUser => _turnedAppUser;

UserProfileViewProvider(){
  fetchUser();
}

  Future<void> fetchUser()async{
    var response = await FirebaseFirestore.instance.collection(FirebaseConstants.kullaniciCollection).get();
    mapUser(response);
  }
  
  mapUser(QuerySnapshot<Map<String,dynamic>> datas){
    final _datas = datas.docs.map((item) => 
    AppUser(ad: item["ad"], email: item["email"], foto: item["foto"], id: item.id, 
    sifre: item["sifre"], soyad: item["soyad"], tc: item["tc"])).toList();

 
      _users = _datas;
      findCurrentUser();
      notifyListeners();

  }

  findCurrentUser() {
    for(int i=0;i<_users.length;i++){
                         //print("HAHA"+_users[i].email);
                        if(_users[i].email == FirebaseAuth.instance.currentUser!.email){
                          
                         
                           _currentUser = _users[i];
                           print("ŞUAN CURRENT:"+_currentUser.ad);
                           notifyListeners();

                        
    
                        }
                      }
  }

  turnedAppUserMethodTC(BuildContext context)async{
    _turnedAppUser = await 
                     Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeUserInfoView(currentUser: _turnedAppUser.tc!= "tc" ? _turnedAppUser : _currentUser,whichPart: InfoTypes.TC.name,)));
    notifyListeners();
  }

  turnedAppUserMethodSifre(BuildContext context)async{
    _turnedAppUser = await 
                     Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeUserInfoView(currentUser: _turnedAppUser.sifre!= "sifre" ? _turnedAppUser : _currentUser,whichPart: InfoTypes.Sifre.name,)));
    notifyListeners();
  }

  turnedAppUserMethodAd(BuildContext context)async{
    _turnedAppUser = await 
                     Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeUserInfoView(currentUser: _turnedAppUser.ad!= "ad" ? _turnedAppUser : _currentUser,whichPart: InfoTypes.Ad.name,)));
    
    notifyListeners();
  }

  turnedAppUserMethodSoyad(BuildContext context)async{
    _turnedAppUser = await 
                     Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeUserInfoView(currentUser: _turnedAppUser.soyad!= "soyad" ? _turnedAppUser : _currentUser,whichPart: InfoTypes.Soyad.name,)));
    notifyListeners();
  }

  checkUser(){
    if(_currentUser.email != _turnedAppUser.email){
     _turnedAppUser = AppUser(ad: "ad", email: "email", foto: "foto", id: "id", sifre: "sifre", soyad: "soyad", tc: "tc");
    }
    notifyListeners();
  }

}