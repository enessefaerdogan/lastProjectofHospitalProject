
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_google_maps_ex/core/components/sizedbox_width.dart';
import 'package:flutter_google_maps_ex/core/extension/mediaquery_extension.dart';
import 'package:flutter_google_maps_ex/product/model/app_user.dart';
import 'package:flutter_google_maps_ex/product/model/message.dart';
import 'package:flutter_google_maps_ex/product/utility/constants/firebase_constants.dart';
import 'package:intl/intl.dart';

class ChatView extends StatefulWidget {
  AppUser chatedUser;
  bool specialChatPage;
  ChatView({required this.chatedUser, required this.specialChatPage});

  @override
  State<ChatView> createState() => _ChatViewState();
}

bool showDelete = false;
class _ChatViewState extends State<ChatView> {
   getSenderView(CustomClipper clipper, BuildContext context, String message) => ChatBubble(
        clipper: clipper,
        alignment: Alignment.topRight,
        margin: EdgeInsets.only(top: 20),
        backGroundColor: Color.fromARGB(255, 247, 97, 87),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

  getReceiverView(CustomClipper clipper, BuildContext context,String message) => ChatBubble(
        clipper: clipper,
        backGroundColor: Color(0xffE7E7ED),
        margin: EdgeInsets.only(top: 20),
        child: InkWell(
          onLongPress: (){
            // burada 
            setState(() {
              showDelete = true;
            });
          },
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: Text(
              message,
              style: TextStyle(color: Colors.black),
            ),
            ),
        ));

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
    // ek tarama
    for(int i=0;i<_datas.length;i++){
      if((_datas[i].alankullanici == FirebaseAuth.instance.currentUser!.email && _datas[i].atankullanici == widget.chatedUser.email) || 
      ((_datas[i].atankullanici == FirebaseAuth.instance.currentUser!.email && _datas[i].alankullanici == widget.chatedUser.email))){
          
          _messages.add(_datas[i]);

      }
    }
    
  });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchMessages();
  }

  int calculateNewQuery(){
    int num = 0;
    for(int i=0;i<_messages.length;i++){
      if(_messages[i].sira>num){
        setState(() {
          num = _messages[i].sira;
        });
      }
    }
    return num+1;
  }
  
  addMessage()async{
    Message newMessage = 
      Message(
      alankullanici: widget.chatedUser.email, 
      atankullanici: FirebaseAuth.instance.currentUser!.email!, 
      id: "id", 
      mesaj: _messageController.text, 
      saat: DateFormat('kk:mm').format(DateTime.now()), 
      sira: calculateNewQuery(), 
      tarih: DateFormat('dd.MM.yyyy').format(DateTime.now()));
    await FirebaseFirestore.instance.collection(FirebaseConstants.mesajCollection).add(newMessage.toJson());
    setState(() {
      _messages.add(newMessage);
    });
  }

  TextEditingController _messageController = TextEditingController();

  final player = AudioPlayer();
  sound(String myAudio)async{
    await player.play(AssetSource(myAudio));
  }

  @override
  Widget build(BuildContext context) {
    print("SAAT :" + DateFormat('kk:mm').format(DateTime.now()));
    print("MESSAGES:"+_messages.length.toString());
    return WillPopScope(
      onWillPop: ()async{
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){
          
          Navigator.pop(context, _messages);
      
        }, icon: Icon(Icons.chevron_left,color: Colors.white,))
        ,
        backgroundColor: Colors.red,
        title: Row(
          children: [
            Container(
                                            margin: EdgeInsets.only(//left: MediaQuery.of(context).size.width*0.01,
                                            top: MediaQuery.of(context).size.width*0.01),
                                            width: MediaQuery.of(context).size.width*0.11,
                                            height: MediaQuery.of(context).size.height*0.055,
                                            child: CircleAvatar(radius: 30,backgroundColor: Colors.white,backgroundImage: NetworkImage(widget.chatedUser.foto))),
                                                      SizedBoxWidth(width: 0.03),
            Text(widget.chatedUser!.ad + " " + widget.chatedUser!.soyad ,style: 
            TextStyle(fontFamily: 'Poppins-Regular',color: Colors.white,fontSize: 17),),
          ],
        ),),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              Container(
                //decoration: BoxDecoration(border: Border.all(width: 1)),
                height: context.getHeight*0.8,
                child: ListView.builder(physics: ScrollPhysics(),shrinkWrap: true,itemCount: _messages.length,itemBuilder: (context,index){
                  return  
                  
                  _messages[index].atankullanici == FirebaseAuth.instance.currentUser!.email ?
                  getSenderView(
                  ChatBubbleClipper1(type: BubbleType.sendBubble), context,_messages[index].mesaj)
                  :
                   getReceiverView(
                  ChatBubbleClipper1(type: BubbleType.receiverBubble), context,_messages[index].mesaj);
          
                }),
              ),
          
          
              Row(
                children: [
                  Container(
                                margin: EdgeInsets.only(left: context.getWidth*0.01),
                                width: MediaQuery.of(context).size.width*0.8,
                                height: context.getHeight*0.07,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Mesaj',
                                    enabledBorder: OutlineInputBorder(
                          borderSide:
                      BorderSide(width: 2, color: Colors.black38), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(20.0),
                    
                          
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:  BorderSide(
                    color: Colors.black,
                    width: 2,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                    color: Colors.redAccent,
                    width: 2,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),prefixIcon: Icon(Icons.message)),
                        
                        
                                  controller: _messageController,
                                  
                                ),
                              ),
          
                IconButton(
                  onPressed: ()async{
                    
                    if(_messageController.text.length>0){
                    await sound("sound/message_sendedd.wav");
                    addMessage();
                    _messageController.clear();
                    }
      
                }, icon: Icon(size:55,Icons.telegram,color: Colors.red,))
          
          
                ],
              )
            ],
          ),
        ),
      
      ),
    );
  }
}