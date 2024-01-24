

part of '../signup_view.dart';

class _SignupTcText extends StatelessWidget {
  const _SignupTcText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(margin: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.66),
                    child: Text("TC No",style: TextStyle(fontFamily: 'Open Sans',fontSize: 17,fontWeight: FontWeight.bold),));
  }
}