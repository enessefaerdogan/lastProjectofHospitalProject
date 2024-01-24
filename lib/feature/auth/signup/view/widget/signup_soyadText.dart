

part of '../signup_view.dart';

class _SignupSoyadText extends StatelessWidget {
  const _SignupSoyadText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(margin: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.67),
                    child: Text("Soyad",style: TextStyle(fontFamily: 'Open Sans',fontSize: 17,fontWeight: FontWeight.bold),));
  }
}