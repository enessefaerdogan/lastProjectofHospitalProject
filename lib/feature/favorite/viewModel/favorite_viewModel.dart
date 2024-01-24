

/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_ex/product/model/app_user.dart';
import 'package:flutter_google_maps_ex/product/model/favorite.dart';
import 'package:flutter_google_maps_ex/product/model/hospital.dart';
import 'package:flutter_google_maps_ex/product/model/review.dart';
import 'package:flutter_google_maps_ex/product/utility/constants/firebase_constants.dart';

class FavoriteViewProvider extends ChangeNotifier{

  List<Favorite> _favorites  = [];
  List<String> _hospitalNames = [];
  List<Review> _reviews = [];
  List<AppUser> _users = [];
  List<Hospital> _hospitals = [];
  List<Hospital> _realHospitals = [];
  bool _isRealHospitalsLoading = true;

  List<Favorite> get favorites => _favorites;
  List<String> get hospitalNames => _hospitalNames;
  List<Review> get reviews => _reviews;
  List<AppUser> get users => _users;
  List<Hospital> get hospitals => _hospitals;
  List<Hospital> get realHospitals => _realHospitals;
  bool get isRealHospitalsLoading => _isRealHospitalsLoading;
  

  FavoriteViewProvider(){
    fetchFavorite();
    fetchReview();
    fetchHastane();
    fetchUser();
  }

  Future<void> fetchFavorite()async{
    var response = await FirebaseFirestore
    .instance
    .collection(FirebaseConstants.favorilerCollection)
    .where('kullanicimail',isEqualTo: FirebaseAuth.instance.currentUser!.email.toString())
    .get();
    mapFavorite(response);
    //print("SIKINTIIIIIIIIIIIIIIIIIII");
    //print("MAİL ŞUYDU :"+ widget.appUser!.email);
  }
  
  mapFavorite(QuerySnapshot<Map<String,dynamic>> datas){
    final _datas = datas.docs.map((item) =>
    Favorite(
    hastanead: item["hastanead"], 
    id: item.id, 
    kullanicimail: item["kullanicimail"])
    ).toList();

    
      _favorites = _datas;
     // _isFavorited = _favoriteDetector() ? true : false;
     _favoriteNames();
    notifyListeners();
  }

  Future<void> fetchReview()async{
    var response = await FirebaseFirestore.instance.collection(FirebaseConstants.degerlendirmeCollection).get();
    mapReview(response);
  }
  
  mapReview(QuerySnapshot<Map<String,dynamic>> datas){
    final _datas = datas.docs.map((item) => Review(tarih: item["tarih"],foto: item["foto"],hastane: item["hastane"], 
    id: item.id,
     kullanici: item["kullanici"], 
     puan: item["puan"], 
     yorum: item["yorum"])).toList();

   
    _reviews = _datas;
    notifyListeners();
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
    notifyListeners();
  }
  void _favoriteNames(){
    for(int i=0;i<_favorites.length;i++){
     
        _hospitalNames.add(_favorites[i].hastanead);
       
    }
  }


  Future<void> fetchHastane()async{
    var response = await FirebaseFirestore.instance.collection(FirebaseConstants.hastaneCollection).get();
    mapHastane(response);
  }
  
  mapHastane(QuerySnapshot<Map<String,dynamic>> datas){
    final _datas = datas.docs.map((item) =>  Hospital(
      website: item["website"],
      latitude: item["latitude"],
      longitude: item["longitude"],
      foto: item["foto"],tel: item["tel"],ad: item["ad"], adres: item["adres"], id: item.id, 
    ilce: item["ilce"], il: item["il"])).toList();

   
      _hospitals = _datas;
      _hospitalDetector();
      notifyListeners();
  }

  void _hospitalDetector(){
    for(int i=0;i<_hospitals.length;i++){

      if(_hospitalNames.contains(_hospitals[i].ad)){
        
        
        _realHospitals.add(_hospitals[i]);
        notifyListeners();

      print("YAZDIM BABA");
      }

    }

    
      _isRealHospitalsLoading = false;
      notifyListeners();
  }

}*/