import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_ex/product/widget/apptext.dart';
import 'package:flutter_google_maps_ex/core/components/failure_snackbar.dart';
import 'package:flutter_google_maps_ex/core/components/sizedbox_height.dart';
import 'package:flutter_google_maps_ex/core/extension/image_extension.dart';
import 'package:flutter_google_maps_ex/feature/auth/signin/viewModel/signin_viewModel.dart';
import 'package:flutter_google_maps_ex/feature/auth/signup/view/signup_view.dart';
import 'package:flutter_google_maps_ex/feature/home/view/home_view.dart';
import 'package:flutter_google_maps_ex/product/model/app_user.dart';
import 'package:flutter_google_maps_ex/product/service/firebase/auth/signin_service.dart';
import 'package:flutter_google_maps_ex/product/utility/constants/firebase_constants.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

part 'widget/signin_animation.dart';
part 'widget/signin_emailText.dart';
part 'widget/signin_emailTextFF.dart';
part 'widget/signin_sifreText.dart';
part 'widget/signin_olustur.dart';
part 'widget/signin_sifreTextFF.dart';
part 'widget/signin_button.dart';

class SigninView extends StatefulWidget {

  @override
  State<SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {

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

    //notifyListeners();

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUser();
  }

  final _formkey = GlobalKey<FormState>();

  TextEditingController _mailController = TextEditingController();

  TextEditingController _sifreController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //var provider = context.watch<SigninViewProvider>();
    //context.read<SigninViewProvider>().zeroedUser();
    print("USERSLAR : "+ _users.length.toString());
                //print(" E ANASAYFADAYIM " + FirebaseAuth.instance.currentUser.email.toString() + "UİD :"+FirebaseAuth.instance.currentUser!.uid.toString());

    return WillPopScope(
      onWillPop: ()async{
        return false;
      },
      child: Scaffold(  
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: [
            
                _SigninAnimation(),
                SizedBoxHeight(height: 0.05),

                Form(key: _formkey,child: Column(
                  
                  children: [
            
                  _SigninEmailText(),
                  SizedBoxHeight(height: 0.013),
                  _SigninEmailTextFF(mailController: _mailController,),
                      
                    
                  SizedBoxHeight(height: 0.02),
                  _SinginSifreText(),
                  SizedBoxHeight(height: 0.013),
                  _SigninSifreTextFF(sifreController: _sifreController),

                  
                  SizedBoxHeight(height: 0.03),
                  _SigninOlustur(users: _users),
                  SizedBoxHeight(height: 0.02),

                  _SigninButton(mailController: _mailController, sifreController: _sifreController, formKey: _formkey,users: _users,)
                  ],
                ), ),            
              ],
            ),
          ),
      
      ),
    );
  }
}