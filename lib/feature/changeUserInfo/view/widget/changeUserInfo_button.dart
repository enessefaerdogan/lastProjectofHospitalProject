

part of '../changeUserInfo_view.dart';


class _ChangeUserInfoButton extends StatelessWidget {
  String whichPart;
  GlobalKey<FormState> formkey;
  AppUser currentUser;
  TextEditingController sifreController;
  TextEditingController tcController;
  TextEditingController adController;
  TextEditingController soyadController;
  _ChangeUserInfoButton(
    {
      required this.whichPart,
      required this.formkey,
      required this.currentUser,
      required this.sifreController,
      required this.tcController,
      required this.adController,
      required this.soyadController
    }
  );

  @override
  Widget build(BuildContext context) {
    return Center(
            child: Container(
              margin: EdgeInsets.only(top: whichPart == InfoTypes.TC.name ? MediaQuery.of(context).size.height*0.64 : MediaQuery.of(context).size.height*0.67,bottom: MediaQuery.of(context).size.height*0.03),
                    width: MediaQuery.of(context).size.width*0.85,
                    height: MediaQuery.of(context).size.height*0.05,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                        )
                      ),onPressed: ()async {
                      
                        if(formkey.currentState!.validate()){
                          

                          
                          final exportedUser = 
                          
                          whichPart == InfoTypes.Sifre.name 
                          ?
                          
                          ChangeUserInfoViewModel
                          .updateUserSifre(
                            currentUser: currentUser,
                            controllerSifreText: sifreController.text)

                            
                          :

                          whichPart == InfoTypes.TC.name 
                          ?

                          ChangeUserInfoViewModel
                          .updateUserTC(
                            currentUser: currentUser,
                            controllerTCText: tcController.text)
                          
                          :

                          whichPart == InfoTypes.Ad.name
                          ?

                          ChangeUserInfoViewModel
                          .updateUserAd(
                            currentUser: currentUser,
                            controllerAdText: adController.text)

                          :

                          ChangeUserInfoViewModel
                          .updateUserSoyad(
                            currentUser: currentUser,
                            controllerSoyadText: soyadController.text);


                            ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(SuccessSnackbar.successSnackbar("Güncelleme","Bİlgileriniz başarıyla güncellendi.",Duration(seconds: 2)));
                          Navigator.pop(context, exportedUser);
                                                                             
                        
                        }
                              
                          }
                      
                    , child: AppText.appText("Güncelle", 17, Colors.white,FontWeight.normal),), //Text("Güncelle",style: TextStyle(fontFamily: 'Open Sans',fontSize: 17),)),
                  ),
          );
  }
}