

part of '../onboard_view.dart';

class _OnboardPageTwoRow extends StatelessWidget {
  List<Widget> circles;
  _OnboardPageTwoRow(
    {
      required this.circles
    }
    );

  @override
  Widget build(BuildContext context) {
    return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                    circles[0],
                    SizedBoxWidth(width: 0.01,),
                    circles[1],
                    SizedBoxWidth(width: 0.01,),
                   circles[0]
                   
              ],
    );
  }
}