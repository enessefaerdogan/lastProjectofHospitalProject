


import 'package:flutter/material.dart';
import 'package:flutter_google_maps_ex/core/components/sizedbox_height.dart';
import 'package:flutter_google_maps_ex/core/extension/mediaquery_extension.dart';
import 'package:flutter_google_maps_ex/feature/chat/view/chat_view.dart';
import 'package:flutter_google_maps_ex/feature/chats/view/chats_view.dart';
import 'package:flutter_google_maps_ex/feature/home/view/home_view.dart';
import 'package:flutter_google_maps_ex/feature/userProfile/viewModel/userProfile_viewModel.dart';
import 'package:flutter_google_maps_ex/product/model/app_user.dart';
import 'package:flutter_google_maps_ex/product/widget/apptext.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:provider/provider.dart';

class UserDetailView extends StatefulWidget {
  AppUser detailedUser;
  UserDetailView({required this.detailedUser});

  @override
  State<UserDetailView> createState() => _UserDetailViewState();
}

class _UserDetailViewState extends State<UserDetailView> {
  @override
  Widget build(BuildContext context) {
    print("DETAILED : " + widget.detailedUser.email);
    return Scaffold(

appBar: AppBar(
      backgroundColor: Colors.red,
      title: Text("Kullanıcı Detay",style: 
      TextStyle(fontFamily: 'Poppins-Regular',color: Colors.white,fontSize: 17),),leading: IconButton(onPressed: (){

        Navigator.pop(context);

      }, icon: Icon(Icons.chevron_left,color: Colors.white,)),),

body: SingleChildScrollView(
  child: Column(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.01),
                width: MediaQuery.of(context).size.width*0.93,
                height: MediaQuery.of(context).size.height*0.86,
                child: Column(
                  children: [
                    SizedBoxHeight(height: 0.03),
                
                    FullScreenWidget(
                      disposeLevel: DisposeLevel.High,
                      child: Container(
                                            margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.015,
                                            top: MediaQuery.of(context).size.width*0.015),
                                            width: MediaQuery.of(context).size.width*0.5,
                                            height: MediaQuery.of(context).size.height*0.25,
                                            child: CircleAvatar(radius: 30,backgroundColor: Colors.white,backgroundImage: NetworkImage(widget.detailedUser.foto) ,)),
                    ),
                                          SizedBoxHeight(height: 0.03),
                
                    Container(
                      width: context.getWidth*0.88,
                      height: context.getHeight*0.45,
                      child: Card(
                        shadowColor: Colors.red,
                        elevation: 5,
                        child: Column(
                          children: [
                            Container(
                              //margin: EdgeInsets.only(left: context.getWidth*0.13),
                              child: ListTile(
                              leading: Container(width: MediaQuery.of(context).size.width*0.1,
                              height: MediaQuery.of(context).size.height*0.05,child: Icon(Icons.mail,color: Colors.black,)),
                              title: AppText.appText("E-mail",10,Colors.black,FontWeight.normal),//Text(_currentUser.email),
                              subtitle:  AppText.appText(widget.detailedUser.email,15,Colors.black,FontWeight.normal),
                              ),
                            ),
                            Container(
                        //margin: EdgeInsets.only(left: context.getWidth*0.13),
                        child: ListTile(
                        leading: Container(width: MediaQuery.of(context).size.width*0.1,
                        height: MediaQuery.of(context).size.height*0.05,child: Icon(Icons.info,color: Colors.black,)),
                        title: AppText.appText("Ad",10,Colors.black,FontWeight.normal),//Text(_currentUser.email),
                        subtitle: AppText.appText(widget.detailedUser.ad,15,Colors.black,FontWeight.normal),
                        ),
                      ),
                      Container(
                        //margin: EdgeInsets.only(left: context.getWidth*0.13),
                        child: ListTile(
                        leading: Container(width: MediaQuery.of(context).size.width*0.1,
                        height: MediaQuery.of(context).size.height*0.05,child: Icon(Icons.info,color: Colors.black,)),
                        title: AppText.appText("Soyad",10,Colors.black,FontWeight.normal), 
                        subtitle: AppText.appText(widget.detailedUser.soyad,15,Colors.black,FontWeight.normal),//Text(_currentUser.email),
                        ),
                      ),
                      Divider(indent: context.getWidth*0.13,endIndent: context.getWidth*0.13,),
                
                      Container(
                        //margin: EdgeInsets.only(left: context.getWidth*0.13),
                        child: ListTile(
                        onTap: (){
                          // mesaj sayfasına gidiş
                          // özel olarak adamın chat'e yönlensin
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView()));
  
                          // sadece özel sohbet sayfasını aç!
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatView(specialChatPage: true, chatedUser: widget.detailedUser)));
                        },
                        leading: Container(width: MediaQuery.of(context).size.width*0.1,
                        height: MediaQuery.of(context).size.height*0.05,child: Icon(Icons.message,color: Colors.black,)),
                        title: AppText.appText("Mesaj",10,Colors.black,FontWeight.normal), 
                        subtitle: AppText.appText("Mesaj gönder",15,Colors.black,FontWeight.normal),//Text(_currentUser.email),
                        ),
                      ),
                          ],
                        ),
                      ),
                    ),
                    
                
                   
                    
                    
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