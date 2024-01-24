

part of '../signup_view.dart';

class _SignupButton extends StatelessWidget {
  TextEditingController mailController;
  TextEditingController sifreController;
  TextEditingController soyadController;
  TextEditingController tcController;
  TextEditingController adController;
  GlobalKey<FormState> formKey;
  List<AppUser> users;
  _SignupButton(
    {
      required this.mailController,
      required this.sifreController,
      required this.soyadController,
      required this.tcController,
      required this.adController,
      required this.formKey,
      required this.users
      
    }
    );
bool userAlreadyCreated(String newEmail){
    for(int i=0;i<users.length;i++){
      if(users[i].email == newEmail){
        return true;
      }
    }
    return false;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
                width: MediaQuery.of(context).size.width*0.85,
                height: MediaQuery.of(context).size.height*0.05,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    )
                  ),
                  onPressed: (){
                  if(formKey.currentState!.validate()){
                          if(userAlreadyCreated(mailController.text)){
                             ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(FailureSnackbar.failureSnackbar("E-mail Kullanılamaz!", 
                            "Kayıtlı kullanıcı bulunmaktadır.", Duration(seconds: 2)));
                          }
                          else{
                          SignUpService.createUser(
                          email: mailController.text,
                          password: sifreController.text);
                          SignUpService.firestoreAddUser(
                          fotoAdress: 'assets/default.jpg',
                          ad: adController.text,
                          email: mailController.text,
                          password: sifreController.text,
                          soyad: soyadController.text,
                          tc: tcController.text);
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(SuccessSnackbar.successSnackbar("Yeni Kayıt Başarılı!", 
                            "Uygulamaya hoşgeldiniz.", Duration(seconds: 2)));
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SigninView()));
                          }                   
                      }
                }


              
              
              , 
                child: Text("Kayıt Ol",style: TextStyle(fontFamily: 'Open Sans',fontSize: 17),)),
              );
  }
}