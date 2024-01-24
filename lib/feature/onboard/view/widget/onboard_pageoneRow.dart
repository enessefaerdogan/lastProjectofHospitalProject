

part of '../onboard_view.dart';

class _OnBoardPageOneRow extends StatelessWidget {
  List<Widget> circles;
  _OnBoardPageOneRow(
    {
      required this.circles
    }
    );

  @override
  Widget build(BuildContext context) {
    return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 3 adet yuvarlak dönsün eğer index'e eşitse o kırmızı olsun
                // tüm sayfalarda bu yapı bulunsun en son ise başla adlı buton olsun
                // butonun yapısı roundedrectangleborder olucak, biraz radius verilecek
               
                    circles[1],
                    SizedBoxWidth(width: 0.01,),
                    circles[0],
                    SizedBoxWidth(width: 0.01,),
                    circles[0]
                 
  

             
              
              ],
            );
  }
}