import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_ex/core/extension/mediaquery_extension.dart';
import 'package:flutter_google_maps_ex/product/model/like.dart';
import 'package:flutter_google_maps_ex/product/widget/apptext.dart';
import 'package:flutter_google_maps_ex/product/widget/indicator.dart';
import 'package:flutter_google_maps_ex/core/components/sizedbox_height.dart';
import 'package:flutter_google_maps_ex/feature/hospitalDetail/view/hospitalDetail_view.dart';
import 'package:flutter_google_maps_ex/product/model/app_user.dart';
import 'package:flutter_google_maps_ex/product/model/hospital.dart';
import 'package:flutter_google_maps_ex/product/model/review.dart';
import 'package:flutter_google_maps_ex/product/utility/constants/firebase_constants.dart';
import 'package:geolocator/geolocator.dart';


class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> with TickerProviderStateMixin{
  
  bool _isExpanded = false;
  TextEditingController _ilController = TextEditingController();
  TextEditingController _ilceController = TextEditingController();
  TextEditingController _hastalikController = TextEditingController();
  TextEditingController _puanController = TextEditingController();
  /*
  Hastaneye eklenen tüm bölümlerin aranması şeklinde olabilir
  TextEditingController _bolumController = TextEditingController();*/
  List<Hospital> _hospitals = [];
  Future<void> fetchHastane()async{
    var response = await FirebaseFirestore.instance.collection(FirebaseConstants.hastaneCollection).get();
    mapHastane(response);
  }
  Future<void> fetchHastanewithil(String il)async{
    var response = await FirebaseFirestore.instance.collection(FirebaseConstants.hastaneCollection)
    .where('il',isEqualTo: il)
    .get();
    mapHastane(response);
  }
  Future<void> fetchHastanewithilce(String ilce)async{
    var response = await FirebaseFirestore.instance.collection(FirebaseConstants.hastaneCollection)
    .where('ilce',isEqualTo: ilce)
    .get();
    mapHastane(response);
  }
  Future<void> fetchHastanewithilceandil(String il,String ilce)async{
    var response = await FirebaseFirestore.instance.collection(FirebaseConstants.hastaneCollection)
    .where('il',isEqualTo: il)
    .where('ilce',isEqualTo: ilce)
    .get();
    mapHastane(response);
  }
  Future<void> fetchHastaneWithNoilandilce()async{
    var response = await FirebaseFirestore.instance.collection(FirebaseConstants.hastaneCollection)
    .get();
    mapHastane(response);
  }

  List<Like> _likes = [];
  fetchLike()async{
   var response = await FirebaseFirestore.instance.collection(FirebaseConstants.begeniCollection).get();
   mapLike(response);
  }

  mapLike(QuerySnapshot<Map<String,dynamic>> datas){
    final _datas = datas.docs.map((item) => 
    Like(
      degerlendirmeId: item["degerlendirme_id"], 
      id: item.id, 
      kullanici: item["kullanici"]) ).toList();
      setState(() {
                _likes = _datas;
      });
  }



  void hastalikBul(String hastalik, List<Hospital> _hospitalss)async{
    // tüm reviewlarda gez
    _hastalikHospitals = [];
    _maxFilteredHospitals = [];
    List<Review> _maxFilteredReviews = [];
    double _maxFilteredReviewAvarage = 0;
    //print("GELEN ELEMANLAR:"+_hospitalss.length.toString());
    for(int i=0;i<reviews.length;i++){
      if(reviews[i].yorum.toLowerCase().contains(hastalik.toLowerCase())){
        //print("BU YORUMDA VARRR");
        int _isHad = 0;
         for(int j=0;j<_hastalikHospitals.length;j++){
            if(_hastalikHospitals[j].ad == reviews[i].hastane){
              setState(() {
                _isHad += 1;
                //print("İSHAD :"+_isHad.toString());
              });
            }}
            //print("YOKMUŞ");
          // eğer _isHad 0 ise al bu hastane adına denk gelen _hospitali _hastalikHospitals'e ekle
          if(_isHad == 0){
            //print("İSHAD2 :"+_isHad.toString());
            setState(() {
            _maxFilteredReviews = [];
            _maxFilteredReviewAvarage = 0;
            for(int n=0;n<_hospitalss.length;n++){
              //print("POİNT1");
              //print("hospitale ad :"+_hospitalss[n].ad);
              //print(object)
              if(_hospitalss[n].ad == reviews[i].hastane){
                //print("POİNT2");
                 //_maxFilteredHospitals.add(value)
                 // burda bir for daha açıp tüm hastaneye bağlı reviewleri buraya alsak
                 for(int k = 0;k<reviews.length;k++){
                  if(reviews[k].hastane == _hospitalss[n].ad){
                    // aradığımız hastanedeyiz
                    // filtreReviewslere ekle
                    _maxFilteredReviews.add(reviews[i]);
                    // aranan yorum
                    // aranan puan toplandı
                    _maxFilteredReviewAvarage += double.parse(reviews[i].puan);
                  }
                 }
                 _maxFilteredReviewAvarage = _maxFilteredReviewAvarage / _maxFilteredReviews.length;
                 //print("MAXFİLTEREDDDDDİM ŞUANNN"+_maxFilteredReviewAvarage.toString());
                 /*if(_puanController.text.trim().length>0 && (_maxFilteredReviewAvarage >  double.parse(_puanController.text)) ){
                  print("ŞART 1 DEYİMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
                  // puan şartı varsa ve ondan büyükse
                   
                    // şartı sağladın şimdi seni 
                    // bunlar gerçek tavsiyelerdir
                    _maxFilteredHospitals.add(_hospitalss[n]);
                 }*/

                 // hastalık puanı eklemek eklensin eğer ondan büyükse veya 3 den büyükse eklensin

                 // eğer hastane puan varsa ve 3 den büyükse ortalama ekledik eğer hastane puan yoksa yorum ort 3 den büyükse 
                 /*if((_puanController.text.trim().length >0) && (_maxFilteredReviewAvarage >  3) && (calculateStar(_hospitalss[n].ad) > double.parse(_puanController.text))){
                  print("ŞART 1 DEYİMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
                  // hastane puan şartımız var artık 
                    _maxFilteredHospitals.add(_hospitalss[n]);
                 }*/
                 
                  if(_puanController.text.trim().length == 0 && _maxFilteredReviewAvarage >  3){
                  //print("ŞART 2 DEYİMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
                  // puan şartı yoksa ve 3 den çoksa default olrak öner
                  // önerimizdir
                    _maxFilteredHospitals.add(_hospitalss[n]);
                    if(isChecked){
      // en yakında seçilmişse
      print("İÇERİ GİRDİM ARKADAŞşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşş");
       _getLocationPermission();
      if(_maxFilteredHospitals.length>0){
        print("İÇERİ GİRDİM ARKADAŞ");
            temper = [];
for(int i=0;i<_maxFilteredHospitals.length;i++){
           haversine(userLatitude,userLongitude,double.parse(_maxFilteredHospitals[i].latitude), double.parse(_maxFilteredHospitals[i].longitude));
          //print("Anlık1" + _maxFilteredHospitals[i].ad + " " + realDistance);
          if( 70 > double.parse(realDistance)){
            print("EklendiiiiBak" + _maxFilteredHospitals[i].ad + " " + realDistance);
            temper.add(_maxFilteredHospitals[i]);
              //_starHospitals.removeAt(i);
               /*setState(() {
          _hospitals.length = _hospitals.length;
        });*/
              //print("Silindi" + _starHospitals[i].ad + " " + realDistance);
          }
          //print(realDistance);
        }
        setState(() {
          _maxFilteredHospitals =  sortHospitalDistance(temper);
        });
          }

    }
                 }
                 else{
                  //print("ŞART 3 DEYİMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
                  // şartı sağlamadın , seni klasik listeye alıyorum hastane
                  _hastalikHospitals.add(_hospitalss[n]);
                  if(isChecked){
      // en yakında seçilmişse
      //print("İÇERİ GİRDİM ARKADAŞşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşş");
       _getLocationPermission();
      if(_hastalikHospitals.length>0){
        print("İÇERİ GİRDİM ARKADAŞ");
            temper = [];
for(int i=0;i<_hastalikHospitals.length;i++){
           haversine(userLatitude,userLongitude,double.parse(_hastalikHospitals[i].latitude), double.parse(_hastalikHospitals[i].longitude));
          //print("Anlık1" + _maxFilteredHospitals[i].ad + " " + realDistance);
          if( 70 > double.parse(realDistance)){//5 km olarak düzeltilecek
            print("EklendiiiiBak" + _hastalikHospitals[i].ad + " " + realDistance);
            temper.add(_hastalikHospitals[i]);
              //_starHospitals.removeAt(i);
               /*setState(() {
          _hospitals.length = _hospitals.length;
        });*/
              //print("Silindi" + _starHospitals[i].ad + " " + realDistance);
          }
          //print(realDistance);
        }
        setState(() {
          _hastalikHospitals = sortHospitalDistance(temper); //temper;
          print("YENİ HAL"+_hastalikHospitals.length.toString());
        });
          }

    }
                 }
                 break;
              }
            }

            // ortalaması alınacak puanControllerdan veya default değerden büyükse tavsiye olucak
            // diğer kalanlar ise Diğer Aramalar olarak aşağıda verilecekler
            
            
            //_maxFilteredReviewAvarage = double.parse(reviews[i].puan) ;
            

          });
          } 
          
         
        print("Hastane adı"+reviews[i].hastane);
      }
    }
    // içerenlerin ortalaması bulundu
    //_maxFilteredReviewAvarage = _maxFilteredReviewAvarage  / _maxFilteredReviews.length;
    
    // adımlar
    // 
    if(isChecked){
      // en yakında seçilmişse
      print("İÇERİ GİRDİM ARKADAŞşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşşş");
      await _getLocationPermission();
      if(_maxFilteredHospitals.length>0){
        print("İÇERİ GİRDİM ARKADAŞ");
            temper = [];
for(int i=0;i<_maxFilteredHospitals.length;i++){
          await haversine(userLatitude,userLongitude,double.parse(_maxFilteredHospitals[i].latitude), double.parse(_maxFilteredHospitals[i].longitude));
          print("Anlık1" + _maxFilteredHospitals[i].ad + " " + realDistance);
          if( 70 > double.parse(realDistance)){
            temper.add(_maxFilteredHospitals[i]);
              //_starHospitals.removeAt(i);
               /*setState(() {
          _hospitals.length = _hospitals.length;
        });*/
              //print("Silindi" + _starHospitals[i].ad + " " + realDistance);
          }
          //print(realDistance);
        }
        setState(() {
          _maxFilteredHospitals = sortHospitalDistance(temper);//temper;
        });
          }

    }
    print("Eldekilerrr"+_hastalikHospitals.length.toString());
  }
  
