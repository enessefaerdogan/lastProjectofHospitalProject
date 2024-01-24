import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_ex/product/widget/apptext.dart';
import 'package:flutter_google_maps_ex/product/widget/indicator.dart';
import 'package:flutter_google_maps_ex/core/components/success_snackbar.dart';
import 'package:flutter_google_maps_ex/feature/auth/signin/view/signin_view.dart';
import 'package:flutter_google_maps_ex/feature/changeUserInfo/view/changeUserInfo_view.dart';
import 'package:flutter_google_maps_ex/feature/home/view/home_view.dart';
import 'package:flutter_google_maps_ex/feature/userProfile/viewModel/userProfile_viewModel.dart';
import 'package:flutter_google_maps_ex/product/model/app_user.dart';
import 'package:flutter_google_maps_ex/product/service/firebase/auth/signout_service.dart';
import 'package:flutter_google_maps_ex/product/utility/constants/firebase_constants.dart';
import 'package:flutter_google_maps_ex/product/utility/enum/infoType_enum.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

part 'widget/userProfile_title.dart';
part 'widget/userProfile_email.dart';
part 'widget/userProfile_sifre.dart';
part 'widget/userProfile_tc.dart';
part 'widget/userProfile_ad.dart';
part 'widget/userProfile_soyad.dart';
part 'widget/userProfile_indicator.dart';
part 'widget/userProfile_appbar.dart';

class UserProfileView extends StatefulWidget {
  UserProfileView({super.key});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {

  final _formkey = GlobalKey<FormState>();
  TextEditingController _mailController = TextEditingController();
  TextEditingController _sifreController = TextEditingController();
  TextEditingController _tcController = TextEditingController();
  TextEditingController _adController = TextEditingController();
  TextEditingController _soyadController = TextEditingController();  
  @override
  Widget build(BuildContext context) {
    var provider1 = context.watch<UserProfileViewProvider>();
    context.read<UserProfileViewProvider>().findCurrentUser();
    context.read<UserProfileViewProvider>().checkUser();
    //print(" TURNEDUSER " + context.watch<UserProfileViewProvider>().turnedAppUser.email);
    //print("ŞUANKİ KULLANICIM BABA :" +context.watch<UserProfileViewProvider>().currentUser.ad);
    return Scaffold(
      backgroundColor: const Color.fromARGB(60, 194, 178, 178),
      appBar: _UserProfileAppBar(),

    body: SingleChildScrollView(
      child: 
      
      context.read<UserProfileViewProvider>().currentUser.ad == "ad" ? 

      _UserProfileIndicator()

      :

      Column(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.01),
              width: MediaQuery.of(context).size.width*0.93,
              height: MediaQuery.of(context).size.height*0.795,
              child: Card(
                color: Colors.white,
                child: Column(
                  children: [

                   
                    Column(
                      children: [
                        _UserProfileTitle(),
                        Divider(endIndent: MediaQuery.of(context).size.width*0.04,
                        indent: MediaQuery.of(context).size.width*0.04,)
                      ],
                    ),

                    _UserProfileEmail(),
                    _UserProfileSifre(),   
                    _UserProfileTc(),        
                    _UserProfileAd(),                  
                    _UserProfileSoyad()
                    
                  ],
                ),
              ),
            ),
          )    
        ],
      ),
    ),

    );
  }
}

