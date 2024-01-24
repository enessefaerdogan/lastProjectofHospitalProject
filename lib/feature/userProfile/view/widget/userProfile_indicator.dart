

part of '../userProfile_view.dart';

class _UserProfileIndicator extends StatelessWidget {
  const _UserProfileIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.4),child: Center(child: Indicator.circularProgressIndicator()))
            ],
    );
  }
}