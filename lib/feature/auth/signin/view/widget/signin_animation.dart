

part of '../signin_view.dart';

class _SigninAnimation extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.1),
                  child: 
                  Lottie.asset("Animation - 1702986925149".lottieToJson),
                  width: MediaQuery.of(context).size.width*0.8,
                  height: MediaQuery.of(context).size.height*0.3,
            
                );
  }
}