
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_ex/core/extension/image_extension.dart';
import 'package:flutter_google_maps_ex/core/extension/mediaquery_extension.dart';
import 'package:flutter_google_maps_ex/feature/chat/view/chat_view.dart';
import 'package:flutter_google_maps_ex/product/model/app_user.dart';
import 'package:flutter_google_maps_ex/product/model/message.dart';
import 'package:flutter_google_maps_ex/product/utility/constants/firebase_constants.dart';
import 'package:flutter_google_maps_ex/product/widget/apptext.dart';
import 'package:flutter_google_maps_ex/product/widget/indicator.dart';

class ChatsView extends StatefulWidget {
  bool? specialChatPage;
  AppUser? chatedUser;
  List<Message>? updatedMessages;
  //List<AppUser>? chatedUsers;
  //bool? generalChatPage;
  ChatsView({this.specialChatPage, this.chatedUser, this.updatedMessages});

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {

  List<String> _chatedUsersMails = [];
  Future<void> fetchRelatedMessages()async{
    // mesajlardan çekicez  
    var response = await FirebaseFirestore.instance.collection(FirebaseConstants.mesajCollection).get();
    mapRelatedMessages(response);
  }
  
  mapRelatedMessages(QuerySnapshot<Map<String,dynamic>> datas){
    final _datas = datas.docs.map((item) => 
    Message(alankullanici: item["alankullanici"], 
    atankullanici: item["atankullanici"], 
    id: item.id, 
    mesaj: item["mesaj"], 
    saat: item["saat"], 
    sira: item["sira"], 
    tarih: item["tarih"])).toList();

    setState(() {
      for(int i=0;i<_datas.length;i++){
        if((_datas[i].atankullanici == FirebaseAuth.instance.currentUser!.email) || (_datas[i].alankullanici == FirebaseAuth.instance.currentUser!.email)){
             //ilişki mesajdır
              _chatedUsersMails.add(
                _datas[i].atankullanici ==  FirebaseAuth.instance.currentUser!.email ? _datas[i].alankullanici : 
                _datas[i].atankullanici  
              );
        }
      }
      
    });
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
     // 
    });
  }

  List<AppUser> _criticChatedUsers = [];
  calculateCriticChated(){
    _criticChatedUsers = [];
    // kullanıcılar içinde geziyoruz
    // chatleştiğim maille eşleşiyorsa kullanıcı 
    // 
    for(int i=0;i<_users.length;i++){
        for(int j=0;j<_chatedUsersMails.length;j++){
          if(_chatedUsersMails[j] == _users[i].email){
              bool contains = false;
              for(int n=0;n<_criticChatedUsers.length;n++){
                if(_criticChatedUsers[n].email == _users[i].email){
                  setState(() {
                    contains = true;
                  });
                    
                }

              }
              if(contains == false){
                  // daha önce yokmuş
                    _criticChatedUsers.add(_users[i]);  
                }
              print("EKLENDİ:"+_users[i].email);
            
          }
        }
      }
      setState(() {
        isLoading = false;
      });
  }

  bool isLoading = true;
   List<Message> _messages = [];
  Future<void> fetchMessages()async{
    // mesajlardan çekicez  
    var response = await FirebaseFirestore.instance.collection(FirebaseConstants.mesajCollection)
    .where(Filter.or(Filter("alankullanici", isEqualTo: FirebaseAuth.instance.currentUser!.email)
    ,Filter("atankullanici", isEqualTo: FirebaseAuth.instance.currentUser!.email)))
    .orderBy("sira", descending: false)
    .get();
    mapMessages(response);
  }
  mapMessages(QuerySnapshot<Map<String,dynamic>> datas){
  final _datas = datas.docs.map((item) => Message(
  alankullanici: item["alankullanici"], 
  atankullanici: item["atankullanici"], 
  id: item.id, 
  mesaj: item["mesaj"], 
  saat: item["saat"], 
  sira: item["sira"], 
  tarih: item["tarih"])).toList();
 setState(() {
       // metod burada çağrılsın
    // ek tarama
          _messages = _datas;
          print("GELEN MESAJLAR:"+_messages.length.toString());
 });

    

  }

  List<Message> createCurrentMessages(List<Message> temperMessageList){
    int contains = 0;
    for(int i=0;i<widget.updatedMessages!.length;i++){
      setState(() {
        contains = 0;
      });
      for(int j=0;j<temperMessageList.length;j++){


        if((temperMessageList[j].atankullanici == widget.updatedMessages![i].atankullanici) && 
        (temperMessageList[j].sira == widget.updatedMessages![i].sira)){
            // aynılarsa 
            setState(() {
              contains +=1;
              
            });
            break;
        }
      }
      if(contains == 0 ){
        setState(() {
                  temperMessageList.add(widget.updatedMessages![i]);
        });

      }
    }
    print("TEMPER SON DURUM:"+temperMessageList.length.toString());
    return temperMessageList;
  }

  Message returnLastMessage(String listUserMail){
  Message myTempMessage = Message(alankullanici: "alankullanici", atankullanici: "atankullanici", id: "id", mesaj: "mesaj", saat: "saat", sira: -1, tarih: "tarih");
  List<Message> temperMessageList = queryRelatedMessagesForListUser(listUserMail);// alakalı liste alındı 
  //int num = 0;
  for(int i=0;i<temperMessageList.length;i++){
    if(temperMessageList[i].sira > myTempMessage.sira){
      setState(() {
        myTempMessage = temperMessageList[i];
      });
    }
  }
  return myTempMessage;
  }


  List<Message> queryRelatedMessagesForListUser(String listUserMail){// buraya indexe düşen kişi verilir
  List<Message> temperMessageList = [];
 for(int i=0;i<_messages.length;i++){
      if((_messages[i].alankullanici == FirebaseAuth.instance.currentUser!.email && _messages[i].atankullanici == listUserMail) || 
      ((_messages[i].atankullanici == FirebaseAuth.instance.currentUser!.email && _messages[i].alankullanici == listUserMail))){
          
          temperMessageList.add(_messages[i]);

      }
    }
    // eğer bir önceki sayfadan mesaj geldiyse onu baz al yoksa kendin bul
    // burda düzgün bir birleştirme yapılmalı
    //return widget.updatedMessages!.length>0 ? createCurrentMessages(temperMessageList) : temperMessageList;
    return temperMessageList; 
  }

  String clipText(String text,int clipIndex){
  if(text.length<29){
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
 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchMessages();
    fetchRelatedMessages();
    fetchUser();
    calculateCriticChated();
    widget.updatedMessages = [];
    
  }
  List<Message> lastmassages = [];
  fillLastMassages(){
    lastmassages = [];
    for(int i=0;i<_chatedUsersMails.length;i++){
      setState(() {
        int contains = 0;
        for(int j=0;j<lastmassages.length;j++){
          if(returnLastMessage(_chatedUsersMails[i]).id == lastmassages[j].id){
            contains += 1;// içeriyor
            break;
          }
        }
        if(contains == 0){
              lastmassages.add(returnLastMessage(_chatedUsersMails[i]));
              print("LASTMASSAGEADDED:"+returnLastMessage(_chatedUsersMails[i]).mesaj.toString());
        }

      });
    }
    print("LASTLER:"+lastmassages.length.toString());
    print("YAZIYORUM...");
    for(int i=0;i<lastmassages.length;i++){
      print(lastmassages[i].mesaj.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    print("BUKADARMESAJ:"+_chatedUsersMails.length.toString());
    calculateCriticChated();
    print("SON MESAJ: "+returnLastMessage("mehmet@gmail.com").mesaj.toString());
    print(_criticChatedUsers.length);
    fillLastMassages();
    print("TOTAL MESAJLAR"+widget.updatedMessages!.length.toString());
    return Scaffold(

      appBar: AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.red,
      title: Text("Sohbet",style: 
      TextStyle(fontFamily: 'Poppins-Regular',color: Colors.white,fontSize: 17),),),

      body: 
      
      _criticChatedUsers.length>0 && isLoading==false ?
      ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: _criticChatedUsers.length,itemBuilder: (context,index){
        return Container(
                                width: MediaQuery.of(context).size.width*0.1,
                                height: MediaQuery.of(context).size.height*0.1,
                                child: GestureDetector(
                                  onTap: ()async{
                                  
                                  widget.updatedMessages =  await Navigator.push(context, MaterialPageRoute(builder: (context) => ChatView(chatedUser: _criticChatedUsers[index], specialChatPage: false)));
                                 setState(() {
                                   
                                 });
                                  },
                                  child: Card(
                                    shadowColor: Colors.redAccent,
                                    elevation: 2,
                                    color: Colors.white,
                                    child: Container(
                                      //decoration: BoxDecoration(border: Border.all(width: 1)),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          
                                          Container(
                                            //decoration: BoxDecoration(border: Border.all(width: 1)),
                                            margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.03,
                                            top: MediaQuery.of(context).size.width*0.02),
                                            width: MediaQuery.of(context).size.width*0.14,
                                            height: MediaQuery.of(context).size.height*0.07,
                                            child: CircleAvatar(radius: 30,backgroundColor: Colors.white,backgroundImage: NetworkImage(_criticChatedUsers[index].foto))),
                                      
                                                     // AppText.appText("${_criticChatedUsers[index].ad + " " + _criticChatedUsers[index].soyad}", 17, Colors.black, FontWeight.normal)
                                                               Container(
                                                                //decoration: BoxDecoration(border: Border.all(width: 1)),
                                                                width: context.getWidth*0.6,
                                                                 child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  
                                                                   children: [
                                                                     Container(
                                                                      margin: EdgeInsets.only(left: context.getWidth*0.04,top: context.getHeight*0.015),
                                                                      child: Text("${_criticChatedUsers[index].ad + " " + _criticChatedUsers[index].soyad}", style: TextStyle(color: Colors.black,fontSize: 16,fontFamily: 'Poppins-Regular'),),),
                                                                      
                                                                      Container(
                                                                        margin: EdgeInsets.only(left: context.getWidth*0.04,),
                                                                        //decoration: BoxDecoration(border: Border.all(width: 1)),
                                                                        child: Row(
                                                                          children: [
                                                                            // eğer atan bensem görüldü işareti koy, alan bensem koyma
                                                                            lastmassages[index].alankullanici == FirebaseAuth.instance.currentUser!.email ? Text("") : Container(width: context.getWidth*0.05,child: Image.asset("double_check".toPng)), 
                                                                            Container(margin: EdgeInsets.only(left: context.getWidth*0.01),child: Text(clipText(lastmassages[index].mesaj,22),style: TextStyle(color: Colors.black54),)),
                                                                          ],
                                                                        ))
                                                                   ],
                                                                 ),
                                                               ),

                                                               Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                children: [
                                                                  Text(lastmassages[index].tarih,style: TextStyle(color: Colors.black54)),
                                                                  Text(lastmassages[index].saat,style: TextStyle(color: Colors.black54)),
                                                                ],
                                                               )       
                                            
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
      })
      :
      isLoading ?
      Indicator.circularProgressIndicator()
      :
      // yüklendisye ve hiçbirşey yoksa
      // buraya sohbet bulunamadı şeklinde bir yapı eklensin
      SizedBox.shrink()
      
      


    );
  }
}