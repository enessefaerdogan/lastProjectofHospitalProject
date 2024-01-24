import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_ex/feature/spam/view/spam_view.dart';
import 'package:flutter_google_maps_ex/feature/userDetail/view/userDetail_view.dart';
import 'package:flutter_google_maps_ex/product/model/like.dart';
import 'package:flutter_google_maps_ex/product/widget/apptext.dart';
import 'package:flutter_google_maps_ex/core/components/failure_snackbar.dart';
import 'package:flutter_google_maps_ex/product/widget/indicator.dart';
import 'package:flutter_google_maps_ex/core/components/sizedbox_height.dart';
import 'package:flutter_google_maps_ex/core/components/sizedbox_width.dart';
import 'package:flutter_google_maps_ex/core/extension/image_extension.dart';
import 'package:flutter_google_maps_ex/core/extension/mediaquery_extension.dart';
import 'package:flutter_google_maps_ex/feature/favorite/view/favorite_view.dart';
import 'package:flutter_google_maps_ex/feature/home/view/home_view.dart';
import 'package:flutter_google_maps_ex/feature/review/view/review_view.dart';
import 'package:flutter_google_maps_ex/product/model/app_user.dart';
import 'package:flutter_google_maps_ex/product/model/favorite.dart';
import 'package:flutter_google_maps_ex/product/model/hospital.dart';
import 'package:flutter_google_maps_ex/product/model/review.dart';
import 'package:flutter_google_maps_ex/product/utility/constants/firebase_constants.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:url_launcher/url_launcher.dart';
import 'package:lottie/lottie.dart' as lottie;

class HospitalDetailView extends StatefulWidget {
  Hospital hospital;
  AppUser appUser;
  double avarageStar;
  int reviews;
  List<AppUser>? users;
  String? docId;
  int? pageCode;
  List<Like>? likes;
  double? oneStar = 0;
  double? twoStar = 0;
  double? threeStar = 0;
  double? fourStar = 0;
  double? fiveStar = 0;
  HospitalDetailView({
    this.oneStar 
    ,
     this.twoStar, this.threeStar, this.fourStar, this.fiveStar,
    required this.hospital, required this.appUser, required this.avarageStar,
  required this.reviews, this.users, this.docId, this.pageCode, this.likes});

  @override
  State<HospitalDetailView> createState() => _HospitalDetailViewState();
}

class _HospitalDetailViewState extends State<HospitalDetailView> with TickerProviderStateMixin{
  /// Tab Controller
  late final TabController _tabController =
      TabController(length: 4, vsync: this);

  static late CameraPosition _kGooglePlex;
  List<Marker> _marker = [];
  List<Marker> _list =  [
  ];
  late Favorite _currentFavorite; 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //fetchLike();
    _currentDay = _dayDetect();
    fetchUser();
    var newMarker = Marker(
    markerId: MarkerId('1'),// id -> 1
    position: LatLng(double.parse(widget.hospital.latitude), double.parse(widget.hospital.longitude)),// double lat, double long
    infoWindow: InfoWindow(
      title: widget.hospital.ad// String title
      // data çekme metodu içinde marker listesi yapılıp bu parametrelerle marker açılıp liste içine atılacak
      // üstüne basınca ne yazsın,
      ,
      snippet: widget.hospital.adres // adress yazılır buraya 
    
    )
    );
    _kGooglePlex = CameraPosition(
   target: LatLng(double.parse(widget.hospital.latitude), double.parse(widget.hospital.longitude))
  ,zoom: 14.4746);
    _marker.add(newMarker);
    fetchReview();
    fetchFavorite();
    //fetchLike();
    /*if(_favoriteDetector()){
      print("EE ÇALIŞTIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII");
    }*/

