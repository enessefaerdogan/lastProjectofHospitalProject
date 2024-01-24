

part of '../signin_view.dart';

class _SinginSifreText extends StatelessWidget {
  const _SinginSifreText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(margin: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.69),
                    child: Text("Şifre",style: TextStyle(fontFamily: 'Open Sans',fontSize: 17,fontWeight: FontWeight.bold),));
  }
}