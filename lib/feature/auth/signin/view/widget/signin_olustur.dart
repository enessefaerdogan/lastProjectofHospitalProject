

part of '../signin_view.dart';

class _SigninOlustur extends StatelessWidget {
  List<AppUser> users;
  _SigninOlustur({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Hesabın Yok Mu ?",style: TextStyle(fontFamily: 'Open Sans'),),
                      TextButton(
                       style: TextButton.styleFrom(
                        primary: Colors.red
                       ),onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpView(users: users,)));
                      }, child: Text("Hemen Oluştur",style: TextStyle(fontFamily: 'Open Sans',fontWeight: FontWeight.bold),))
                    ],
                  );
  }
}