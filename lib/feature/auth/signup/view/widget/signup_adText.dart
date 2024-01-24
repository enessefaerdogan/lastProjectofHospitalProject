

part of '../signup_view.dart';

class _SignupAdText extends StatelessWidget {
  const _SignupAdText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(margin: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.72),
                    child: Text("Ad",style: TextStyle(fontFamily: 'Open Sans',fontSize: 17,fontWeight: FontWeight.bold),));
  }
}