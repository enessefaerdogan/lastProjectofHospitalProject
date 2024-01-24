

part of '../signin_view.dart';

class _SigninButton extends StatefulWidget {
  TextEditingController mailController;
  TextEditingController sifreController;
  GlobalKey<FormState> formKey;
  List<AppUser> users;
  _SigninButton(
    {
      required this.mailController, 
      required this.sifreController, 
      required this.formKey,
      required this.users
    }
    );

  @override
  State<_SigninButton> createState() => _SigninButtonState();
}

class _SigninButtonState extends State<_SigninButton> {
    AppUser _currentUser = AppUser(ad: "ad", email: "email", foto: "foto", id: "id", sifre: "sifre", soyad: "soyad", tc: "tc");

    String _docId = "";

    findCurrentUser(String userMail) {
    for(int i=0;i<widget.users.length;i++){
                        if(widget.users[i].email == userMail){
                          
                         setState(() {
                             _currentUser = widget.users[i];
                             _docId = widget.users[i].id;

                         });
         
    
                        }
                      }
  }

  @override
  Widget build(BuildContext context) {
    //print("ŞİMDİ BU VAR : "+context.watch<SigninViewProvider>().currentUser.ad.toString());
    return Container(
                  width: MediaQuery.of(context).size.width*0.85,
                  height: MediaQuery.of(context).size.height*0.05,
                  child: 
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      )
                    ),
                    onPressed: ()async {
                    if(widget.formKey.currentState!.validate()){            
                          await findCurrentUser(widget.mailController.text);
                          var response = await FirebaseFirestore.instance
                          .collection("kullanici")
                          .where("email", isEqualTo: widget.mailController.text)
                          .where("sifre", isEqualTo: widget.sifreController.text)
                          .limit(1)
                          .get();
                          if(response.docs.isNotEmpty){
                            SignInService.signIn(email: widget.mailController.text,password: widget.sifreController.text);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => 
                            HomeView(currentUser: _currentUser,docId: _docId,)));
                          }
                          else{
                              ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(FailureSnackbar.failureSnackbar("Giriş Başarısız!", 
                            "Verileriniz eksik veya hatalı..", Duration(seconds: 2)));
                          }      
                        }
                  }
                 
                  , 
                  child: Text("Giriş",style: TextStyle(fontFamily: 'Open Sans',fontSize: 17),)),
                );

  }
}