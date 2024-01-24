

part of '../userProfile_view.dart';

class _UserProfileAppBar extends StatelessWidget implements PreferredSizeWidget {

  @override
  Widget build(BuildContext context) {
    return AppBar(
        actions: [
          IconButton(onPressed: (){
            // kullanıcıdan çıkış yapılsın
            SignoutService.signoutUser();
            //print(" E ÇIKTIM " + FirebaseAuth.instance.currentUser!.email.toString() + "UİD :"+FirebaseAuth.instance.currentUser!.uid.toString());
            ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(SuccessSnackbar.successSnackbar("İyi Günler...","Hesabınızdan çıkış yaptınız.",Duration(seconds: 2)));
            Navigator.push(context, MaterialPageRoute(builder: (context) => SigninView()));
             //print(" TURNEDUSER " + context.watch<UserProfileViewProvider>().turnedAppUser.email);
          }, icon: Icon(Icons.logout,color: Colors.white,))
        ],automaticallyImplyLeading: false,
    title:  AppText.appText("Kullanıcı Profili", 17, Colors.white,FontWeight.normal),//Text("Kullanıcı Profili",style: TextStyle(fontSize: 17,fontFamily: 'Poppins-Regular',color: Colors.white),),
    backgroundColor: Colors.red,);
  }
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}