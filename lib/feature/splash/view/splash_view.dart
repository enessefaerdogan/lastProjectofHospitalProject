

import 'package:flutter/material.dart';
import 'package:flutter_google_maps_ex/product/utility/constants/firebase_constants.dart';
import 'package:flutter_google_maps_ex/product/service/localStorage/sharedPreferences.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  //SharedPreferencesService _sharedPreferencesService = SharedPreferencesService();

 

  @override
  Widget build(BuildContext context) {
   // MyStatic.isContains;
    //_sharedPreferencesService.init();
    //print(MyStatic.isContains.toString());

    return Scaffold(
        appBar: AppBar(title: Text("Silinecek")//Text(MyStatic.isContains == true ? "Var": "Yok"),
        ),


    );
  }
}