  mapHastane(QuerySnapshot<Map<String,dynamic>> datas)async{
    final _datas = datas.docs.map((item) =>  Hospital(
      website: item["website"],
      latitude: item["latitude"],
      longitude: item["longitude"],
      foto: item["foto"],tel: item["tel"],ad: item["ad"], adres: item["adres"], id: item.id, 
    ilce: item["ilce"], il: item["il"])).toList();

    setState(() {
      _hospitals = _datas;
      //_hospitalDetector();
      if(_puanController.text.trim().length>0 && _hastalikController.text.trim().length==0){
        _starHospitals = [];
        for(int i=0;i<_hospitals.length;i++){
          if(double.parse(calculateStar(_hospitals[i].ad).toStringAsFixed(1))> double.parse(_puanController.text)){
            _starHospitals.add(_hospitals[i]);
          } 
        }

        /*if(isChecked){
          // konum izni alalım ve ölçümler yapılsın , bu yolla _starHospitals yeniden sıralansın
          await _getLocationPermission();
          for(int i=0;i<_starHospitals.length;i++){
          await haversine(userLatitude,userLongitude,double.parse(_starHospitals[i].latitude), double.parse(_starHospitals[i].longitude));
          print(realDistance);
        }

        }*/
      }
      else if(_puanController.text.trim().length>0 && _hastalikController.text.trim().length > 0){
        _starHospitals = [];
        for(int i=0;i<_hospitals.length;i++){
          if(double.parse(calculateStar(_hospitals[i].ad).toStringAsFixed(1))> double.parse(_puanController.text)){
            _starHospitals.add(_hospitals[i]);
          } 
        }

        // starhospitals verilir
        print("ÇALIŞTIM BABA ELSE İFE");
        print("star hospitaller"+_starHospitals.length.toString());
        hastalikBul(_hastalikController.text.trim(), _starHospitals);
        print(_hastalikHospitals.toString());
      }
      else if(_puanController.text.trim().length == 0 && _hastalikController.text.trim().length > 0){
        // normal hospitals ver
        /*_starHospitals = [];
        for(int i=0;i<_hospitals.length;i++){
          if(double.parse(calculateStar(_hospitals[i].ad).toStringAsFixed(1))> double.parse(_puanController.text)){
            _starHospitals.add(_hospitals[i]);
          } 
        }*/
        hastalikBul(_hastalikController.text.trim(), _hospitals);

      }



    });

    if(isChecked){
          // konum izni alalım ve ölçümler yapılsın , bu yolla _starHospitals yeniden sıralansın
          await _getLocationPermission();
          if(_starHospitals.length>0){
            temper = [];
for(int i=0;i<_starHospitals.length;i++){
          await haversine(userLatitude,userLongitude,double.parse(_starHospitals[i].latitude), double.parse(_starHospitals[i].longitude));
          print("Anlık1" + _starHospitals[i].ad + " " + realDistance);
          if( 70 > double.parse(realDistance)){
            temper.add(_hospitals[i]);
              //_starHospitals.removeAt(i);
               /*setState(() {
          _hospitals.length = _hospitals.length;
        });*/
              print("Silindi" + _starHospitals[i].ad + " " + realDistance);
          }
          //print(realDistance);
        }
        setState(() {
          _starHospitals = sortHospitalDistance(temper);//temper;
        });
          }

          else if(_hastalikHospitals.length>0){
            temper = [];
for(int i=0;i<_hastalikHospitals.length;i++){
          await haversine(userLatitude,userLongitude,double.parse(_hastalikHospitals[i].latitude), double.parse(_hastalikHospitals[i].longitude));
                    print("Anlık2" + _hastalikHospitals[i].ad + " " + realDistance);

          if( 70 > double.parse(realDistance)){
              //_hastalikHospitals.removeAt(i);
              temper.add(_hastalikHospitals[i]);
               /*setState(() {
          _hospitals.length = _hospitals.length;
        });*/
              print("Silindi" + _hastalikHospitals[i].ad + " " + realDistance);
             // print("Silindi");
          }
          //print(realDistance);
        }
        setState(() {
          _hastalikHospitals = sortHospitalDistance(temper);//temper;
          print("ANLIK BUKADAR"+_hastalikHospitals.length.toString()+_hastalikHospitals[0].ad);
        });
          }
          else{
            temper = [];
            for(int i=0;i<_hospitals.length;i++){
          await haversine(userLatitude,userLongitude,double.parse(_hospitals[i].latitude), double.parse(_hospitals[i].longitude));
          print("Anlık3" + _hospitals[i].ad + " " + realDistance);
          if( 70 > double.parse(realDistance)){
              //_hospitals.removeAt(i);
              temper.add(_hospitals[i]);
              /* setState(() {
          _hospitals.length = _hospitals.length;
        });*/
              print("Silindi" + _hospitals[i].ad + " " + realDistance);
              //print("Silindi");
          }
          //print(realDistance);
        }
        setState(() {
          _hospitals = sortHospitalDistance(temper);//temper;
        });
          }


           

        }

        setState(() {
          //_hospitals = temper;
        });
  }
  
