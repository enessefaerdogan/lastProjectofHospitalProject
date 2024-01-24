import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_ex/product/model/like.dart';
import 'package:flutter_google_maps_ex/product/widget/indicator.dart';
import 'package:flutter_google_maps_ex/core/extension/image_extension.dart';
import 'package:flutter_google_maps_ex/feature/hospitalDetail/view/hospitalDetail_view.dart';
import 'package:flutter_google_maps_ex/product/model/app_user.dart';
import 'package:flutter_google_maps_ex/product/model/favorite.dart';
import 'package:flutter_google_maps_ex/product/model/hospital.dart';
import 'package:flutter_google_maps_ex/product/model/review.dart';
import 'package:flutter_google_maps_ex/product/utility/constants/firebase_constants.dart';
import 'package:lottie/lottie.dart' as lottie;

class FavoriteView extends StatefulWidget {
  Hospital? hospital;
  AppUser? appUser;
  double? avarageStar;
  int? reviews;
  List<AppUser>? users;
  FavoriteView({ this.hospital,  this.appUser,  this.avarageStar,
   this.reviews, this.users});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  List<Favorite> _favorites  = [];
  List<String> hospitalNames = [];
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

    setState(() {
      _favorites = _datas;
     // _isFavorited = _favoriteDetector() ? true : false;
     _favoriteNames();
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchFavorite();
    fetchReview();
    fetchHastane();
    fetchUser();
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
  
  List<AppUser> _users = [];
  Future<void> fetchUser()async{
    var response = await FirebaseFirestore.instance.collection(FirebaseConstants.kullaniciCollection).get();
    mapUser(response);
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
  
  mapUser(QuerySnapshot<Map<String,dynamic>> datas){
    final _datas = datas.docs.map((item) => 
    AppUser(ad: item["ad"], email: item["email"], foto: item["foto"], id: item.id, 
    sifre: item["sifre"], soyad: item["soyad"], tc: item["tc"])).toList();

    setState(() {
      _users = _datas;
    });
  }

  // bu isimlerle uyuşan hastaneleri getiricez
   void _favoriteNames(){
    for(int i=0;i<_favorites.length;i++){
     
        hospitalNames.add(_favorites[i].hastanead);
       
    }
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
  

  List<Hospital> _hospitals = [];
  List<Hospital> _realHospitals = [];
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

    setState(() {
      _hospitals = _datas;
      _hospitalDetector();
    });
  }

  void _hospitalDetector(){
    for(int i=0;i<_hospitals.length;i++){

      if(hospitalNames.contains(_hospitals[i].ad)){
        
        setState(() {
        _realHospitals.add(_hospitals[i]);
        });

      print("YAZDIM BABA");
      }

    }

    setState(() {
      _isRealHospitalsLoading = false;
    });
  }

AppUser _currentUser = AppUser(ad: "ad", email: "email", foto: "foto", id: "id", sifre: "sifre", soyad: "soyad", tc: "tc");

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

  bool _isRealHospitalsLoading = true;
  // geldiklerinde false'a çeviricez

  @override
  Widget build(BuildContext context) {
  /*setState(() {
      
    });*/
    fetchFavorite();
    print("HOSPİTALLLERİMMMMM :"+_hospitals.toString());
    return Scaffold(

    appBar: AppBar(automaticallyImplyLeading: false,
    title: Text("Favorilerim",style: TextStyle(fontSize: 17,fontFamily: 'Poppins-Regular',color: Colors.white),),
    backgroundColor: Colors.red,),
    body: Column(
      children: [
        /*ElevatedButton(onPressed: (){
          print(hospitalNames.toString());
        }, child: Text("İsimler")),*/
        Expanded(
          //width: MediaQuery.of(context).size.width*1,
          //height: MediaQuery.of(context).size.height*0.5,
          child: 
          
          _realHospitals.length>0 && _isRealHospitalsLoading==false?
          //veriler geldi demektir ve beklememiz bitti
          
          ListView.builder(
            itemCount: _realHospitals.length,
            itemBuilder: (context,index){
              return  Container(
              height: MediaQuery.of(context).size.height*0.14,
              width: MediaQuery.of(context).size.width*0.8,
              child: 
              GestureDetector(
                onTap: () async{
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
                  int oneStar = 0;
                    int twoStar = 0;
                    int threeStar = 0;
                    int fourStar = 0;
                    int fiveStar = 0;
                    for(int i=0;i<reviews.length;i++){

                      if(_realHospitals[index].ad == reviews[i].hastane){
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
                  Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => HospitalDetailView(
                    fiveStar: fiveStar.toDouble(),
                    fourStar: fourStar.toDouble(),
                    oneStar: oneStar.toDouble(),
                    threeStar: threeStar.toDouble(),
                    twoStar: twoStar.toDouble(),
                    likes: _likes,
                    users: _users,
                    reviews: int.parse(calculateReviews(_realHospitals[index].ad)),
                    avarageStar: calculateStar(_realHospitals[index].ad),
                    hospital: _realHospitals[index],
                    appUser: _currentUser,
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
                      child: Image.asset(fit: BoxFit.cover,_realHospitals[index].foto))),
                
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
                          child: Text(clipText(_realHospitals[index].ad,19),style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Poppins-Regular'),)),
                
                          Container(
                            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.023),
                            /*decoration: BoxDecoration(border: Border.all(width: 1
                            )),*/width: MediaQuery.of(context).size.width*0.2,height: MediaQuery.of(context).size.height*0.03,
                            child: Row(children: [
                              Icon(Icons.star,size: 20,color: Colors.amber,),
                              Text("${calculateStar(_realHospitals[index].ad).toStringAsFixed(1)}",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Poppins-Regular'),),
                              Text(" "),
                              Text("(${calculateReviews(_realHospitals[index].ad)}+)",style: TextStyle(color: Colors.black54,fontSize: 12,fontFamily: 'Poppins-Regular'))
                              ]),)
                              //                              Text("( ${int.parse(calculateReviews(hospitals[index].ad)) != 0  ? calculateReviews(hospitals[index].ad)+"+" : "0"} )",style: TextStyle(color: Colors.black54,fontSize: 12,fontFamily: 'Poppins-Regular'))]),)
          
                        ],
                      ),
                     
                      Container(
                      /*decoration: BoxDecoration(border: Border.all(width: 1
                      )),*/
                      height: MediaQuery.of(context).size.height*0.05,
                      width: MediaQuery.of(context).size.width*0.53,margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.004),
                      child: Text(clipText(_realHospitals[index].adres, _realHospitals[index].adres.length),style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.black54),)),
                    ],
                  )
                ]),),
              )
            );
            },
            
          )
          
          
          :
          
          _realHospitals.length==0 && _isRealHospitalsLoading == false 
          
          ? 

          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.13),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.3,
                                      height: MediaQuery.of(context).size.height*0.15,child: lottie.Lottie.asset("commentNotFound".lottieToJson)),
                                    Container(
                                      margin: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.05),child: Center(child: Text("Henüz Favoriniz Yok",style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.black54,fontSize: 15),))),
                                  ],
                                ),
                              ),
                            ],
                          )

          :

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Indicator.circularProgressIndicator())
            ],
          )
          ,
        ),
      ],
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
