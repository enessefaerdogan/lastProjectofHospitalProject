import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_ex/product/widget/apptext.dart';
import 'package:flutter_google_maps_ex/core/components/sizedbox_height.dart';
import 'package:flutter_google_maps_ex/core/components/success_snackbar.dart';
import 'package:flutter_google_maps_ex/feature/changeUserInfo/viewModel/changeUserInfo_viewModel.dart';
import 'package:flutter_google_maps_ex/feature/userProfile/view/userProfile_view.dart';
import 'package:flutter_google_maps_ex/product/model/app_user.dart';
import 'package:flutter_google_maps_ex/product/utility/enum/infoType_enum.dart';
import 'package:provider/provider.dart';

part 'widget/changeUserInfo_appbar.dart';
part 'widget/changeUserInfo_passText.dart';
part 'widget/changeUserInfo_sizedBox.dart';
part 'widget/changeUserInfo_tcText.dart';
part 'widget/changeUserInfo_adText.dart';
part 'widget/changeUserInfo_soyadText.dart';
part 'widget/changeUserInfo_button.dart';

class ChangeUserInfoView extends StatelessWidget {
  AppUser currentUser;
  String whichPart;
  ChangeUserInfoView({required this.currentUser, required this.whichPart});

  final _formkey = GlobalKey<FormState>();
  TextEditingController _sifreController = TextEditingController();
  TextEditingController _tcController = TextEditingController();
  TextEditingController _adController = TextEditingController();
  TextEditingController _soyadController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _ChangeUserInfoAppBar(whichPart),

    body: SingleChildScrollView(
      child: Column(children: [
      
      
          
          Form(
            key: _formkey,
            child:
            
            whichPart == InfoTypes.Sifre.name 
            
            ? 
      
            Column(
              children: [
            
                        _ChangeUserInfoSizedBox(),
                        _ChangeUserInfoPassText(currentUser: currentUser,passController: _sifreController,)
              ],
            )
                           
                      
      
            :

            whichPart == InfoTypes.TC.name 
            
            ? 
      
            Column(
              children: [
            
                        _ChangeUserInfoSizedBox(),
                        _ChangeUserInfoTcText(tcController: _tcController, currentUser: currentUser)
              ],
            )

              :

               whichPart == InfoTypes.Ad.name 
            
            ? 
      
            Column(
              children: [
            
                        _ChangeUserInfoSizedBox(),
                        _ChangeUserInfoAdText(adController: _adController, currentUser: currentUser)
              ],
            )

              :


             Column(
              children: [
            
                        _ChangeUserInfoSizedBox(),
                        _ChangeUserInfoSoyadText(soyadController: _soyadController, currentUser: currentUser)
              ],
            )
            ),
          _ChangeUserInfoButton(
            whichPart: whichPart, 
            formkey: _formkey, 
            currentUser: currentUser, 
            sifreController: _sifreController, 
            tcController: _tcController, 
            adController: _adController, 
            soyadController: _soyadController),
      
      ],),
    ),

    );
  }
}