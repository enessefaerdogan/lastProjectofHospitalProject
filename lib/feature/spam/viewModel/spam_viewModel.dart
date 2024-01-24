

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_ex/product/model/app_user.dart';
import 'package:flutter_google_maps_ex/product/model/review.dart';
import 'package:flutter_google_maps_ex/product/model/spam.dart';
import 'package:flutter_google_maps_ex/product/utility/constants/firebase_constants.dart';



class SpamViewProvider extends ChangeNotifier{
   List<String> _chooses = [ 
    'Cinsel içerik',
    'Şiddet içeren veya tiksindirici içerik',
    'Nefret söylemi barındıran veya kötü amaçlı içerik',
    'Taciz veya zorbalık',
    'Yanlış bilgilendirme',
    'Diğer'
  ];
  
  String _selectedOption = 'Cinsel içerik';

  List<String> get chooses  => _chooses;
  String get selectedOption => _selectedOption;
 
  

  sendBildir(AppUser currentUser, Review currentReview)async{
    Spam newSpam = Spam(degerlendirmeId: currentReview.id, id: "id", kullanici: currentUser.email, sebep: _selectedOption);
    await FirebaseFirestore.instance.collection(FirebaseConstants.bildirCollection).add(newSpam.toJson());
    notifyListeners();
  }

  changeOption(String newChooses){
    _selectedOption = newChooses;
    notifyListeners();
  }


}