    _isFavorited = _favoriteDetector() ? true : false;
    //print("YENNİ:" +_isFavorited.toString());
    //print("GELEN FAVORİLERRRRRRRRRRRRRRRRRRRRRRRRRRRRR :" + widget.favorites.toString());
    //print("favorite:" +widget.favorites![0].hastanead.toString());
    FirebaseFirestore.instance.collection(FirebaseConstants.favorilerCollection).snapshots().listen((event) {
      mapFavorite(event);
     });
    /*FirebaseFirestore.instance.collection("degerlendirme").snapshots().listen((event) {
      mapReview(event);
     });*/ 
    FirebaseFirestore.instance.collection(FirebaseConstants.begeniCollection).snapshots().listen((event){
     mapLike(event);
    });
  }

  mapLike(QuerySnapshot<Map<String,dynamic>> datas){
    final _datas = datas.docs.map((item) => 
    Like(
      degerlendirmeId: item["degerlendirme_id"], 
      id: item.id, 
      kullanici: item["kullanici"]) ).toList();
      setState(() {
          widget.likes = [];
          widget.likes = _datas;
      });

    
  }

  Completer<GoogleMapController> _controller = Completer();

  

  List<Review> reviewsList = [];
  bool _isLoadingReviewList = true;
  Future<void> fetchReview()async{
    var response = await FirebaseFirestore.instance.collection(
    FirebaseConstants.
    degerlendirmeCollection).
    where('hastane',isEqualTo: widget.hospital.ad).get();
    mapReview(response);
  }
  
  mapReview(QuerySnapshot<Map<String,dynamic>> datas){
    final _datas = datas.docs.map((item) => Review(tarih: item["tarih"],foto: item["foto"],
    hastane: item["hastane"], 
    id: item.id,
     kullanici: item["kullanici"], 
     puan: item["puan"], 
     yorum: item["yorum"])).toList();

    setState(() {
      reviewsList = _datas;
      _isLoadingReviewList = false;
    });
  }

  

  bool _favoriteDetector(){
    for(int i=0;i<_favorites.length;i++){
      if(_favorites![i].hastanead == widget.hospital.ad){

        setState(() {
         _currentFavorite = _favorites[i];
        });
        print("BULUNDUUUUUUUUUUUUUUU");

        return true;
      }
    }
    return false;
  }

  List<Favorite> _favorites = [];
  Future<void> fetchFavorite()async{
    var response = await FirebaseFirestore
    .instance
    .collection(FirebaseConstants.favorilerCollection)
    .where('kullanicimail',isEqualTo: widget.appUser.email)
    .get();
    mapFavorite(response);
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
      _isFavorited = _favoriteDetector() ? true : false;
    });
  }

  // eğer favori zaten varsa sileri
  Future<void> _deleteFavorite()async{

   /* Favorite _newFavorite = Favorite(
    hastanead: _currentFavorite.hastanead, 
    id: _currentFavorite.id, 
    kullanicimail: _currentFavorite.kullanicimail); */
    await FirebaseFirestore.instance.collection(FirebaseConstants.favorilerCollection).doc(_currentFavorite.id).delete();
  }

  Future<void> _addFavorite()async{

    Favorite _newFavorite = Favorite(
    hastanead: widget.hospital.ad, 
    id: "id", 
    kullanicimail: widget.appUser.email); 
    await FirebaseFirestore.instance.collection(FirebaseConstants.favorilerCollection).add(_newFavorite.toJson());
  }


  /*List<Favorite> _favorites = [];

  Future<void> fetchFavorite()async{
    var response = await FirebaseFirestore.instance.collection("favoriler").where('kullaniciad').get();
    mapReview(response);
  }
  
  mapFavorite(QuerySnapshot<Map<String,dynamic>> datas){
    final _datas = datas.docs.map((item) => Review(foto: item["foto"],hastane: item["hastane"], 
    id: item.id,
     kullanici: item["kullanici"], 
     puan: item["puan"], 
     yorum: item["yorum"])).toList();

    setState(() {
      reviewsList = _datas;
    });
  }*/

  bool _isFavorited = false;

  void _changeFavorited(){
    setState(() {
      _isFavorited = !_isFavorited;
    });
  }

  //int touchedIndex = -1;
  int location = 0;
  List<PieChartSectionData> showingSections() {
    return List.generate(5, (i) {
      //final isTouched = i == touchedIndex;
      //final fontSize = isTouched ? 25.0 : 16.0;
      final fontSize = 16.0;
      //final radius = isTouched ? 60.0 : 50.0;
      final radius = 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:

          return PieChartSectionData(
            color: Colors.purple,
            value: widget.oneStar,
            title: '%${((widget.oneStar!/(widget.oneStar!+widget.twoStar!+widget.threeStar!
            +widget.fourStar!+widget.fiveStar!))*100).toStringAsFixed(1)}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Poppins-Regular',
              shadows: shadows,
            ),
          );

        case 1:
          return PieChartSectionData(
            color: Colors.red,
            value: widget.twoStar,
            title: '%${((widget.twoStar!/(widget.oneStar!+widget.twoStar!+widget.threeStar!+widget.fourStar!+widget.fiveStar!))*100).toStringAsFixed(1)}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Poppins-Regular',
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.amber,
            value: widget.threeStar,
            title: '%${((widget.threeStar!/(widget.oneStar!+widget.twoStar!+widget.threeStar!+widget.fourStar!+widget.fiveStar!))*100).toStringAsFixed(1)}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Poppins-Regular',
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.yellow,
            value: widget.fourStar,
            title: '%${((widget.fourStar!/(widget.oneStar!+widget.twoStar!+widget.threeStar!+widget.fourStar!+widget.fiveStar!))*100).toStringAsFixed(1)}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Poppins-Regular',
              shadows: shadows,
            ),
          );
        case 4:
          return PieChartSectionData(
            color: Colors.green,
            value: widget.fiveStar,
            title: '%${((widget.fiveStar!/(widget.oneStar!+widget.twoStar!+widget.threeStar!+widget.fourStar!+widget.fiveStar!))*100).toStringAsFixed(1)}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins-Regular',
              color: Colors.white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
  
 /* List<Like> _likes = [];
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

    
  }*/
  
  like(Review currentReview)async{
   // kim beğendi
   // hangi beğeni gönder
   Like newLike = Like(degerlendirmeId: currentReview.id, id: "id", kullanici: widget.appUser.email);
   await FirebaseFirestore.instance.collection(FirebaseConstants.begeniCollection).add(newLike.toJson());
   /*setState(() {
     widget.likes!.add(newLike);
   });*/
  }
  unlike(Like currentLike)async{
   await FirebaseFirestore.instance.collection(FirebaseConstants.begeniCollection).doc(currentLike.id).delete();
    /*widget.likes!.removeWhere((element) => element.id == currentLike.id);
    setState(() {
      
    });*/
  }

  int detectLikes(Review currentReview,List<Like> likes){
    // hangi değerlendirmenin kaç like'ı var ?
    int count = 0;
    for(int i=0;i<likes.length;i++){
      if(likes[i].degerlendirmeId == currentReview.id){
           
             count += 1;
          
      }
    }
    return count;
  }

  bool isUserLiked(List<Like> Likes,Review spesificReview){
// gezer içerde eğer bunla eşleşiyorsam ben true dön ve 

for(int i=0;i<Likes.length;i++){
  if(Likes[i].degerlendirmeId == spesificReview.id){
if(Likes[i].kullanici == widget.appUser.email ){
        return true;
    }
  }
   
}

   return false;
  }
  

  /*int usersLikeAboutReview(List<Like> Likes){
    int count = 0;
for(int i=0;i<Likes.length;i++){
    if(Likes[i].kullanici == widget.appUser.email ){
        count += 1;
    }
   
}

   return count;
  }*/
  



  Like usersLike(Review spesificReview){
    for(int i=0;i<widget.likes!.length;i++){
      if(spesificReview.id == widget.likes![i].degerlendirmeId){
        // eğer seçili reviewdeysek ve 
         if(widget.likes![i].kullanici == widget.appUser.email ){
        return widget.likes![i];
    }
      }
   
   }
   return Like(degerlendirmeId: "degerlendirmeId", id: "id", kullanici: "kullanici");
  }

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

  String findRelatedUserwithReview(Review relatedReview){
    // user ile eşleşen
    for(int i=0;i<_users.length;i++){
      if(_users[i].email == relatedReview.kullanici){
        return _users[i].foto;
      }
    }
    return "";
  }

  AppUser findRelatedUserwithReview2(Review relatedReview){
    // user ile eşleşen
    for(int i=0;i<_users.length;i++){
      if(_users[i].email == relatedReview.kullanici){
        return _users[i];
      }
    }
    return AppUser(ad: "ad", email: "email", foto: "foto", id: "id", sifre: "sifre", soyad: "soyad", tc: "tc");
  }
 


  
  bool _isUserReviewed = false;
  double _userRating = 1;
  TextEditingController _commentController = TextEditingController();
  void _addReview(){
   showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,

    title: AppText.appText("Değerlendirme", 17, Colors.black,FontWeight.normal),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: MediaQuery.of(context).size.width*0.9,
          height: MediaQuery.of(context).size.height*0.07,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),border: Border.all(width: 2)),
          child: Center(
            child: RatingBar.builder(
               initialRating: _userRating,
               minRating: 1,
               direction: Axis.horizontal,
               allowHalfRating: false,
               itemCount: 5,
               itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
               itemBuilder: (context, _) => Icon(
                 Icons.star,
                 color: Colors.amber,
               ),
               onRatingUpdate: (rating) {
                 print(rating);
                 setState(() {
                    _userRating = rating;
                    
                 });

               },
            ),
          ),
        ),
        //Text("Puan:" + _userRating.toString()),
      Divider(),
      TextFormField(maxLines: 1,controller: _commentController,decoration: InputDecoration(labelText: "Yorum"),),
      //TextFormField(controller: numController,decoration: InputDecoration(hintText: "Numara"),),
      
    ],),
    actions: [
      TextButton(onPressed: (){
        _commentController.text = "";
      }, child: AppText.appText("Temizle", 14, Colors.red,FontWeight.normal)),
 
      TextButton(onPressed: (){
        //addKisi(nameController.text, numController.text);
        //clear();
        _sendReview();
        Navigator.pop(context);
      }, child: AppText.appText("Gönder", 14, Colors.green,FontWeight.normal)),

    ],
      );
    },);
 }
 
 AppUser findRelatedUser(Review currentReview){
  AppUser userRelated = AppUser(ad: "ad", email: "email", foto: "foto", id: "id", sifre: "sifre", soyad: "soyad", tc: "tc");
  for(int i=0;i<_users.length;i++){
    if(_users[i].email == currentReview.kullanici){
      return _users[i];
    }
  }
  return userRelated;
 }

 Future<void> _sendReview()async{
  Review _newReview = Review(
  tarih:DateFormat('dd.MM.yyyy').format(DateTime.now()) 
  ,foto: widget.appUser.foto, 
  hastane: widget.hospital.ad, 
  id: "id", 
  kullanici: widget.appUser.email, 
  puan: _userRating.toString(), 
  yorum: _commentController.text);
  await FirebaseFirestore.instance.collection("degerlendirme").add(_newReview.toJson());
  setState(() {
    reviewsList.add(_newReview);
    print("MY AVARAGE BEFORE 1:"+ widget.avarageStar.toString());
    print(reviewsList.length);
    if(reviewsList.length == 1){
      widget.avarageStar = double.parse(reviewsList[0].puan);
    }
    else{
    widget.avarageStar = (widget.avarageStar + _userRating ) / (reviewsList.length);
    }

    print("MY AVARAGE AFTER 2:"+ widget.avarageStar.toString());
    print(reviewsList.length);
  });

  
 }
 
 
 String _currentDay = "";
 String _dayDetect(){
  if(DateFormat('EEEE').format(DateTime.now()) == "Monday"){
    return "Pazartesi";
  }
  else if(DateFormat('EEEE').format(DateTime.now()) == "Tuesday"){
    return "Salı";
  }
  else if(DateFormat('EEEE').format(DateTime.now()) == "Wednesday"){
    return "Çarşamba";
  }
  else if(DateFormat('EEEE').format(DateTime.now()) == "Thursday"){
    return "Perşembe";
  }
  else if(DateFormat('EEEE').format(DateTime.now()) == "Friday"){
    return "Cuma";
  }
  else if(DateFormat('EEEE').format(DateTime.now()) == "Saturday"){
    return "Cumartesi";
  }
  else if(DateFormat('EEEE').format(DateTime.now()) == "Sunday"){
    return "Pazar";
  }
  return "";
 }


  @override
  Widget build(BuildContext context) {
    //print("POSTA : " + widget.appUser.email);
     //String date = DateFormat('dd.MM.yyyy').format(DateTime.now());
     // String time = DateFormat('kk:mm:ss').format(DateTime.now());
     // print("DANTE:"+date.toString());

     print("LIKELER BURADA : " + widget.likes!.length.toString());
  


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
      backgroundColor: Colors.red,
      title: Text(widget.hospital.ad,style: 
      TextStyle(fontFamily: 'Poppins-Regular',color: Colors.white,fontSize: 17),),leading: IconButton(onPressed: (){

        if(widget.pageCode == 1){
          Navigator.pop(context);
        }
        else{
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView(docId: widget.docId,currentUser: widget.appUser,)));
        }

      }, icon: Icon(Icons.chevron_left,color: Colors.white,)),),

      body: 
      SingleChildScrollView(
        child: Column(
          children: [
        
            Stack(
              children:[ Container(color: Colors.red,width: MediaQuery.of(context).size.width*1,
              height: MediaQuery.of(context).size.height*0.4,child: Column(
                children: [
                  
                ],
              ),),
              
              
              Positioned(
                    bottom: -6,
                    left: MediaQuery.of(context).size.width*0.03,
                    child: Container(width: MediaQuery.of(context).size.width*0.93,
                    height: MediaQuery.of(context).size.height*0.4,
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),color: Colors.white,elevation: 0,
                      child: Column(
                        children: [
        
                          Container(
                      /*decoration: BoxDecoration(
                      border: Border.all(width: 1,)),*/
                      /*margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.04,
                      right: MediaQuery.of(context).size.width*0.02),*/
                      width: MediaQuery.of(context).size.width*0.99,
                      height: MediaQuery.of(context).size.height*0.15,child:
                      Stack(
                        children: [ Container(
                          width: MediaQuery.of(context).size.width*0.99,
                      height: MediaQuery.of(context).size.height*0.15,
                          child: ClipPath(
                            clipper: ShapeBorderClipper(shape: 
                            RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50)))),
                            child: Image.asset(fit: BoxFit.cover,widget.hospital.foto)),
                        ),
        
                        Positioned(
                          top: MediaQuery.of(context).size.height*0.09,
                          right: 3,
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.4,
                            height: MediaQuery.of(context).size.height*0.06,
                            child: Card(
                              color: Colors.white,
                              child: Row(
                                children: [
                                   InkWell(
                                    onTap: (){
                                      _redirectWebsite(widget.hospital.website);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.045,right: MediaQuery.of(context).size.width*0.03),
                                      width: MediaQuery.of(context).size.width*0.05,
                                      height: MediaQuery.of(context).size.height*0.03,child: Image.asset("assets/world-wide-web.png")),
                                   ),
                                  Container(
                                    //decoration: BoxDecoration(border: Border.all(width: 1)),
                                    child: IconButton(iconSize: 20,onPressed: ()async{
                                      _callPhone(widget.hospital.tel);
                                    }, icon: Icon(color: Colors.black,Icons.phone)),
                                  ),
                                  IconButton(iconSize: 20,onPressed: (){
                                    _changeFavorited();
        
                                    // favori değişti eğer gri _isFavorited false'a döndüyse demekki sildik
                                    if(_isFavorited == false){
                                      _deleteFavorite();
                                    }
                                    else if(_isFavorited == true){
                                      _addFavorite();
                                    }
                                  }, icon: Icon(color: _isFavorited ?  Colors.red : Colors.blueGrey,Icons.favorite)),
                                ],
                              ),
                            ),
                          ),
                        )
        
                        ]
                      )),
                        Container(//decoration: BoxDecoration(border: Border.all(width: 1)),
                        width: MediaQuery.of(context).size.width*0.9,
                        height: MediaQuery.of(context).size.height*0.05,margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.008),child: Align(
                          alignment: Alignment.topCenter,child: Text("~ ${widget.hospital.ad} ~",style: TextStyle(fontFamily: 'Poppins-Regular',fontWeight: FontWeight.bold,color: Colors.black),))),
                          Row(
                            children: [
                              Container(width: MediaQuery.of(context).size.width*0.1,
                              height: MediaQuery.of(context).size.height*0.03,child: Image.asset("assets/location.png")),
                              Container(//decoration: BoxDecoration(border: Border.all(width: 1)),
                              width: MediaQuery.of(context).size.width*0.8,
                                                    height: MediaQuery.of(context).size.height*0.05,margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.003),child: Align(
                              alignment: Alignment.topCenter,child: Text("${widget.hospital.adres}",style: TextStyle(fontFamily: 'Poppins-Regular',fontWeight: FontWeight.bold,color: Colors.black54),))),
                            ],
                          ),
                          SizedBoxHeight(height: 0.007),
                          Row(
                            children: [
                              Container(width: MediaQuery.of(context).size.width*0.1,
                              height: MediaQuery.of(context).size.height*0.03,child: Image.asset("assets/phone.png")),
                              Container(
                              //decoration: BoxDecoration(border: Border.all(width: 1)),
                              width: MediaQuery.of(context).size.width*0.8,
                                        height: MediaQuery.of(context).size.height*0.03,margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.003),child: Text("${widget.hospital.tel}",style: TextStyle(fontFamily: 'Poppins-Regular',fontWeight: FontWeight.bold,color: Colors.black54),)),
                            ],
                          ),
                          SizedBoxHeight(height: 0.007),
                          Row(
                            children: [
                              Container(
                                //decoration: BoxDecoration(border: Border.all(width: 1)),
                                width: MediaQuery.of(context).size.width*0.1,
                                height: MediaQuery.of(context).size.height*0.03,child: Icon(Icons.star,color: Colors.amber,)),
                                Container(
                                //decoration: BoxDecoration(border: Border.all(width: 1)),
                                width: MediaQuery.of(context).size.width*0.075,
                                        height: MediaQuery.of(context).size.height*0.03,margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.003),
                                        child: Text("${widget.avarageStar.toStringAsFixed(1)}",
                                        style: TextStyle(fontFamily: 'Poppins-Regular',fontWeight: FontWeight.bold,color: Colors.black),)),
                              Container(
                              //decoration: BoxDecoration(border: Border.all(width: 1)),
                              width: MediaQuery.of(context).size.width*0.7,
                                        height: MediaQuery.of(context).size.height*0.03,margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.003),
                                        child: Text("( ${widget.reviews.toString()}+ Değerlendirme )",
                                        style: TextStyle(fontFamily: 'Poppins-Regular',fontWeight: FontWeight.bold,color: Colors.black54),)),
        
        
                            ],
                          ),
        
                          
                        ],
                      ),),
                    ),
                  )
              ]
            ),
        
        
            Container(
                  child: TabBar(
                      onTap: (index){
                        //print("yerimiz :"+index.toString());
                        setState(() {
                          location = index;
                        });
                      },
                      
                      //isScrollable: true,
                      controller: _tabController,
                      labelColor: Colors.black,
                      indicatorColor: Colors.redAccent,
                      //dividerColor: Colors.redAccent,
                      unselectedLabelColor: Colors.black38,
                      tabs: [
        
                        Tab(
                          text: "Çalışma Saati",
                        ),
                        Tab(
                          text: "Analiz",
                        ),
                        Tab(
                          text: "Yorumlar",
                        ),
                        Tab(
                          text: "Harita",
                        ),
                        
                      ]),
                ),
        
                Container(
                  //decoration: BoxDecoration(border: Border.all(width: 1)),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height*0.433,
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _tabController, 
                    children: [
                    SingleChildScrollView(
                      child: Column(children: [
                        SizedBoxHeight(height: 0.03),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              height: MediaQuery.of(context).size.height*0.05,
                              child: Card(
                                elevation: 10,
                                shadowColor: _currentDay == "Pazartesi" ? Colors.greenAccent : Colors.redAccent,
                                color: _currentDay == "Pazartesi" ? Colors.green : Colors.red,
                                
                                child: Center(child: Text("Pazartesi",style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.white),)),
                              ),
                            ),
        
                            Container(height: MediaQuery.of(context).size.height*0.03,
                            width: MediaQuery.of(context).size.width*0.003,color: Colors.black,margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,
                            right: MediaQuery.of(context).size.width*0.05),),
        
                            Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              height: MediaQuery.of(context).size.height*0.05,
                              child: Card(
                                elevation: 10,
                                shadowColor: _currentDay == "Pazartesi" ? Colors.greenAccent : Colors.redAccent,
                                color: _currentDay == "Pazartesi" ? Colors.green : Colors.red,
                                
                                child: Center(child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.timer_sharp,color: Colors.white,),
                                    SizedBoxWidth(width: 0.01),
                                    Text("24 Saat Açık",style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.white),),
                                  ],
                                )),
                              ),
                            ),
        
        
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              height: MediaQuery.of(context).size.height*0.05,
                              child: Card(
                                elevation: 10,
                                shadowColor: _currentDay == "Salı" ? Colors.greenAccent : Colors.redAccent,
                                color: _currentDay == "Salı" ? Colors.green : Colors.red,
                                
                                child: Center(child: Text("Salı",style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.white),)),
                              ),
                            ),
        
                            Container(height: MediaQuery.of(context).size.height*0.03,
                            width: MediaQuery.of(context).size.width*0.003,color: Colors.black,margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,
                            right: MediaQuery.of(context).size.width*0.05),),
        
                            Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              height: MediaQuery.of(context).size.height*0.05,
                              child: Card(
                                elevation: 10,
                                shadowColor: _currentDay == "Salı" ? Colors.greenAccent : Colors.redAccent,
                                color: _currentDay == "Salı" ? Colors.green : Colors.red,
                                
                                child: Center(child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.timer_sharp,color: Colors.white,),
                                    SizedBoxWidth(width: 0.01),
                                    Text("24 Saat Açık",style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.white),),
                                  ],
                                )),
                              ),
                            ),
        
        
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              height: MediaQuery.of(context).size.height*0.05,
                              child: Card(
                                elevation: 10,
                                shadowColor: _currentDay == "Çarşamba" ? Colors.greenAccent : Colors.redAccent,
                                color: _currentDay == "Çarşamba" ? Colors.green : Colors.red,
                                
                                child: Center(child: Text("Çarşamba",style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.white),)),
                              ),
                            ),
        
                            Container(height: MediaQuery.of(context).size.height*0.03,
                            width: MediaQuery.of(context).size.width*0.003,color: Colors.black,margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,
                            right: MediaQuery.of(context).size.width*0.05),),
        
                            Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              height: MediaQuery.of(context).size.height*0.05,
                              child: Card(
                                elevation: 10,
                                shadowColor: _currentDay == "Çarşamba" ? Colors.greenAccent : Colors.redAccent,
                                color: _currentDay == "Çarşamba" ? Colors.green : Colors.red,
                                
                                child: Center(child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.timer_sharp,color: Colors.white,),
                                    SizedBoxWidth(width: 0.01),
                                    Text("24 Saat Açık",style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.white),),
                                  ],
                                )),
                              ),
                            ),
        
        
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              height: MediaQuery.of(context).size.height*0.05,
                              child: Card(
                                elevation: 10,
                                shadowColor: _currentDay == "Perşembe" ? Colors.greenAccent : Colors.redAccent,
                                color: _currentDay == "Perşembe" ? Colors.green : Colors.red,
                                
                                child: Center(child: Text("Perşembe",style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.white),)),
                              ),
                            ),
        
                            Container(height: MediaQuery.of(context).size.height*0.03,
                            width: MediaQuery.of(context).size.width*0.003,color: Colors.black,margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,
                            right: MediaQuery.of(context).size.width*0.05),),
        
                            Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              height: MediaQuery.of(context).size.height*0.05,
                              child: Card(
                                elevation: 10,
                                shadowColor: _currentDay == "Perşembe" ? Colors.greenAccent : Colors.redAccent,
                                color: _currentDay == "Perşembe" ? Colors.green : Colors.red,
                                
                                child: Center(child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.timer_sharp,color: Colors.white,),
                                    SizedBoxWidth(width: 0.01),
                                    Text("24 Saat Açık",style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.white),),
                                  ],
                                )),
                              ),
                            ),
        
        
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              height: MediaQuery.of(context).size.height*0.05,
                              child: Card(
                                elevation: 10,
                                shadowColor: _currentDay == "Cuma" ? Colors.greenAccent : Colors.redAccent,
                                color: _currentDay == "Cuma" ? Colors.green : Colors.red,
                                
                                child: Center(child: Text("Cuma",style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.white),)),
                              ),
                            ),
        
                            Container(height: MediaQuery.of(context).size.height*0.03,
                            width: MediaQuery.of(context).size.width*0.003,color: Colors.black,margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,
                            right: MediaQuery.of(context).size.width*0.05),),
        
                            Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              height: MediaQuery.of(context).size.height*0.05,
                              child: Card(
                                elevation: 10,
                                shadowColor: _currentDay == "Cuma" ? Colors.greenAccent : Colors.redAccent,
                                color: _currentDay == "Cuma" ? Colors.green : Colors.red,
                                
                                child: Center(child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.timer_sharp,color: Colors.white,),
                                    SizedBoxWidth(width: 0.01),
                                    Text("24 Saat Açık",style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.white),),
                                  ],
                                )),
                              ),
                            ),
        
        
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              height: MediaQuery.of(context).size.height*0.05,
                              child: Card(
                                elevation: 10,
                                shadowColor: _currentDay == "Cumartesi" ? Colors.greenAccent : Colors.redAccent,
                                color: _currentDay == "Cumartesi" ? Colors.green : Colors.red,
                                
                                child: Center(child: Text("Cumartesi",style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.white),)),
                              ),
                            ),
        
                            Container(height: MediaQuery.of(context).size.height*0.03,
                            width: MediaQuery.of(context).size.width*0.003,color: Colors.black,margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,
                            right: MediaQuery.of(context).size.width*0.05),),
        
                            Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              height: MediaQuery.of(context).size.height*0.05,
                              child: Card(
                                elevation: 10,
                                shadowColor: _currentDay == "Cumartesi" ? Colors.greenAccent : Colors.redAccent,
                                color: _currentDay == "Cumartesi" ? Colors.green : Colors.red,
                                
                                child: Center(child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.timer_sharp,color: Colors.white,),
                                    SizedBoxWidth(width: 0.01),
                                    Text("24 Saat Açık",style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.white),),
                                  ],
                                )),
                              ),
                            ),
        
        
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              height: MediaQuery.of(context).size.height*0.05,
                              child: Card(
                                elevation: 10,
                                shadowColor: _currentDay == "Pazar" ? Colors.greenAccent : Colors.redAccent,
                                color: _currentDay == "Pazar" ? Colors.green : Colors.red,
                                
                                child: Center(child: Text("Pazar",style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.white),)),
                              ),
                            ),
        
                            Container(height: MediaQuery.of(context).size.height*0.03,
                            width: MediaQuery.of(context).size.width*0.003,color: Colors.black,margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,
                            right: MediaQuery.of(context).size.width*0.05),),
        
                            Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              height: MediaQuery.of(context).size.height*0.05,
                              child: Card(
                                elevation: 10,
                                shadowColor: _currentDay == "Pazar" ? Colors.greenAccent : Colors.redAccent,
                                color: _currentDay == "Pazar" ? Colors.green : Colors.red,
                                
                                child: Center(child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.timer_sharp,color: Colors.white,),
                                    SizedBoxWidth(width: 0.01),
                                    Text("24 Saat Açık",style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.white),),
                                  ],
                                )),
                              ),
                            ),
        
        
                          ],
                        ),
                        
                        
                        
                                    
                      ],),
                    ),

                    //Text("data"),


                    SingleChildScrollView(
                      child:  Column(
        children: [
          SizedBoxHeight(height: 0.04),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
            Container(child: Row(
              children: [
                Container(width: 20,height: 20,color: Colors.purple,),
                SizedBoxWidth(width: 0.02),
                Text("1 Puan (${widget.oneStar!.toInt()})",style:TextStyle(fontFamily: 'Poppins-Regular')),
              ],
            )),
            Container(child: Row(
              children: [
                Container(width: 20,height: 20,color: Colors.red,),
                SizedBoxWidth(width: 0.02),
                Text("2 Puan (${widget.twoStar!.toInt()})",style:TextStyle(fontFamily: 'Poppins-Regular')),
              ],
            )),
            Container(child: Row(
              children: [
                Container(width: 20,height: 20,color: Colors.amber,),
                SizedBoxWidth(width: 0.02),
                Text("3 Puan (${widget.threeStar!.toInt()})",style:TextStyle(fontFamily: 'Poppins-Regular')),
              ],
            )),
          ],),
          SizedBoxHeight(height: 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            Container(child: Row(
              children: [
                Container(width: 20,height: 20,color: Colors.yellow,),
                SizedBoxWidth(width: 0.02),
                Text("4 Puan (${widget.fourStar!.toInt()})",style:TextStyle(fontFamily: 'Poppins-Regular')),
              ],
            )),
            Container(child: Row(
              children: [
                Container(width: 20,height: 20,color: Colors.green,),
                SizedBoxWidth(width: 0.02),
                Text("5 Puan (${widget.fiveStar!.toInt()})",style:TextStyle(fontFamily: 'Poppins-Regular')),
              ],
            )),
          ],),
          Container(
            //decoration: BoxDecoration(border: Border.all(width: 1)),
            child: Row(
              children: [
                /*const SizedBox(
                  height: 18,
                ),*/
                Container(
                  margin: EdgeInsets.only(left: context.getWidth*0.18),
                  width: context.getWidth*0.6,
                  height: context.getHeight*0.3,
                  child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                //touchedIndex = -1;
                                return;
                              }
                              /*touchedIndex = pieTouchResponse
                                  .touchedSection!.touchedSectionIndex;
                                  print("DOKUNULDU"+touchedIndex.toString());*/
                            });
                          },
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: showingSections(),
                      ),
                    ),
                 
                ),
                /*const Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                   
                    /*Indicator(
                      color: Colors.blue,
                      text: 'First',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: AppColors.contentColorYellow,
                      text: 'Second',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: AppColors.contentColorPurple,
                      text: 'Third',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: AppColors.contentColorGreen,
                      text: 'Fourth',
                      isSquare: true,
                    ),*/
                    SizedBox(
                      height: 18,
                    ),
                  ],
                ),*/
                /*const SizedBox(
                  width: 28,
                ),*/
              ],
            ),
          ),
        ],
      ),
                    ),
                    
                    SingleChildScrollView(
                      child: Column(
                        children: [
                            Container(
                            width: MediaQuery.of(context).size.width*1,
                            height: MediaQuery.of(context).size.height*0.432,
                            child: 
                            
                            reviewsList.length>0 && _isLoadingReviewList == false ? 
                            // geldiyse ve 0 dan çoksa
                            
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: reviewsList.length,
                              itemBuilder: ((context, index) {
                                  
                              return Container(
                                width: MediaQuery.of(context).size.width*0.95,
                                height: MediaQuery.of(context).size.height*0.2,
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewView(myReview:reviewsList[index], myUser: findRelatedUserwithReview2(reviewsList[index]), currentUser: widget.appUser,)));
                                  },
                                  child: Card(
                                    elevation: 1,
                                    color: Colors.white,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        
                                        Container(
                                          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.015,
                                          top: MediaQuery.of(context).size.width*0.015),
                                          width: MediaQuery.of(context).size.width*0.16,
                                          height: MediaQuery.of(context).size.height*0.08,
                                          child: InkWell(onTap: (){
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetailView(detailedUser: findRelatedUser(reviewsList[index]),)));},child: CircleAvatar(radius: 30,backgroundColor: Colors.white,backgroundImage: NetworkImage(findRelatedUserwithReview(reviewsList[index])) ,))),
                                                                
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(context).size.width*0.53,
                                                    //decoration: BoxDecoration(border: Border.all(width: 1)),
                                                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.007,
                                                  left: MediaQuery.of(context).size.width*0.03),child: Text("${(findUser(_users,reviewsList[index]).ad + findUser(_users,reviewsList[index]).soyad) == widget.appUser.ad + widget.appUser.soyad   ?  findUser(_users,reviewsList[index]).ad + " " + findUser(_users,reviewsList[index]).soyad + " (Siz)": findUser(_users,reviewsList[index]).ad + " " + findUser(_users,reviewsList[index]).soyad } ",style: TextStyle(color: Colors.black,fontFamily: 'Poppins-Regular'),)),
                                                  Container(
                                                    //decoration: BoxDecoration(border: Border.all(width: 1)),
                                                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.007,
                                                  left: MediaQuery.of(context).size.width*0.01),child: Text(reviewsList[index].tarih,style: TextStyle(color: Colors.black45,fontFamily: 'Poppins-Regular'),)),
                                                ],
                                              ),
                                                                
                                              Container(
                                                margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.star,color: Colors.amber,),
                                                    Text(reviewsList[index].puan,style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.black),),
                                                                
                                                  ],
                                                ),
                                              ),
                                                                
                                                                
                                               // devamını oku benzeri bir yapı lazım
                                               Container(
                                                width: MediaQuery.of(context).size.width*0.7,
                                                height: MediaQuery.of(context).size.height*0.05,
                                                //decoration: BoxDecoration(border: Border.all(width: 1)),
                                                margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03,top: MediaQuery.of(context).size.height*0.01),
                                                child: Text(clipText(reviewsList[index].yorum, 70),style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.black54),),
                                              ),
                                              SizedBox(height: context.getHeight*0.005,),

                                              Row(

                                                children: [
                                                  Container(child: 
                                                  
                                                  reviewsList[index].kullanici != widget.appUser.email ?
                                                  IconButton(onPressed: (){
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => SpamView(currentReview: reviewsList[index],currentUser: widget.appUser,)));
                                                          print("DATALAR GİTTİŞ : "+    widget.appUser.email.toString() + reviewsList[index].kullanici.toString() );

                                                  }, icon: Icon(Icons.report))
                                                  :
                                                  SizedBox.shrink()
                                                  
                                                  ),



                                                  Container(margin: EdgeInsets.only(bottom: context.getHeight*0.007 ,left: reviewsList[index].kullanici != widget.appUser.email ? 0 : MediaQuery.of(context).size.width*0.03),
                                                  child: InkWell(onTap: (){
                                                    // 0 dan çoksa ve bu kullanıcı daha önce beğenmediyse
                                                          isUserLiked(widget.likes!,reviewsList[index]) ? unlike(usersLike(reviewsList[index])) : like(reviewsList[index]) ; 
                                                         //like(reviewsList[index]);
                                                          setState(() {
                                                            
                                                          });
                                                  },child: Container(width: context.getWidth*0.055,height: context.getHeight*0.026,child: Image.asset(isUserLiked(widget.likes!,reviewsList[index]) ? "unlike".toPng : "like".toPng)),)),
                                                  Text(" " + detectLikes(reviewsList[index],widget.likes!).toString())
                                                 
                                                ],
                                              )
                                    
                                                                
                                            ],
                                          )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                               }),
                            )
                            
                            :
                            reviewsList.length==0 && _isLoadingReviewList == false? 
                             
                             // yüklenmişse ve uzunluk 1 den azsa
                             Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.3,
                                      height: MediaQuery.of(context).size.height*0.15,child: lottie.Lottie.asset("commentNotFound".lottieToJson)),
                                    Container(
                                      margin: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.05),child: Center(child: Text("Henüz Yorum Yok",style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.black54,fontSize: 15),))),
                                  ],
                                ),
                              ],
                            )
        
                            :
                            
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Center(child: Indicator.circularProgressIndicator())],
                            )
        
        
                            
                          )
        
                        ],
                      ),
                    ),
        
                    SingleChildScrollView(
                      child: Column(
                        children: [

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:Container(
                                  width: MediaQuery.of(context).size.width*1,
                                  height: MediaQuery.of(context).size.height*0.41,
                                  child: GoogleMap(
                                  initialCameraPosition: _kGooglePlex,
                                  // map yapısı belirlenir
                                  mapType: MapType.normal,
                                  compassEnabled: false,
                                  myLocationEnabled: true,
                                  buildingsEnabled: false,     
                                  markers: Set<Marker>.of(_marker),
                                  onMapCreated: (GoogleMapController controller){
                                            
                                   _controller.complete(controller);
                                          
                                    },),
                            ),
                          ),

                          
                        ],
                      ),
                    )
                    
                    
                  ])),
                 
        
        
        
        
        
        
            
          ],
        ),
      ),
    floatingActionButton: location == 2 ? Container(
      //decoration: BoxDecoration(border: Border.all(width: 1)),
      width: MediaQuery.of(context).size.width*0.16,
      height: MediaQuery.of(context).size.height*0.08,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        elevation: 20,
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          backgroundColor: Colors.red,
          child: Icon(Icons.telegram,size: 50,),
          foregroundColor: Colors.white,onPressed: (){  

        
            // daha önce yorum yaptıysa error scaffold dön
            // reviewListin içindeki kullanıcı adresiyle biz eşleşiyorsak
            for(int i=0;i<reviewsList.length;i++){
              if(reviewsList[i].kullanici == widget.appUser.email){
                print("ZATEN YORUM YAPTIN");
                setState(() {
                  _isUserReviewed = true;
                });
                 ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(FailureSnackbar.failureSnackbar("HATA!","Sadece 1 adet değerlendirme yapabilirsin.",Duration(seconds: 1)));
                    break;
              }
            }


            // daha önce yapmadıysa showdialog aç 

           if(!_isUserReviewed){
              _addReview();
           }

        
        
        
        }),
      ),
    )
    
    :
     
    null,

    );
    
  }
  
}


String clipText(String text,int clipIndex){
  if(text.length<70){
    return text;
  }
  else{
    String temp = "";
  for(int i=0;i<clipIndex;i++){
    temp = temp + text[i];
  }
  temp = temp + "...";
  return temp;
  }
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

AppUser findUser(List<AppUser> users,Review review){
AppUser empty = AppUser(ad: "ad", email: "email", foto: "foto", id: "id", sifre: "sifre", soyad: "soyad", tc: "tc");
for(int i=0;i<users.length;i++){
  if(users[i].email == review.kullanici){
      empty = users[i];
  }
}
return empty;
}

Future<void> _callPhone(String phoneNumber) async{

      final Uri url = Uri(
      scheme: 'tel',
      path: phoneNumber
      );
      await launchUrl(url);
}

Future<void> _redirectWebsite(String webSite) async{

      final Uri url = Uri(
      scheme: 'https',
      path: webSite
      );
      await launchUrl(url);
}
