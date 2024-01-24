

part of '../onboard_view.dart';

class _OnboardPageThreePic extends StatelessWidget {
  const _OnboardPageThreePic({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(width: double.infinity,
            height: MediaQuery.of(context).size.height*0.4,child: Image.asset("undraw_reviews_lp8w".toPng));
  }
}