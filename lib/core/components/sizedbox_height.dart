
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_ex/core/extension/mediaquery_extension.dart';


class SizedBoxHeight extends StatelessWidget {
  double height;
  SizedBoxHeight({required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: context.height(height),);
  }
}