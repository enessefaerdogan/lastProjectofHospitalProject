import 'package:flutter/material.dart';
import 'package:flutter_google_maps_ex/core/components/failure_snackbar.dart';
import 'package:flutter_google_maps_ex/core/components/sizedbox_height.dart';
import 'package:flutter_google_maps_ex/core/components/success_snackbar.dart';
import 'package:flutter_google_maps_ex/core/extension/image_extension.dart';
import 'package:flutter_google_maps_ex/feature/auth/signin/view/signin_view.dart';
import 'package:flutter_google_maps_ex/feature/auth/signup/viewModel/signup_viewModel.dart';
import 'package:flutter_google_maps_ex/product/model/app_user.dart';
import 'package:flutter_google_maps_ex/product/service/firebase/auth/signup_service.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

part 'widget/signup_arrow.dart';
part 'widget/signup_mailText.dart';
part 'widget/signup_mailTextFF.dart';
part 'widget/signup_sifreText.dart';
part 'widget/signup_sifreTextFF.dart';
part 'widget/signup_tcText.dart';
part 'widget/signup_tcTextFF.dart';
part 'widget/signup_adText.dart';
part 'widget/signup_adTextFF.dart';
part 'widget/signup_soyadText.dart';
part 'widget/signup_soyadTextFF.dart';
part 'widget/signup_emptyRow.dart';
part 'widget/signup_button.dart';

class SignUpView extends StatelessWidget {
  List<AppUser> users;
  SignUpView({required this.users});
  
  final _formkey = GlobalKey<FormState>();
  TextEditingController _mailController = TextEditingController();
  TextEditingController _sifreController = TextEditingController();
  TextEditingController _tcController = TextEditingController();
  TextEditingController _adController = TextEditingController();
  TextEditingController _soyadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    context.read<SignupViewProvider>().usersSet(users);
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [

              SizedBoxHeight(height: 0.04),
              _SignupArrow(),
              SizedBoxHeight(height: 0.03),
              Form(key: _formkey,child: Column(
                
                children: [

                  _SignupMailText(),
                  SizedBoxHeight(height: 0.01),
                  _SignupMailTextFF(mailController: _mailController),
                  SizedBoxHeight(height: 0.01),
                  _SignupSifreText(),
                  SizedBoxHeight(height: 0.01),
                  _SignupSifreTextFF(sifreController: _sifreController),
                  SizedBoxHeight(height: 0.01),
                  _SignupTcText(),
                  _SignupTcTextFF(tcController: _tcController),
                  SizedBoxHeight(height: 0.01),
                  _SignupAdText(),
                  _SignupAdTextFF(adController: _adController),
                  SizedBoxHeight(height: 0.01),
                  _SignupSoyadText(),
                  SizedBoxHeight(height: 0.01),
                  _SignupSoyadTextFF(soyadController: _soyadController),
                  SizedBoxHeight(height: 0.03),
                  _SignupEmptyRow(),
                 SizedBoxHeight(height: 0.02),
                  _SignupButton(
                  mailController: _mailController, 
                  sifreController: _sifreController, 
                  soyadController: _soyadController, 
                  tcController: _tcController, 
                  adController: _adController, 
                  formKey: _formkey,
                  users: users),
                  SizedBoxHeight(height: 0.05),
                  
                ],
              ), ),

            ],
          ),
        ),

    );
  }
}