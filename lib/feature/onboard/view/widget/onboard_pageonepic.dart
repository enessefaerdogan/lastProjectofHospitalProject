

part of '../onboard_view.dart';

class _OnboardPageOnePic extends StatelessWidget {
  const _OnboardPageOnePic({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(width: double.infinity,
            height: MediaQuery.of(context).size.height*0.4,child: Image.asset("undraw_Navigation_re_wxx4".toPng));
  }
}