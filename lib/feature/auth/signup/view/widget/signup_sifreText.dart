

part of '../signup_view.dart';

class _SignupSifreText extends StatelessWidget {
  const _SignupSifreText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(margin: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.69),
                  child: Text("Şifre",style: TextStyle(fontFamily: 'Open Sans',fontSize: 17,fontWeight: FontWeight.bold),));
  }
}