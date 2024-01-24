

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_ex/core/components/info_snackbar.dart';
import 'package:flutter_google_maps_ex/core/extension/mediaquery_extension.dart';
import 'package:flutter_google_maps_ex/feature/spam/viewModel/spam_viewModel.dart';
import 'package:flutter_google_maps_ex/product/model/app_user.dart';
import 'package:flutter_google_maps_ex/product/model/review.dart';
import 'package:flutter_google_maps_ex/product/model/spam.dart';
import 'package:flutter_google_maps_ex/product/utility/constants/firebase_constants.dart';
import 'package:provider/provider.dart';

part 'widget/spamview_listTile.dart';
part 'widget/spamview_button.dart';
part 'widget/spamview_appbar.dart';

class SpamView extends StatefulWidget {
  AppUser currentUser;
  Review  currentReview;
  SpamView(
    {
    super.key,
    required this.currentUser,
    required this.currentReview
    
    }
    );

  @override
  State<SpamView> createState() => _SpamViewState();
}

class _SpamViewState extends State<SpamView> {
    

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _SpamViewAppBar(),
      body: Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        _SpamViewListTile(index: 0),
        _SpamViewListTile(index: 1),
        _SpamViewListTile(index: 2),
        _SpamViewListTile(index: 3),
        _SpamViewListTile(index: 4),
        _SpamViewListTile(index: 5),  
        _SpamViewButton(currentUser: widget.currentUser, currentReview: widget.currentReview)

    ],),


    );
  }
}