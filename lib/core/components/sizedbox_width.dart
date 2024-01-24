
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_ex/core/extension/mediaquery_extension.dart';


class SizedBoxWidth extends StatelessWidget {
  double width;
  SizedBoxWidth({required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: context.width(width),);
  }
}