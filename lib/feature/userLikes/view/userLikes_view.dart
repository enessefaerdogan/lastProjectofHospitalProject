

import 'package:flutter/material.dart';
import 'package:flutter_google_maps_ex/core/extension/image_extension.dart';
import 'package:flutter_google_maps_ex/core/extension/mediaquery_extension.dart';
import 'package:flutter_google_maps_ex/feature/review/view/review_view.dart';
import 'package:flutter_google_maps_ex/feature/userDetail/view/userDetail_view.dart';
import 'package:flutter_google_maps_ex/product/model/app_user.dart';
import 'package:flutter_google_maps_ex/product/model/review.dart';
import 'package:lottie/lottie.dart';

class UserLikesView extends StatefulWidget {
  List<Review> userReviews;
  List<AppUser> users;
  AppUser currentUser;
  UserLikesView({required this.userReviews, required this.users, required this.currentUser});

  @override
  State<UserLikesView> createState() => _UserLikesViewState();
}

class _UserLikesViewState extends State<UserLikesView> {
  String findRelatedUserwithReview(Review relatedReview){
    // user ile eşleşen
    for(int i=0;i<widget.users.length;i++){
      if(widget.users[i].email == relatedReview.kullanici){
        return widget.users[i].foto;
      }
    }
    return "";
  }
  AppUser findRelatedUserwithReview2(Review relatedReview){
    // user ile eşleşen
    for(int i=0;i<widget.users.length;i++){
      if(widget.users[i].email == relatedReview.kullanici){
        return widget.users[i];
      }
    }
    return AppUser(ad: "ad", email: "email", foto: "foto", id: "id", sifre: "sifre", soyad: "soyad", tc: "tc");
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
  @override
  Widget build(BuildContext context) {
    print(widget.userReviews.length);
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.red,
      title: Text("Beğenilenler",style: 
      TextStyle(fontFamily: 'Poppins-Regular',color: Colors.white,fontSize: 17),),leading: IconButton(onPressed: (){

        Navigator.pop(context);

      }, icon: Icon(Icons.chevron_left,color: Colors.white,)),),

      body: 
      
      
      widget.userReviews.length>0 ?
      ListView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: widget.userReviews.length,
                              itemBuilder: ((context, index) {
                                  
                              return Container(
                                width: MediaQuery.of(context).size.width*0.95,
                                height: MediaQuery.of(context).size.height*0.15,
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewView(myReview:widget.userReviews[index], myUser: findRelatedUserwithReview2(widget.userReviews[index]), currentUser: widget.currentUser,)));
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
                                          child: CircleAvatar(radius: 30,backgroundColor: Colors.white,backgroundImage: NetworkImage(findRelatedUserwithReview(widget.userReviews[index])) ,)),
                                                                
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(context).size.width*0.53,
                                                    //decoration: BoxDecoration(border: Border.all(width: 1)),
                                                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.007,
                                                  left: MediaQuery.of(context).size.width*0.03),child: Text("${findUser(widget.users,widget.userReviews[index]).ad + " " + findUser(widget.users,widget.userReviews[index]).soyad} ",style: TextStyle(color: Colors.black,fontFamily: 'Poppins-Regular'),)),
                                                  Container(
                                                    //decoration: BoxDecoration(border: Border.all(width: 1)),
                                                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.007,
                                                  left: MediaQuery.of(context).size.width*0.01),child: Text(widget.userReviews[index].tarih,style: TextStyle(color: Colors.black45,fontFamily: 'Poppins-Regular'),)),
                                                ],
                                              ),
                                                                
                                              Container(
                                                margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.star,color: Colors.amber,),
                                                    Text(widget.userReviews[index].puan,style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.black),),
                                                                
                                                  ],
                                                ),
                                              ),
                                                                
                                                                
                                               // devamını oku benzeri bir yapı lazım
                                               Container(
                                                width: MediaQuery.of(context).size.width*0.7,
                                                height: MediaQuery.of(context).size.height*0.05,
                                                //decoration: BoxDecoration(border: Border.all(width: 1)),
                                                margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03,top: MediaQuery.of(context).size.height*0.01),
                                                child: Text(clipText(widget.userReviews[index].yorum, 70),style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.black54),),
                                              ),
                                              SizedBox(height: context.getHeight*0.005,),

                                             
                                                                
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

                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.3,
                                      height: MediaQuery.of(context).size.height*0.15,child: Lottie.asset("commentNotFound".lottieToJson)),
                                    Container(
                                      margin: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.05),child: Center(child: Text("Henüz Beğeni Yok",style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.black54,fontSize: 15),))),
                                  ],
                                ),
                              ],
                            )

    );  
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
}