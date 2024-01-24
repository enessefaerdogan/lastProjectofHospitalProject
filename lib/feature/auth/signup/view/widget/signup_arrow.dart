


part of '../signup_view.dart';

class _SignupArrow extends StatelessWidget {
  const _SignupArrow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
                margin: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.8),
                child: IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(Icons.chevron_left,size: 30,color: Colors.black,)),
              );
  }
}