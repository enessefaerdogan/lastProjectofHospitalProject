

part of '../onboard_view.dart';

class _OnboardPageOneLongText extends StatelessWidget {
  const _OnboardPageOneLongText({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
              child: Container(
                /*decoration: BoxDecoration(border: Border.all(width: 1
                )),*/
                margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.16),
                width: MediaQuery.of(context).size.width*0.7,
                height: MediaQuery.of(context).size.height*0.12,
                child: Text("Hastaneleri haritalar ile bul",style: TextStyle(fontFamily: 'Poppins-Regular',
                color: Colors.black45,fontWeight: FontWeight.bold,fontSize: 17),),
              ),
            );
  }
}