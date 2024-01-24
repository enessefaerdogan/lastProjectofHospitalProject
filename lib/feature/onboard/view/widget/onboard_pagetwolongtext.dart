

part of '../onboard_view.dart';

class _OnboardPageTwoLongText extends StatelessWidget {
  const _OnboardPageTwoLongText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
              /*decoration: BoxDecoration(border: Border.all(width: 1
                )),*/
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.13),
              width: MediaQuery.of(context).size.width*0.7,
              height: MediaQuery.of(context).size.height*0.12,
              child: Text("Sana uygun olan hastaneden hizmet alabilirsin",style: TextStyle(fontFamily: 'Poppins-Regular',
              color: Colors.black45,fontWeight: FontWeight.bold,fontSize: 17),),
            );
  }
}