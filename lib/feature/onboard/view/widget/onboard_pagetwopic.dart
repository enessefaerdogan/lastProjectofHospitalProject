

part of '../onboard_view.dart';

class _OnboardPageTwoPic extends StatelessWidget {
  const _OnboardPageTwoPic({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(width: double.infinity,
            height: context.height(0.4),child: Image.asset("undraw_medicine_b1ol".toPng));
  }
}