import 'package:flutter/material.dart';
import 'package:flutter_google_maps_ex/core/components/sizedbox_height.dart';
import 'package:flutter_google_maps_ex/core/components/sizedbox_width.dart';
import 'package:flutter_google_maps_ex/core/extension/image_extension.dart';
import 'package:flutter_google_maps_ex/core/extension/mediaquery_extension.dart';
import 'package:flutter_google_maps_ex/feature/auth/signin/view/signin_view.dart';
import 'package:flutter_google_maps_ex/feature/home/view/home_view.dart';
import 'package:flutter_google_maps_ex/product/utility/constants/firebase_constants.dart';
import 'package:flutter_google_maps_ex/product/service/localStorage/sharedPreferences.dart';

part 'widget/onboard_notHover.dart';
part 'widget/onboard_hover.dart';
part 'widget/onboard_pageonepic.dart';
part 'widget/onboard_pageonetext.dart';
part 'widget/onboard_pageonelongtext.dart';
part 'widget/onboard_pageoneRow.dart';
part 'widget/onboard_pagetwopic.dart';
part 'widget/onboard_pagetwotext.dart';
part 'widget/onboard_pagetwolongtext.dart';
part 'widget/onboard_pagetwoRow.dart';
part 'widget/onboard_pagethreepic.dart';
part 'widget/onboard_pagethreetext.dart';
part 'widget/onboard_pagethreelongtext.dart';
part 'widget/onboard_pageThreeRow.dart';
part 'widget/onboard_button.dart';

class OnBoardView extends StatelessWidget {

    final PageController _pageController = PageController(initialPage: 0);

    List<Widget> circles = [

        _OnboardNotHover(),
        _OnboardHover()

    ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: 
      PageView.builder(
        controller: _pageController,
        itemCount: 3,
        itemBuilder: (context, index) {
          return buildPage(index,context,circles);
        },
      )
    );
  }
}

Widget buildPage(int index,BuildContext context,List<Widget> circles) {
    return 
    
    index == 0 ?
    
    Column(
        children: [

            SizedBoxHeight(height: 0.1),
            _OnboardPageOnePic(),
            _OnboardPageOneText(),
            SizedBoxHeight(height: 0.07),
            _OnboardPageOneLongText(),
            SizedBoxHeight(height: 0.04),
            _OnBoardPageOneRow(circles: circles)

        ],
      )
      
          :
      index==1 ?
      Column(
        children: [

            SizedBoxHeight(height: 0.1),
            _OnboardPageTwoPic(),
            _OnboardPageTwoText(),
            SizedBoxHeight(height: 0.07,),
            _OnboardPageTwoLongText(),
            SizedBoxHeight(height: 0.04),
            _OnboardPageTwoRow(circles: circles)

        ],
      )

        :

      Column(
        children: [

            SizedBoxHeight(height: 0.1),
            _OnboardPageThreePic(),
            _OnboardPageThreeText(),
            SizedBoxHeight(height: 0.07,),
            _OnboardPageThreeLongText(),
            SizedBoxHeight(height: 0.04),
            _OnboardPageThreeRow(circles: circles),
            SizedBoxHeight(height: 0.08),
            _OnboardButton()

        ],
      );
  }
