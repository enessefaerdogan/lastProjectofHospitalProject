

import 'package:flutter/material.dart';
import 'package:flutter_google_maps_ex/product/widget/apptext.dart';
import 'package:flutter_google_maps_ex/core/extension/image_extension.dart';
import 'package:flutter_google_maps_ex/core/extension/mediaquery_extension.dart';
import 'package:flutter_google_maps_ex/feature/spam/view/spam_view.dart';
import 'package:flutter_google_maps_ex/product/model/app_user.dart';
import 'package:flutter_google_maps_ex/product/model/review.dart';

class ReviewView extends StatelessWidget {
  Review myReview;
  AppUser myUser;
  AppUser currentUser;
  ReviewView({required this.myReview, required this.myUser, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.red,
      title: Text("İncele",style:TextStyle(fontFamily: 'Poppins-Regular',color: Colors.white,fontSize: 17),),leading: IconButton(onPressed: (){

          Navigator.pop(context);

      }, icon: Icon(Icons.chevron_left,color: Colors.white,)),),
      body: SingleChildScrollView(
        child: Column(
        
          children: [
            Container(
               //: BoxDecoration(border: Border.all(width: 1)),
                                  width: MediaQuery.of(context).size.width*1,
                                  //height: MediaQuery.of(context).size.height*0.17,
                                  child: Card(
                                    elevation: 1,
                                    color: Colors.white,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        
                                        Container(
                                       //    decoration: BoxDecoration(border: Border.all(width: 1)),
                                          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.015,
                                          top: MediaQuery.of(context).size.width*0.015),
                                          width: MediaQuery.of(context).size.width*0.16,
                                          height: MediaQuery.of(context).size.height*0.08,
                                          child: CircleAvatar(radius: 30,backgroundColor: Colors.white,backgroundImage: NetworkImage(myUser.foto) ,)),
                                
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(context).size.width*0.53,
                                                    //decoration: BoxDecoration(border: Border.all(width: 1)),
                                                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.007,
                                                  left: MediaQuery.of(context).size.width*0.03),child: Text("${myUser.ad} ${myUser.soyad}",style: TextStyle(color: Colors.black,fontFamily: 'Poppins-Regular'),)),
                                                  Container(
                                                    //decoration: BoxDecoration(border: Border.all(width: 1)),
                                                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.007,
                                                  left: MediaQuery.of(context).size.width*0.01),child: Text(myReview.tarih,style: TextStyle(color: Colors.black45,fontFamily: 'Poppins-Regular'),)),
                                                ],
                                              ),
                                
                                              Container(
                                                margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.star,color: Colors.amber,),
                                                    Text(myReview.puan,style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.black),),
                                
                                                  ],
                                                ),
                                              ),
                                
                                
                                               // devamını oku benzeri bir yapı lazım
                                               Container(
                                                width: MediaQuery.of(context).size.width*0.7,
                                                //height: MediaQuery.of(context).size.height*0.05,
                                                //decoration: BoxDecoration(border: Border.all(width: 1)),
                                                margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03,top: MediaQuery.of(context).size.height*0.01),
                                                child: Text(myReview.yorum,style: TextStyle(fontFamily: 'Poppins-Regular',color: Colors.black54),),
                                              ),
                                              SizedBox(height: context.getHeight*0.03,),

                                              
                                    
                                
                                            ],
                                          )
                                      ],
                                    ),
                                  ),
                                )
        
          ],
        ),
      ),

    );
  }
}