

part of '../signup_view.dart';

class _SignupMailText extends StatelessWidget {
  const _SignupMailText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(margin: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.65),
                  child: Text("E-mail",style: TextStyle(fontFamily: 'Open Sans',fontSize: 17,fontWeight: FontWeight.bold),));
                  
  }
}