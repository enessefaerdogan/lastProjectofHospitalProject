
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SignInService{


  static final _authInstance = FirebaseAuth.instance;

  static Future<void> signIn({email, password})async{
    await _authInstance.signInWithEmailAndPassword(email: email, password: password)
    .catchError((e){
      /*ScaffoldMessenger.of(context).showSnackBar(
                  
                  SnackBar(backgroundColor: Colors.white,content: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,child: Lottie.asset("asset/Animation - 1702991913424.json")),
                              Text("Giriş Başarısız! Veriler eksik veya hatalı.",style: TextStyle(color: Colors.black,fontSize: 17,fontFamily: 'Open Sans'),),
                            ],
                          ),
                          action: SnackBarAction(
              label: 'Kapat',
              textColor: Colors.black38,
              onPressed: () { 
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),)
            
            );*/
    });
  }


}