

part of '../onboard_view.dart';

class _OnboardNotHover extends StatelessWidget {
  const _OnboardNotHover({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(shape:BoxShape.circle,color: Color.fromARGB(255, 242, 155, 155),),
                );
  }
}