



import 'package:flutter/material.dart';
import 'package:flutter_google_maps_ex/product/model/app_user.dart';

class SignupViewProvider extends ChangeNotifier{

  bool _showPass = true;
  List<AppUser> _users = [];
  
  bool get showPass => _showPass; 
  List<AppUser> get users => _users;

  void changeShowPass(){
    _showPass = !_showPass;
    notifyListeners();
  }


  void usersSet(List<AppUser> myUsers){
    _users = myUsers;
    notifyListeners();
  }

}