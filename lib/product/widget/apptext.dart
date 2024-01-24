

import 'package:flutter/material.dart';

@immutable
final class AppText{


 static appText(String message,double? fontSize,Color fontColor,FontWeight fontWeight) {
  return Text(
    message,
    style: TextStyle(color: fontColor,fontSize: fontSize,fontFamily: 'Poppins-Regular',fontWeight: fontWeight)
    );
 }


}