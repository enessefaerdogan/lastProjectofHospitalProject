
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_ex/core/components/sizedbox_height.dart';
import 'package:flutter_google_maps_ex/core/extension/image_extension.dart';
import 'package:flutter_google_maps_ex/core/extension/mediaquery_extension.dart';
import 'package:flutter_google_maps_ex/feature/auth/signin/view/signin_view.dart';
import 'package:flutter_google_maps_ex/feature/auth/signin/viewModel/signin_viewModel.dart';
import 'package:flutter_google_maps_ex/feature/auth/signup/view/signup_view.dart';
import 'package:flutter_google_maps_ex/feature/chats/view/chats_view.dart';
import 'package:flutter_google_maps_ex/feature/favorite/view/favorite_view.dart';
import 'package:flutter_google_maps_ex/feature/hospitalDetail/view/hospitalDetail_view.dart';
import 'package:flutter_google_maps_ex/feature/onboard/view/onboard_view.dart';
import 'package:flutter_google_maps_ex/feature/search/view/search_view.dart';
import 'package:flutter_google_maps_ex/feature/userLikes/view/userLikes_view.dart';
import 'package:flutter_google_maps_ex/feature/userProfile/view/userProfile_view.dart';
import 'package:flutter_google_maps_ex/feature/userReviews/view/userReviews_view.dart';
import 'package:flutter_google_maps_ex/product/model/app_user.dart';
import 'package:flutter_google_maps_ex/product/model/favorite.dart';
import 'package:flutter_google_maps_ex/product/model/hospital.dart';
import 'package:flutter_google_maps_ex/product/model/like.dart';
import 'package:flutter_google_maps_ex/product/model/review.dart';
import 'package:flutter_google_maps_ex/product/service/localStorage/sharedPreferences.dart';
import 'package:flutter_google_maps_ex/product/utility/constants/firebase_constants.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  AppUser? currentUser;
  String? docId;
  HomeView({super.key,this.currentUser, this.docId });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  SharedPreferencesService service = SharedPreferencesService();

  final items = <Widget>[
    Icon(Icons.home,size: 30,color: Colors.white,),
    Icon(Icons.search,size: 30,color: Colors.white,),
    Icon(Icons.favorite,size: 30,color: Colors.white,),
    Icon(Icons.message,size: 30,color: Colors.white,),
    Icon(Icons.person,size: 30,color: Colors.white,),
    //Icon(Icons.settings,size: 30,color: Colors.white,),
    //Icon(Icons.person,size: 30,color: Colors.white,),
    
  ];

  int index = 0;

  final _navigationKey = GlobalKey<CurvedNavigationBarState>();

  final screens = [
    HomeView(),
    SearchView(),
    FavoriteView(),
    ChatsView(specialChatPage: false),
    UserProfileView(),
   // HomeView(),
   // HomeView(),
  ];

  /*List<Favorite> _favorites = [];
  Future<void> fetchFavorite()async{
    var response = await FirebaseFirestore
    .instance
    .collection("favoriler")
    .where('kullanicimail',isEqualTo: widget.currentUser!.email)
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
    });
  }*/




  // firebase altına taşınacaklar
  List<Hospital> hospitals = [];
  List<Review> reviews = [];
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
      hospitals = _datas;
      print("HOSPİTALLERİİMM :"+hospitals.length.toString());
    });
  }

  Future<void> fetchReview()async{
    var response = await FirebaseFirestore.instance.collection("degerlendirme").get();
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

  int _reviewDetect(){
  int count = 0;
  for(int i=0;i<reviews.length;i++){
              if(reviews[i].kullanici == widget.currentUser!.email){
                count += 1;
                print("BULDUM BAK+"+reviews[i].kullanici +" ve "+widget.currentUser!.email); 
                
              }
            }
  return count;
}


List<Review> usrersLikedReviews = [];
 usersLikedReviews(){
 usrersLikedReviews = [];
  List<Like> likeTemp = [];
  for(int i=0;i<_likes.length;i++){
    if(_likes[i].kullanici == widget.currentUser!.email){
      likeTemp.add(_likes[i]);
    }
  }

  for(int j=0;j<reviews.length;j++){

    for(int k=0;k<likeTemp.length;k++){
    if(reviews[j].id == likeTemp[k].degerlendirmeId){
        usrersLikedReviews.add(reviews[j]);
    }
    }
    
  }
}


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchHastane();
    fetchReview();
    fetchUser();
    //fetchLike();
    FirebaseFirestore.instance.collection(FirebaseConstants.kullaniciCollection).snapshots().listen((event) {
      mapUser(event);
    });
    //fetchFavorite();
    fetchLike();
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

  int likeDetector(List<Like> likes){
    int count = 0;
    for(int i=0;i<likes.length;i++){
        if(likes[i].kullanici == widget.currentUser!.email){
          setState(() {
             count += 1;
          });
        }
    }
    return count;
  }



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

  Future chooseFile() async{
  
    file = await _imagePicker.pickImage(source: ImageSource.gallery);
    
    setState(() {
      newImageFilePath = file!.path;
    });
    print("DOSYA KONUMU :"+file!.path);

  } 

  ImagePicker _imagePicker = ImagePicker();
  XFile? file;

  String imageUrl = '';

  
    List<Review> userReviewsCalculate(){
    List<Review> sendedList = [];
    for(int i=0;i<reviews.length;i++){
              if(reviews[i].kullanici == widget.currentUser!.email){
                
                sendedList.add(reviews[i]);
                
              }
            }
    return sendedList;
  }

  Future<void> updateUser()async{
    AppUser newUser = AppUser(
      ad: widget.currentUser!.ad, 
    email: widget.currentUser!.email, 
    foto: imageUrl, 
    id: widget.currentUser!.id, 
    sifre: widget.currentUser!.sifre, 
    soyad: widget.currentUser!.soyad, 
    tc: widget.currentUser!.tc);
    await FirebaseFirestore.instance.collection("kullanici").doc(widget.docId).update(newUser.toJson());
    //await context.read<SigninViewProvider>().newcurrentUserr(newUser);
  }
  
  String newImageFilePath = "";

  String findRelatedUserwithList(){
    // eşleşen users'ın path'ı dönecek widgettan değil
    // user ile eşleşen
    for(int i=0;i<_users.length;i++){
      if(_users[i].email == widget.currentUser!.email){
        return _users[i].foto;
      }
    }
    return "";
  }
  @override
  Widget build(BuildContext context) {

    print("ŞUANKİ İSİM:" +widget.currentUser!.ad);
    //print("USER FOTO"+widget.currentUser!.foto);
    return Container(
      color: Colors.red,
      child: SafeArea(
        
        top: false,
        child: WillPopScope(
          onWillPop: ()async{
             return false;
          },
          child: Scaffold(
            //appBar: AppBar(title: Text("HomeView"),automaticallyImplyLeading: false,),
            extendBody: true,
            // incelensin
            body: 
            
            index==0 ?
            Column(
              children: [
                
                Container(
                  
            width: MediaQuery.of(context).size.width*1,
            height: MediaQuery.of(context).size.height*0.27,
            decoration: BoxDecoration(
           borderRadius: BorderRadius.only(bottomRight: Radius.circular(50),bottomLeft: Radius.circular(50)),
           border: Border(
            left: BorderSide()
          ),
            color: Colors.red
            ),
            child: Column(
          
          children: [
            SizedBoxHeight(height: 0.06),
            Row(
              children: [
                Stack(
                  children: [
                    /*Container(margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.07,right: MediaQuery.of(context).size.width*0.04),
                      width: MediaQuery.of(context).size.width*0.34,
                    height: MediaQuery.of(context).size.height*0.17,child:
                    CircleAvatar(radius: 30,backgroundColor: Colors.white,
                    backgroundImage:
                    
                     imageUrl.length > 0 ?  NetworkImage(imageUrl) : NetworkImage(widget.currentUser!.foto) 
                     ,)),*/
                     Container(margin: EdgeInsets.only(left: context.getWidth*0.07),
                          width: MediaQuery.of(context).size.width*0.36,
                      height: MediaQuery.of(context).size.height*0.18,
                          child: FullScreenWidget(
                            
                            disposeLevel: DisposeLevel.High,
                            child: ClipPath(
                              clipper: ShapeBorderClipper(shape: 
                              RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(100)))),
                              child: widget.currentUser!.foto == "assets/default.jpg" ? Image.asset("default".toJpg) : newImageFilePath.length > 0 ? Image.file(File(file!.path),fit: BoxFit.cover,) : Image.network(findRelatedUserwithList(),fit: BoxFit.cover,),),
                          )),
                     

                     /*Container(
                      decoration: BoxDecoration(border: Border.all(width: 1)
                      ,borderRadius: BorderRadius.circular(100)),
                      width: MediaQuery.of(context).size.width*0.34,
                      height: MediaQuery.of(context).size.height*0.17,
                      child: newImageFilePath.length > 0 ? Image.file(File(file!.path),fit: BoxFit.cover,) : Image.network(widget.currentUser!.foto,fit: BoxFit.cover,),
                     ),*/

                     
                        
                    Positioned(
                      bottom: 0,
                      right: MediaQuery.of(context).size.width*0.01,
                      child: IconButton(
                      onPressed: ()async{ 
                       await chooseFile();    
               
                      String uniqeFileName = DateTime.now().millisecondsSinceEpoch.toString();
                      Reference referenceRoot = FirebaseStorage.instance.ref();
                      Reference referenceDirImages = referenceRoot.child('user_photo');

                      Reference referenceImageToUpload = referenceDirImages.child(uniqeFileName);
                     
                      try{
                      await referenceImageToUpload
                      .putFile(File(file!.path), SettableMetadata(contentType: 'image/png'));
                      
                      imageUrl = await referenceImageToUpload.getDownloadURL();
                      
                      setState(() {
                        newImageFilePath = file!.path;
                        widget.currentUser!.foto = file!.path;
                      });
          
                      updateUser();
                      }
                      catch(error){
          
                      }
                      }, icon: Icon(Icons.camera_alt,color: Colors.white,size: MediaQuery.of(context).size.width*0.08,)),
                    ),
                        
                  ]
                ),
                Column(
               children: [
                
                 Row(
                   children: [
                     Container(
                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.02,left: MediaQuery.of(context).size.width*0.1),
                     child: Text("Değerlendirmeler",style: TextStyle(fontSize: 14,fontFamily: 'Poppins-Regular',
                     color: Colors.white,fontWeight: FontWeight.bold,),)),
                     IconButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => UserReviewsView(userReviews: userReviewsCalculate(),users: _users,currentUser: widget.currentUser!,)));
                     }, icon: Icon(Icons.outbox,size: 20,color: Colors.white,))
                   ],
                 ),
                 Container(margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.06),width: MediaQuery.of(context).size.width*0.39,height: MediaQuery.of(context).size.height*0.002,color: Colors.white,),
                 Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.005,left: MediaQuery.of(context).size.width*0.07,bottom: MediaQuery.of(context).size.height*0.01,),
                 child: Text(_reviewDetect().toString(),style: TextStyle(fontSize: 14,fontFamily: 'Poppins-Regular',
                 color: Colors.white,fontWeight: FontWeight.bold,),)),
          
                 Row(
                   children: [
                     Container(
                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.02,left: MediaQuery.of(context).size.width*0.1),
                      //margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1),
                     child: Text("Beğenilenler",style: TextStyle(fontSize: 14,fontFamily: 'Poppins-Regular',
                     color: Colors.white,fontWeight: FontWeight.bold,),)),

                      IconButton(onPressed: ()async{
                        await usersLikedReviews();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => UserLikesView(userReviews: usrersLikedReviews,users: _users,currentUser: widget.currentUser!,)));
                     }, icon: Icon(Icons.outbox,size: 20,color: Colors.white,))
                   ],
                 ),
                 Container(margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.07),width: MediaQuery.of(context).size.width*0.32,height: MediaQuery.of(context).size.height*0.002,color: Colors.white,),
                 Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.005,left: MediaQuery.of(context).size.width*0.07,bottom: MediaQuery.of(context).size.height*0.01),
                 child: Text(likeDetector(_likes).toString(),style: TextStyle(fontSize: 14,fontFamily: 'Poppins-Regular',
                 color: Colors.white,fontWeight: FontWeight.bold,),)),
                     
               ],
             ),
          
          
              ],
            ),
          
          
                 
          ],
            ),
          ),
          
          SizedBoxHeight(height: 0.02),
          
          // yapı card ve container yapısına alınsın listtile baypass edilsin
          Container(
            margin: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.59),
            child: Text("Tüm Hastaneler",style: TextStyle(
              fontFamily: 'Poppins-Regular',
            fontWeight: FontWeight.bold,color: Colors.black38,fontSize: 17),)),
          //Divider(thickness: 1.3),
          
          hospitals.length == 0  ? 
          
          Container(margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.25),child: Align(alignment: Alignment.center,child: CircularProgressIndicator(color: Colors.red,)))
          
          :
          
          Expanded(
            
            child: ListView.builder(
              itemCount: hospitals.length,
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
                    await fetchLike();
                    //await fetchFavorite();
                    int oneStar = 0;
                    int twoStar = 0;
                    int threeStar = 0;
                    int fourStar = 0;
                    int fiveStar = 0;
                    for(int i=0;i<reviews.length;i++){

                      if(hospitals[index].ad == reviews[i].hastane){
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
                      docId: widget.docId,
                      users: _users,
                      reviews: int.parse(calculateReviews(hospitals[index].ad)),
                      avarageStar: calculateStar(hospitals[index].ad),
                      hospital: hospitals[index],
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
                        child: Image.asset(fit: BoxFit.cover,hospitals[index].foto))),
                  
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
                            child: Text(clipText(hospitals[index].ad,19),style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Poppins-Regular'),)),
                  
                            Container(
                              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.023),
                              /*decoration: BoxDecoration(border: Border.all(width: 1
                              )),*/width: MediaQuery.of(context).size.width*0.2,height: MediaQuery.of(context).size.height*0.03,
                              child: Row(children: [
                                Icon(Icons.star,size: 20,color: Colors.amber,),
                                Text("${calculateStar(hospitals[index].ad).toStringAsFixed(1)}",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Poppins-Regular'),),
                                Text(" "),
                                Text("(${calculateReviews(hospitals[index].ad)}+)",style: TextStyle(color: Colors.black54,fontSize: 12,fontFamily: 'Poppins-Regular'))]),)
                                //                              Text("( ${int.parse(calculateReviews(hospitals[index].ad)) != 0  ? calculateReviews(hospitals[index].ad)+"+" : "0"} )",style: TextStyle(color: Colors.black54,fontSize: 12,fontFamily: 'Poppins-Regular'))]),)
          
                          ],
                        ),
                       
                        Container(
                        /*decoration: BoxDecoration(border: Border.all(width: 1
                        )),*/
                        height: MediaQuery.of(context).size.height*0.05,
                        width: MediaQuery.of(context).size.width*0.53,margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.004),
                        child: Text(clipText(hospitals[index].adres, hospitals[index].adres.length),style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.black54),)),
                      ],
                    )
                  ]),),
                )
              );
              },
              
            ),
          ),
          
          
          
                
                
                
           
          
              ],
            )
            :
            screens[index],
          
          bottomNavigationBar: CurvedNavigationBar(
            key: _navigationKey,
            backgroundColor: Colors.transparent,
            buttonBackgroundColor: Colors.redAccent,
            color: Colors.red,
            height: MediaQuery.of(context).size.height*0.07,
            animationCurve: Curves.easeInOut,
            animationDuration: Duration(milliseconds: 300),
            index: index,
            items: items,
            onTap: (index) =>
            setState(() {
              this.index = index;
             
            })
            
            ),
          ),
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

