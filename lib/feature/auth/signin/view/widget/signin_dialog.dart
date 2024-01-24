/*
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_ex/core/components/apptext.dart';
import 'package:lottie/lottie.dart';

class _SigninDialog extends StatefulWidget {
  const _SigninDialog({super.key});

  @override
  State<_SigninDialog> createState() => __SigninDialogState();
}

class __SigninDialogState extends State<_SigninDialog> {
  @override
  Widget build(BuildContext context) {
   return AlertDialog(
        backgroundColor: Colors.white,

    title: AppText.appText("Değerlendirme", 17, Colors.black,FontWeight.normal),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: MediaQuery.of(context).size.width*0.16,
          height: MediaQuery.of(context).size.height*0.08,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),border: Border.all(width: 2)),
          child: Lottie.asset(name),
        ),
        //Text("Puan:" + _userRating.toString()),
      
      
    ],),
    actions: [
      
 
      TextButton(onPressed: (){
        Navigator.pop(context);
      }, child: AppText.appText("Kapat", 14, Colors.green,FontWeight.normal)),

    ],
      );
   
  }
}*/