  bool _isSearched = false;
  List<Hospital> temper = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchReview();
    fetchUser();
  }


  late final TabController _tabController =
      TabController(length: 2, vsync: this);

  AppUser _currentUser = AppUser(ad: "ad", email: "email", foto: "foto", id: "id", sifre: "sifre", soyad: "soyad", tc: "tc");
  List<AppUser> _users = [];
  Future<void> fetchUser()async{
    var response = await FirebaseFirestore.instance.collection(FirebaseConstants.kullaniciCollection).get();
    mapUser(response);
  }
  
  mapUser(QuerySnapshot<Map<String,dynamic>> datas){
    final _datas = datas.docs.map((item) => 
    AppUser(ad: item["ad"], email: item["email"], foto: item["foto"], id: item.id, 
    sifre: item["sifre"], soyad: item["soyad"], tc: item["tc"])).toList();

    setState(() {
      _users = _datas;
    });
  }

   List<Hospital> _starHospitals = []; 
   //sadece hastalık adını içeren hastaneler
   List<Hospital> _hastalikHospitals = [];
   //hem hastalık adını içeren verilen hemde puanın üstünde olan olmazsa default 3 üstünde olan
   List<Hospital> _maxFilteredHospitals = [];
   String calculateReviews(String hospitalName){
     double reviewNew = 0;
     int counter = 0;
      for(int i=0;i<reviews.length;i++){
        if(hospitalName == reviews[i].hastane){// değerlendirme hastane adı ve girilen eşitse topla
          //reviewNew = reviewNew + double.parse(reviews[i].puan);
          counter ++;
        }
      }
      
      return (arangeReview(counter).toString());
  }

  List<Review> reviews = [];
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

    setState(() {
      reviews = _datas;
    });
  }

  double calculateStar(String hospitalName){
     double reviewNew = 0;
     double counter = 0;
      for(int i=0;i<reviews.length;i++){
        if(hospitalName == reviews[i].hastane){// değerlendirme hastane adı ve girilen eşitse topla
          reviewNew = reviewNew + double.parse(reviews[i].puan);
          counter ++;
        }
      }
      
      return counter==0 ? 5.0 : (reviewNew/counter);
  }
  bool _isLoading = false;
     int oneStar = 0;
     int twoStar = 0;
     int threeStar = 0;
     int fourStar = 0;
     int fiveStar = 0;
  calculateStars(Hospital hospitale){
    setState(() {
                          for(int i=0;i<reviews.length;i++){

                      if(hospitale.ad == reviews[i].hastane){
                        setState(() {
                        if(reviews[i].puan == "1.0"){
                          oneStar++;
                        }
                        else if(reviews[i].puan == "2.0"){
                          twoStar++;
                        }
                        else if(reviews[i].puan == "3.0"){
                          threeStar++;
                        }
                        else if(reviews[i].puan == "4.0"){
                          fourStar++;
                        }
                        else if(reviews[i].puan == "5.0"){
                          fiveStar++;
                        }
                      });

        }   
                    }
    });

  }

  String realDistance = "";
  // mesafe bazlı hesaplamalar
  double haversine(double lat1, double lon1, double lat2, double lon2) {
  // Dünya yarıçapı (km)
  const double R = 6371.0;

  // Latitude ve longitude değerlerini radian cinsine dönüştür
  lat1 = _toRadians(lat1);
  lon1 = _toRadians(lon1);
  lat2 = _toRadians(lat2);
  lon2 = _toRadians(lon2);

  // Haversine formülü
  double dlat = lat2 - lat1;
  double dlon = lon2 - lon1;
  double a = pow(sin(dlat / 2), 2) +
      cos(lat1) * cos(lat2) * pow(sin(dlon / 2), 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  // Mesafeyi hesapla
  double distance = R * c;
  setState(() {
    realDistance = distance.toString();
  });

  return distance;
}

double _toRadians(double degree) {
  return degree * (pi / 180.0);
}



// konum izinleri ve anlık konum çekilmesi

// önce konum çekilmeli

  double userLatitude = 0;
  double userLongitude = 0;

  _getLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      print("Konum izni reddedildi");
    } else if (permission == LocationPermission.deniedForever) {
      print("Konum izni kalıcı olarak reddedildi");
    } else {
      print("Konum izni sağlandı");
      _getLocation();
    }
  }
  _getLocation() async {
    try {
      // Geolocator paketini kullanarak konumu al
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Konumu ekrana yazdır
      setState(() {
        userLatitude = position.latitude;
        userLongitude = position.longitude;
      });
    } catch (e) {
      print("Hata: $e");
    }
  }
  

  List<double> distances = [];
  // hastaneler sıralanmalı ve 
  List<Hospital> sortHospitalDistance(List<Hospital> newHospitals){
    distances = [];
    print("GİREN BÜYÜKLÜK"+newHospitals.length.toString());
    // temper içinde gezilsin
    /*for(int i=0;i<newHospitals.length;i++){
      print("HASTANE İLK HAL"+newHospitals[i].ad);
    }*/
    if(newHospitals.length>1 ){
      // iç içe for olmalı
      for(int i=0;i<newHospitals.length;i++){


for(int k=i;k<newHospitals.length-1;k++){

if(haversine(userLatitude, userLongitude, double.parse(newHospitals[i].latitude), double.parse(newHospitals[i].longitude))
       > haversine(userLatitude, userLongitude, double.parse(newHospitals[k+1].latitude), double.parse(newHospitals[k+1].longitude))){

       setState(() {
        print("Uzaklık büyük :"+ "Hastane ${newHospitals[i].ad}"
        +haversine(userLatitude, userLongitude, double.parse(newHospitals[i].latitude), double.parse(newHospitals[i].longitude)).toString()
        
        +
        "Uzaklık küçük :" + "Hastane ${newHospitals[k+1].ad}"
        +haversine(userLatitude, userLongitude, double.parse(newHospitals[k+1].latitude), double.parse(newHospitals[k+1].longitude)).toString()
        );
       Hospital temp = newHospitals[i];
       newHospitals[i] = newHospitals[k+1];
       newHospitals[k+1] = temp;
       });

      }

}

      
    }
    /*for(int i=0;i<newHospitals.length;i++){
      print("HASTANE KÜÇÜKTEN BÜYÜĞE"+newHospitals[i].ad);
    }*/
    for(int i=0;i<newHospitals.length;i++){
      setState(() {
        distances.add(haversine(userLatitude, userLongitude, double.parse(newHospitals[i].latitude), double.parse(newHospitals[i].longitude)));
      });
    }
    
    return newHospitals;
    }
    else{
      // işlemsiz döndür
    return newHospitals;
    }

  }

  // küçükten büyüğe olarak
  List<double> hospitalDistances = [];
  bool isChecked = false;

  // return distance color
  Color distanceColor(double distance){
    if(distance<70 && 35<=distance){
      return Colors.red;
    }
    else if(distance < 35 && distance > 10){
      return Colors.yellow;
    }
    else{
      return Colors.green;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,
    title:  AppText.appText("Arama", 17, Colors.white,FontWeight.normal),
    backgroundColor: Colors.red,),
      body: SingleChildScrollView(
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /*

CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text("En yakın hastaneler"),
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value!;
                });
              },
            ),

            */

              Center(
              child: Container(
                //decoration: BoxDecoration(border: ),
                width: MediaQuery.of(context).size.width*0.98,
                height: _isExpanded ?  MediaQuery.of(context).size.height*0.4 : MediaQuery.of(context).size.height*0.18,
                child: Card(
                  //elevation: 20,
                  color: Color.fromARGB(255, 249, 244, 244),
                  child: Container(width: MediaQuery.of(context).size.width*1,
                  height: MediaQuery.of(context).size.height*0.2,
                  child: Column(
                    children: [
                      SizedBoxHeight(height: 0.01),
                  
                      Row(
                        children: [
                          Container(margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.04,right: MediaQuery.of(context).size.width*0.01),
                            width: MediaQuery.of(context).size.width*0.7,
                            height: MediaQuery.of(context).size.height*0.06,
                            child: TextFormField(
                                        decoration: InputDecoration(
                                          label: Text("İl"),
                                          //hintText: "İl",
                                          enabledBorder: OutlineInputBorder(
                                            
                                borderSide:
                            BorderSide(width: 2, color: Colors.black38), //<-- SEE HERE
                                borderRadius: BorderRadius.circular(5.0),
                                        
                                
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:  BorderSide(
                                        color: Colors.black,
                                        width: 2,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                        color: Colors.redAccent,
                                        width: 2,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              )),
                              
                                        controller: _ilController,
                                        validator: (value){
                                          /*if(value == null || value.isEmpty){
                                            return 'Yeni Şifre girilmelidir';
                                          }
                                          
                                          if(value.length<6){
                                            return 'Şifre en az 6 hane olmalıdır';
                                          }*/
                                        },
                                      ),
                          ),
                  
                          Container(
                              width: MediaQuery.of(context).size.width*0.16,
                              height: MediaQuery.of(context).size.height*0.07,
                            child: IconButton(onPressed: ()async{    

                              // radio button veya checkbox eklenecek eğer seçildiyse 5km uzaklık altı eklenecek ve büyükten küçüğe sıralanacak

                                setState(() {
                                  distances = [];
                                  _hastalikHospitals = [];
                                  _maxFilteredHospitals = [];
                                  _hospitals = [];
                                  _starHospitals = [];
                                  _isSearched = true;
                                  _isLoading = true;
                                });
                                if((_ilController.text.trim().length>0 && _ilceController.text.trim().length>0)){
                                  print("BURADAYIMMMMMMMMMM BABUŞ");
                                  await fetchHastanewithilceandil(_ilController.text.toLowerCase().trim(), _ilceController.text.toLowerCase().trim());
                                }
                                else if(_ilController.text.length>0){
                                  await fetchHastanewithil(_ilController.text.toLowerCase().trim());
                                }
                                else if(_ilceController.text.trim().length>0){
                                  await fetchHastanewithilce(_ilceController.text.toLowerCase().trim());
                                  print("BURADAYIMMMMMMMMMM BABİTO");
                                }
                                else if(_ilceController.text.trim().length == 0 && _ilController.text.trim().length == 0){
                                  await fetchHastaneWithNoilandilce();
                                }
                                /*if(_ilController.text.trim().length>0){
                                 fetchHastanewithil(_ilController.text.toLowerCase().trim());
                                 //_hospitals = [];
                                }*/
                                  
                                  setState(() {
                                    if(_hospitals.length>0){
                                    _isLoading = false;
                                    }
                                    else{
                                      _isLoading = true;
                                    }
                                  });
        
                                
                                //fetchHastane();
                              }, icon: Icon(Icons.search)),
                          )
                        ],
                      ),
                      SizedBoxHeight(height: 0.01),
                      
                      Row(
                        children: [
                          Container(margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.04,right: MediaQuery.of(context).size.width*0.01),
                            width: MediaQuery.of(context).size.width*0.7,
                            height: MediaQuery.of(context).size.height*0.06,
                            child: TextFormField(
                                        decoration: InputDecoration(
                                          label: Text("İlçe"),
                                          //hintText: "İl",
                                          enabledBorder: OutlineInputBorder(
                                            
                                borderSide:
                            BorderSide(width: 2, color: Colors.black38), //<-- SEE HERE
                                borderRadius: BorderRadius.circular(5.0),
                                        
                                
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:  BorderSide(
                                        color: Colors.black,
                                        width: 2,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                        color: Colors.redAccent,
                                        width: 2,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              )),
                              
                                        controller: _ilceController,
                                        validator: (value){
                                          /*if(value == null || value.isEmpty){
                                            return 'Yeni Şifre girilmelidir';
                                          }
                                          
                                          if(value.length<6){
                                            return 'Şifre en az 6 hane olmalıdır';
                                          }*/
                                        },
                                      ),
                          ),
              
              
                          Container(
                              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05),
                              width: _isExpanded ? MediaQuery.of(context).size.width*0.06 : MediaQuery.of(context).size.width*0.06,
                              
                              height: _isExpanded ? MediaQuery.of(context).size.height*0.026 : MediaQuery.of(context).size.height*0.03,
                            child: InkWell(
                              onTap: (){
                                setState(() {
                                  _isExpanded = !_isExpanded;
                                });
                              },
                              child: _isExpanded ? Image.asset("assets/filter.png") : Image.asset("assets/setting.png"),
                            ),
                          )
                        ],
                      ),
        
        
        
        
                      _isExpanded ? Column(
                        children: [
                          SizedBoxHeight(height: 0.016),
                          
                          Container(margin: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.18),
                                width: MediaQuery.of(context).size.width*0.7,
                                height: MediaQuery.of(context).size.height*0.06,
                                child: TextFormField(
                                            decoration: InputDecoration(
                                              label: Text("Hastalık veya Poliklinik"),
                                              //hintText: "İl",
                                              enabledBorder: OutlineInputBorder(
                                                
                                    borderSide:
                                BorderSide(width: 2, color: Colors.black38), //<-- SEE HERE
                                    borderRadius: BorderRadius.circular(5.0),
                                            
                                    
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:  BorderSide(
                                            color: Colors.black,
                                            width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                            color: Colors.redAccent,
                                            width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  )),
                                  
                                            controller: _hastalikController,
                                            validator: (value){
                                              /*if(value == null || value.isEmpty){
                                                return 'Yeni Şifre girilmelidir';
                                              }
                                              
                                              if(value.length<6){
                                                return 'Şifre en az 6 hane olmalıdır';
                                              }*/
                                            },
                                          ),
                              ),
                              SizedBoxHeight(height: 0.016),
                        ],
                      ) 
                          :
                          SizedBox.shrink() ,
        
        
                          _isExpanded ? Column(
                        children: [
                          Container(margin: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.54),
                                width: MediaQuery.of(context).size.width*0.34,
                                height: MediaQuery.of(context).size.height*0.06,
                                child: TextFormField(
                                            decoration: InputDecoration(
                                              label: Text("Hastane Puan"),
                                              //hintText: "İl",
                                              enabledBorder: OutlineInputBorder(
                                                
                                    borderSide:
                                BorderSide(width: 2, color: Colors.black38), //<-- SEE HERE
                                    borderRadius: BorderRadius.circular(5.0),
                                            
                                    
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:  BorderSide(
                                            color: Colors.black,
                                            width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                            color: Colors.redAccent,
                                            width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  )),
                                  
                                            controller: _puanController,
                                            validator: (value){
                                              /*if(value == null || value.isEmpty){
                                                return 'Yeni Şifre girilmelidir';
                                              }
                                              
                                              if(value.length<6){
                                                return 'Şifre en az 6 hane olmalıdır';
                                              }*/
                                            },
                                          ),
                              ),
                              SizedBoxHeight(height: 0.006),

                              CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text("En yakın hastaneler"),
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value!;
                });
              },
            ),
                        ],
                      ) 
                          :
                          SizedBox.shrink(),
        
        
                          // eğer filtreleme varsa başka gelicek hastaneler yoksa başka
        
                         
        
        
        
                      
                    ],
                  ),),
                ),
              ),
            ),
        
             (_hastalikController.text == "" && _puanController.text == "") && _isSearched ?
        
                          Container(
                              //margin: EdgeInsets.only(top: _isExpanded ? MediaQuery.of(context).size.height*0.2 : 0),                            
                              child: Column(
                                //mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBoxHeight(height: 0.02),
                                Container(
                                  margin: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.55),child: AppText.appText("Arama Sonuçları", 17, Colors.black54,FontWeight.normal),),
                                
                                
                                 _isLoading  ? Container(margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.3),child: CircularProgressIndicator())  : 
                                 ListView.builder(
                                   physics: ScrollPhysics(),
                                   shrinkWrap: true,
                                 itemCount: _hospitals.length,itemBuilder: (context,index){
                                     return Container(
                                           height: MediaQuery.of(context).size.height*0.14,
                                           width: MediaQuery.of(context).size.width*0.8,
                                           child: 
                                           GestureDetector(
                                             onTap: () async{
                                              //print("UZAKLIĞI : " + distances[index].toStringAsFixed(2));
                                              await calculateStars(_hospitals[index]);
                                               for(int i=0;i<_users.length;i++){
                                                  //print("HAHA"+_users[i].email);
                                                 if(_users[i].email == FirebaseAuth.instance.currentUser!.email.toString()){
                                                  
                                                  setState(() {
                                                    _currentUser = _users[i];
                                                  });
                                   
                                                 }
                                               }
                                               //await fetchFavorite();
                                               await fetchLike();
                    
                                               

                                               Navigator.push(context, 
                                               MaterialPageRoute(builder: (context) => HospitalDetailView(
                                                fiveStar: fiveStar.toDouble(),
                                                fourStar: fourStar.toDouble(),
                                                oneStar: oneStar.toDouble(),
                                                threeStar: threeStar.toDouble(),
                                                twoStar: twoStar.toDouble(),
                                                likes: _likes,
                                                 docId: _currentUser.id,
                                                 users: _users,
                                                 reviews: int.parse(calculateReviews(_hospitals[index].ad)),
                                                 avarageStar: calculateStar(_hospitals[index].ad),
                                                 hospital: _hospitals[index],
                                                 appUser: _currentUser,
                                                 pageCode: 1,
                                                 //favorites: _favorites,
                                                 )));
                                             },
                                             child: Card(elevation: 5,color: Colors.white,
                                             child: Row(children: [
                                             
                                               Container(
                                               /*decoration: BoxDecoration(
                                                 border: Border.all(width: 1,)),*/
                                                 margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.04,
                                                 right: MediaQuery.of(context).size.width*0.02),width: MediaQuery.of(context).size.width*0.28,
                                                 height: MediaQuery.of(context).size.height*0.1,child:
                                                 ClipPath(
                                                   clipper: ShapeBorderClipper(shape: 
                                                   RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                                                   child: Image.asset(fit: BoxFit.cover,_hospitals[index].foto))),
                                             
                                               Column(
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 children: [
                                                   Row(
                                                             children: [
                                                               Container(
                                                              /*   decoration: BoxDecoration(border: Border.all(width: 1
                                                               )),*/
                                                               height: MediaQuery.of(context).size.height*0.03,
                                                               width: MediaQuery.of(context).size.width*0.4,margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.023),
                                                               child: Text(clipText(_hospitals[index].ad,19),style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Poppins-Regular'),)),
                                             
                                                               Container(
                                                                 margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.023),
                                                                 /*decoration: BoxDecoration(border: Border.all(width: 1
                                                                 )),*/width: MediaQuery.of(context).size.width*0.2,height: MediaQuery.of(context).size.height*0.03,
                                                                 child: Row(children: [
                                 Icon(Icons.star,size: 20,color: Colors.amber,),
                                 Text("${calculateStar(_hospitals[index].ad).toStringAsFixed(1)}",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Poppins-Regular'),),
                                 Text(" "),
                                 Text("(${calculateReviews(_hospitals[index].ad)}+)",style: TextStyle(color: Colors.black54,fontSize: 12,fontFamily: 'Poppins-Regular'))]),)
                                 //                              Text("( ${int.parse(calculateReviews(hospitals[index].ad)) != 0  ? calculateReviews(hospitals[index].ad)+"+" : "0"} )",style: TextStyle(color: Colors.black54,fontSize: 12,fontFamily: 'Poppins-Regular'))]),)
                                   
                                                             ],
                                                   ),
                                                  
                                                  
                                                  distances.length>0 ?
                                                  Row(
                                                    children: [
                                                      Container(
                                                       /*decoration: BoxDecoration(border: Border.all(width: 1
                                                       )),*/
                                                       height: MediaQuery.of(context).size.height*0.05,
                                                       width: MediaQuery.of(context).size.width*0.43,margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.004),
                                                       child: 
                                                       Text(clipText(_hospitals[index].adres, _hospitals[index].adres.length),
                                                       style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.black54),)),
                                                       Container(
                                                        width: context.getWidth*0.2,
                                                        height: context.getHeight*0.06,
                                                         child: Card(
                                                          color: distanceColor(distances[index]),elevation: 10,
                                                         child: Center(child: AppText.appText(distances[index].toStringAsFixed(2)+"  km", 13, Colors.white, FontWeight.bold)//Text(distances[index].toStringAsFixed(2)+"  km")
                                                         ),),
                                                       )
                                                    ],
                                                  )
                                                 
                                                   :
                                                    Container(
                                                   decoration: BoxDecoration(border: Border.all(width: 1
                                                   )),
                                                   height: MediaQuery.of(context).size.height*0.05,
                                                   width: MediaQuery.of(context).size.width*0.53,margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.004),
                                                   child: 
                                                   Text(clipText(_hospitals[index].adres, _hospitals[index].adres.length),
                                                   style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.black54),))
                                                 ],

                                               )
                                             ]),),
                                           )
                                         );
                                 },)
                              ],
                            ),
                          )
                          /*FutureBuilder(future: FirebaseFirestore.instance.collection("hastane").get(), 
                          builder: ((context, snapshot) {
                            if(snapshot.hasData){
                              Text("Hastane");
                            }
                            else if(snapshot.hasError){
                              print("HATAMIZ:"+snapshot.error.toString());
                            }
                            return CircularProgressIndicator();
                          }))*/
                          :

                          (_hastalikController.text == "" && _puanController.text.trim() != "") && _isSearched ?

                          Container(
                              //margin: EdgeInsets.only(top: _isExpanded ? MediaQuery.of(context).size.height*0.2 : 0),                            
                              child: Column(
                              children: [
                                SizedBoxHeight(height: 0.02),
                                Container(
                                  margin: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.55),child: AppText.appText("Arama Sonuçları", 17, Colors.black54,FontWeight.normal),),
                                
                                
                                 _isLoading  ? Container(margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.3),child: Indicator.circularProgressIndicator())  : 
                                 ListView.builder(
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                 itemCount: _starHospitals.length,itemBuilder: (context,index){
                                     return Container(
                                           height: MediaQuery.of(context).size.height*0.14,
                                           width: MediaQuery.of(context).size.width*0.8,
                                           child: 
                                           GestureDetector(
                                             onTap: () async{
                                              //print("UZAKLIĞI : " + distances[index].toStringAsFixed(2));
                                               await calculateStars(_starHospitals[index]);
                                               for(int i=0;i<_users.length;i++){
                                                  //print("HAHA"+_users[i].email);
                                                 if(_users[i].email == FirebaseAuth.instance.currentUser!.email.toString()){
                                                  
                                                  setState(() {
                                                    _currentUser = _users[i];
                                                  });
                                   
                                                 }
                                               }
                                               //await fetchFavorite();

                      

                                               Navigator.push(context, 
                                               MaterialPageRoute(builder: (context) => HospitalDetailView(
                                                 fiveStar: fiveStar.toDouble(),
                                                 fourStar: fourStar.toDouble(),
                                                 oneStar: oneStar.toDouble(),
                                                 threeStar: threeStar.toDouble(),
                                                 twoStar: twoStar.toDouble(),
                                                 docId: _currentUser.id,
                                                 users: _users,
                                                 reviews: int.parse(calculateReviews(_starHospitals[index].ad)),
                                                 avarageStar: calculateStar(_starHospitals[index].ad),
                                                 hospital: _starHospitals[index],
                                                 appUser: _currentUser,
                                                 pageCode: 1,
                                                 //favorites: _favorites,
                                                 )));
                                             },
                                             child: Card(elevation: 5,color: Colors.white,
                                             child: Row(children: [
                                             
                                               Container(
                                               /*decoration: BoxDecoration(
                                                 border: Border.all(width: 1,)),*/
                                                 margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.04,
                                                 right: MediaQuery.of(context).size.width*0.02),width: MediaQuery.of(context).size.width*0.28,
                                                 height: MediaQuery.of(context).size.height*0.1,child:
                                                 ClipPath(
                                                   clipper: ShapeBorderClipper(shape: 
                                                   RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                                                   child: Image.asset(fit: BoxFit.cover,_starHospitals[index].foto))),
                                             
                                               Column(
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 children: [
                                                   Row(
                                                             children: [
                                                               Container(
                                                              /*   decoration: BoxDecoration(border: Border.all(width: 1
                                                               )),*/
                                                               height: MediaQuery.of(context).size.height*0.03,
                                                               width: MediaQuery.of(context).size.width*0.4,margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.023),
                                                               child: Text(clipText(_starHospitals[index].ad,19),style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Poppins-Regular'),)),
                                             
                                                               Container(
                                                                 margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.023),
                                                                 /*decoration: BoxDecoration(border: Border.all(width: 1
                                                                 )),*/width: MediaQuery.of(context).size.width*0.2,height: MediaQuery.of(context).size.height*0.03,
                                                                 child: Row(children: [
                                 Icon(Icons.star,size: 20,color: Colors.amber,),
                                 Text("${calculateStar(_starHospitals[index].ad).toStringAsFixed(1)}",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Poppins-Regular'),),
                                 Text(" "),
                                 Text("(${calculateReviews(_starHospitals[index].ad)}+)",style: TextStyle(color: Colors.black54,fontSize: 12,fontFamily: 'Poppins-Regular'))]),)
                                 //                              Text("( ${int.parse(calculateReviews(hospitals[index].ad)) != 0  ? calculateReviews(hospitals[index].ad)+"+" : "0"} )",style: TextStyle(color: Colors.black54,fontSize: 12,fontFamily: 'Poppins-Regular'))]),)
                                   
                                                             ],
                                                   ),

                                                   distances.length>0 ?
                                                  Row(
                                                    children: [
                                                      Container(
                                                       /*decoration: BoxDecoration(border: Border.all(width: 1
                                                       )),*/
                                                       height: MediaQuery.of(context).size.height*0.05,
                                                       width: MediaQuery.of(context).size.width*0.43,margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.004),
                                                       child: 
                                                       Text(clipText(_starHospitals[index].adres, _starHospitals[index].adres.length),
                                                       style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.black54),)),
                                                       Container(
                                                        width: context.getWidth*0.2,
                                                        height: context.getHeight*0.06,
                                                         child: Card(
                                                          color: distanceColor(distances[index]),elevation: 10,
                                                         child: Center(child: AppText.appText(distances[index].toStringAsFixed(2)+"  km", 13, Colors.white, FontWeight.bold)//Text(distances[index].toStringAsFixed(2)+"  km")
                                                         ),),
                                                       )
                                                    ],
                                                  )
                                                 
                                                   :
                                                    Container(
                                                   decoration: BoxDecoration(border: Border.all(width: 1
                                                   )),
                                                   height: MediaQuery.of(context).size.height*0.05,
                                                   width: MediaQuery.of(context).size.width*0.53,margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.004),
                                                   child: 
                                                   Text(clipText(_starHospitals[index].adres, _starHospitals[index].adres.length),
                                                   style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.black54),))
                                                  
                                                   /*Container(
                                                   decoration: BoxDecoration(border: Border.all(width: 1
                                                   )),
                                                   height: MediaQuery.of(context).size.height*0.05,
                                                   width: MediaQuery.of(context).size.width*0.53,margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.004),
                                                   child: Text(clipText(_starHospitals[index].adres, _starHospitals[index].adres.length),style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.black54),)),
                                                */
                                                
                                                 ],
                                               )
                                             ]),),
                                           )
                                         );
                                 },)
                              ],
                            ),
                          )

                          :


                          (_hastalikController.text.trim().length >0 ) && _isSearched ?
                          // tavsiyeler ve hastalık harici şartı sağlayanlar olarak dönsün
                          Container(
                              //margin: EdgeInsets.only(top: _isExpanded ? MediaQuery.of(context).size.height*0.2 : 0),                            
                              child: Column(
                              children: [

                                SizedBoxHeight(height: 0.02),

                                _isLoading == false && _maxFilteredHospitals.length == 0 ?
                                SizedBox.shrink()
                                :
                                Container(
                                  margin: 
                                  EdgeInsets.only(right: MediaQuery.of(context).size.width*0.67),
                                  child:  AppText.appText("Önerilenler", 17, Colors.black54,FontWeight.normal),),
                                
                                 
                                 _isLoading  ? Container(margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.3),child: CircularProgressIndicator())  
                                 
                                 :
                                 _isLoading == false && _maxFilteredHospitals.length == 0 ?
                                  SizedBox.shrink()
                                 //Container(margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.3),child: Text("Bulunamadı"))
                                 : 
                                 ListView.builder(
                                   physics: ScrollPhysics(),
                                   shrinkWrap: true,
                                 itemCount: _maxFilteredHospitals.length,itemBuilder: (context,index){
                                     return Container(
                                           height: MediaQuery.of(context).size.height*0.14,
                                           width: MediaQuery.of(context).size.width*0.8,
                                           child: 
                                           GestureDetector(
                                             onTap: () async{
                                              //print("UZAKLIĞI : " + distances[index].toStringAsFixed(2));
                                              await calculateStars(_maxFilteredHospitals[index]);
                                              for(int i=0;i<_users.length;i++){
                                                  //print("HAHA"+_users[i].email);
                                                 if(_users[i].email == FirebaseAuth.instance.currentUser!.email.toString()){
                                                  
                                                  setState(() {
                                                    _currentUser = _users[i];
                                                  });
                                   
                                                 }
                                               }
                                               //await fetchFavorite();
                                              


                                               Navigator.push(context, 
                                               MaterialPageRoute(builder: (context) => HospitalDetailView(
                                                 fiveStar: fiveStar.toDouble(),
                                                 fourStar: fourStar.toDouble(),
                                                 oneStar: oneStar.toDouble(),
                                                 threeStar: threeStar.toDouble(),
                                                 twoStar: twoStar.toDouble(),
                                                 docId: _currentUser.id,
                                                 users: _users,
                                                 reviews: int.parse(calculateReviews(_maxFilteredHospitals[index].ad)),
                                                 avarageStar: calculateStar(_maxFilteredHospitals[index].ad),
                                                 hospital: _maxFilteredHospitals[index],
                                                 appUser: _currentUser,
                                                 pageCode: 1,
                                                 //favorites: _favorites,
                                                 )));
                                             },
                                             child: Card(elevation: 5,color: Colors.white,
                                             child: Row(children: [
                                             
                                               Container(
                                               /*decoration: BoxDecoration(
                                                 border: Border.all(width: 1,)),*/
                                                 margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.04,
                                                 right: MediaQuery.of(context).size.width*0.02),width: MediaQuery.of(context).size.width*0.28,
                                                 height: MediaQuery.of(context).size.height*0.1,child:
                                                 ClipPath(
                                                   clipper: ShapeBorderClipper(shape: 
                                                   RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                                                   child: Image.asset(fit: BoxFit.cover,_maxFilteredHospitals[index].foto))),
                                             
                                               Column(
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 children: [
                                                   Row(
                                                             children: [
                                                               Container(
                                                              /*   decoration: BoxDecoration(border: Border.all(width: 1
                                                               )),*/
                                                               height: MediaQuery.of(context).size.height*0.03,
                                                               width: MediaQuery.of(context).size.width*0.4,margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.023),
                                                               child: Text(clipText(_maxFilteredHospitals[index].ad,19),style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Poppins-Regular'),)),
                                             
                                                               Container(
                                                                 margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.023),
                                                                 /*decoration: BoxDecoration(border: Border.all(width: 1
                                                                 )),*/width: MediaQuery.of(context).size.width*0.2,height: MediaQuery.of(context).size.height*0.03,
                                                                 child: Row(children: [
                                 Icon(Icons.star,size: 20,color: Colors.amber,),
                                 Text("${calculateStar(_maxFilteredHospitals[index].ad).toStringAsFixed(1)}",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Poppins-Regular'),),
                                 Text(" "),
                                 Text("(${calculateReviews(_maxFilteredHospitals[index].ad)}+)",style: TextStyle(color: Colors.black54,fontSize: 12,fontFamily: 'Poppins-Regular'))]),)
                                 //                              Text("( ${int.parse(calculateReviews(hospitals[index].ad)) != 0  ? calculateReviews(hospitals[index].ad)+"+" : "0"} )",style: TextStyle(color: Colors.black54,fontSize: 12,fontFamily: 'Poppins-Regular'))]),)
                                   
                                                             ],
                                                   ),
                                                  
                                                  distances.length>0 ?
                                                  Row(
                                                    children: [
                                                      Container(
                                                       /*decoration: BoxDecoration(border: Border.all(width: 1
                                                       )),*/
                                                       height: MediaQuery.of(context).size.height*0.05,
                                                       width: MediaQuery.of(context).size.width*0.43,margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.004),
                                                       child: 
                                                       Text(clipText(_maxFilteredHospitals[index].adres, _maxFilteredHospitals[index].adres.length),
                                                       style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.black54),)),
                                                       Container(
                                                        width: context.getWidth*0.2,
                                                        height: context.getHeight*0.06,
                                                         child: Card(
                                                          color: distanceColor(distances[index]),elevation: 10,
                                                         child: Center(child: AppText.appText(distances[index].toStringAsFixed(2)+"  km", 13, Colors.white, FontWeight.bold)//Text(distances[index].toStringAsFixed(2)+"  km")
                                                         ),),
                                                       )
                                                    ],
                                                  )
                                                 
                                                   :
                                                    Container(
                                                   decoration: BoxDecoration(border: Border.all(width: 1
                                                   )),
                                                   height: MediaQuery.of(context).size.height*0.05,
                                                   width: MediaQuery.of(context).size.width*0.53,margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.004),
                                                   child: 
                                                   Text(clipText(_maxFilteredHospitals[index].adres, _maxFilteredHospitals[index].adres.length),
                                                   style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.black54),))
                                                   
                                                   /*Container(
                                                   decoration: BoxDecoration(border: Border.all(width: 1
                                                   )),
                                                   height: MediaQuery.of(context).size.height*0.05,
                                                   width: MediaQuery.of(context).size.width*0.53,margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.004),
                                                   child: Text(clipText(_maxFilteredHospitals[index].adres, _maxFilteredHospitals[index].adres.length),style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.black54),)),
                                                 
                                                 */
                                                 
                                                 ],
                                               )
                                             ]),),
                                           )
                                         );
                                 },),



                                  _isLoading == false && _hastalikHospitals.length == 0 ?
                                SizedBox.shrink()
                                :
                                _isLoading == false && _hastalikHospitals.length > 0 ?
                                Container(
                                  margin: 
                                   EdgeInsets.only(right: _maxFilteredHospitals.length>0 ? MediaQuery.of(context).size.width*0.6 
                                   : MediaQuery.of(context).size.width*0.55),
                                  child:  _maxFilteredHospitals.length>0 ? AppText.appText("Diğer Sonuçlar", 17, Colors.black54,FontWeight.normal)
                                  : AppText.appText("Arama Sonuçları", 17, Colors.black54,FontWeight.normal),)
                                  :

                                  SizedBox.shrink(),



                                  _isLoading  ? Container(margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.3),child: Indicator.circularProgressIndicator())  
                                 
                                 :
                                 _isLoading == false && _hastalikHospitals.length == 0 ?
                                 
                                 SizedBox.shrink()
                                 : 
                                 ListView.builder(
                                 physics: ScrollPhysics(),
                                 shrinkWrap: true,
                                 itemCount: _hastalikHospitals.length,itemBuilder: (context,index){
                                     return Container(
                                           height: MediaQuery.of(context).size.height*0.14,
                                           width: MediaQuery.of(context).size.width*0.8,
                                           child: 
                                           GestureDetector(
                                             onTap: () async{
                                              //print("UZAKLIĞI : " + distances[index].toStringAsFixed(2));
                                               await calculateStars(_hastalikHospitals[index]);
                                               for(int i=0;i<_users.length;i++){
                                                  //print("HAHA"+_users[i].email);
                                                 if(_users[i].email == FirebaseAuth.instance.currentUser!.email.toString()){
                                                  
                                                  setState(() {
                                                    _currentUser = _users[i];
                                                  });
                                   
                                                 }
                                               }
                                               //await fetchFavorite();
                                    
                                    

                                               Navigator.push(context, 
                                               MaterialPageRoute(builder: (context) => HospitalDetailView(
                                                 fiveStar: fiveStar.toDouble(),
                                                 fourStar: fourStar.toDouble(),
                                                 oneStar: oneStar.toDouble(),
                                                 threeStar: threeStar.toDouble(),
                                                 twoStar: twoStar.toDouble(),
                                                 docId: _currentUser.id,
                                                 users: _users,
                                                 reviews: int.parse(calculateReviews(_hastalikHospitals[index].ad)),
                                                 avarageStar: calculateStar(_hastalikHospitals[index].ad),
                                                 hospital: _hastalikHospitals[index],
                                                 appUser: _currentUser,
                                                 pageCode: 1,
                                                 //favorites: _favorites,
                                                 )));
                                 
                                             },
                                             child: Card(elevation: 5,color: Colors.white,
                                             child: Row(children: [
                                             
                                               Container(
                                               /*decoration: BoxDecoration(
                                                 border: Border.all(width: 1,)),*/
                                                 margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.04,
                                                 right: MediaQuery.of(context).size.width*0.02),width: MediaQuery.of(context).size.width*0.28,
                                                 height: MediaQuery.of(context).size.height*0.1,child:
                                                 ClipPath(
                                                   clipper: ShapeBorderClipper(shape: 
                                                   RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                                                   child: Image.asset(fit: BoxFit.cover,_hastalikHospitals[index].foto))),
                                             
                                               Column(
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 children: [
                                                   Row(
                                                             children: [
                                                               Container(
                                                              /*   decoration: BoxDecoration(border: Border.all(width: 1
                                                               )),*/
                                                               height: MediaQuery.of(context).size.height*0.03,
                                                               width: MediaQuery.of(context).size.width*0.4,margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.023),
                                                               child: Text(clipText(_hastalikHospitals[index].ad,19),style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Poppins-Regular'),)),
                                             
                                                               Container(
                                                                 margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.023),
                                                                 /*decoration: BoxDecoration(border: Border.all(width: 1
                                                                 )),*/width: MediaQuery.of(context).size.width*0.2,height: MediaQuery.of(context).size.height*0.03,
                                                                 child: Row(children: [
                                 Icon(Icons.star,size: 20,color: Colors.amber,),
                                 Text("${calculateStar(_hastalikHospitals[index].ad).toStringAsFixed(1)}",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Poppins-Regular'),),
                                 Text(" "),
                                 Text("(${calculateReviews(_hastalikHospitals[index].ad)}+)",style: TextStyle(color: Colors.black54,fontSize: 12,fontFamily: 'Poppins-Regular'))]),)
                                 //                              Text("( ${int.parse(calculateReviews(hospitals[index].ad)) != 0  ? calculateReviews(hospitals[index].ad)+"+" : "0"} )",style: TextStyle(color: Colors.black54,fontSize: 12,fontFamily: 'Poppins-Regular'))]),)
                                   
                                                             ],
                                                   ),
                                                  
                                                 
                                                 distances.length>0 ?
                                                  Row(
                                                    children: [
                                                      Container(
                                                       /*decoration: BoxDecoration(border: Border.all(width: 1
                                                       )),*/
                                                       height: MediaQuery.of(context).size.height*0.05,
                                                       width: MediaQuery.of(context).size.width*0.43,margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.004),
                                                       child: 
                                                       Text(clipText(_hastalikHospitals[index].adres, _hastalikHospitals[index].adres.length),
                                                       style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.black54),)),
                                                       Container(
                                                        width: context.getWidth*0.2,
                                                        height: context.getHeight*0.06,
                                                         child: Card(
                                                          color: distanceColor(distances[index]),elevation: 10,
                                                         child: Center(child: AppText.appText(distances[index].toStringAsFixed(2)+"  km", 13, Colors.white, FontWeight.bold)//Text(distances[index].toStringAsFixed(2)+"  km")
                                                         ),),
                                                       )
                                                    ],
                                                  )
                                                 
                                                   :
                                                    Container(
                                                   /*decoration: BoxDecoration(border: Border.all(width: 1
                                                   )),*/
                                                   height: MediaQuery.of(context).size.height*0.05,
                                                   width: MediaQuery.of(context).size.width*0.53,margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.004),
                                                   child: 
                                                   Text(clipText(_hastalikHospitals[index].adres, _hastalikHospitals[index].adres.length),
                                                   style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.black54),))
                                                 /*  Container(
                                                   decoration: BoxDecoration(border: Border.all(width: 1
                                                   )),
                                                   height: MediaQuery.of(context).size.height*0.05,
                                                   width: MediaQuery.of(context).size.width*0.53,margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.004),
                                                   child: Text(clipText(_hastalikHospitals[index].adres, _hastalikHospitals[index].adres.length),style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.black54),)),
                                                 
                                                 */
                                                 ],
                                               )
                                             ]),),
                                           )
                                         );
                                 },),


                              ],
                            ),
                          )

                          :

                          SizedBox.shrink()
          ],
        ),
      ),

    );
  }
}

String clipText(String text,int clipIndex){
  String temp = "";
  for(int i=0;i<clipIndex;i++){
    temp = temp + text[i];
  }
  temp = temp + "...";
  return temp;
}
int arangeReview(int reviews){
  int num = 0;
  if(reviews == 0 ){
    num = 0;
  }
  else if(reviews == 1 || (reviews>1 && reviews<5)){
    num = 1;
  }
  else if(reviews == 5 || (reviews>5 && reviews<10)){
    num = 5;
  }
  else if(reviews == 10 || (reviews>10 && reviews<50)){
    num = 10;
  }
  else if(reviews == 50 || (reviews>50 && reviews<100)){
    num = 50;
  }
  else if(reviews == 100 || (reviews>100 && reviews<200)){
    num = 100;
  }
  else if(reviews == 200 || (reviews>200 && reviews<300)){
    num = 200;
  }
 
 return num;
}
