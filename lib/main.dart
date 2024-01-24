import 'package:flutter/material.dart';
import 'package:flutter_google_maps_ex/feature/auth/signup/viewModel/signup_viewModel.dart';
import 'package:flutter_google_maps_ex/feature/favorite/viewModel/favorite_viewModel.dart';
import 'package:flutter_google_maps_ex/feature/spam/viewModel/spam_viewModel.dart';
import 'package:flutter_google_maps_ex/feature/userProfile/viewModel/userProfile_viewModel.dart';
import 'package:flutter_google_maps_ex/feature/auth/signin/view/signin_view.dart';
import 'package:flutter_google_maps_ex/feature/auth/signin/viewModel/signin_viewModel.dart';
import 'package:flutter_google_maps_ex/feature/changeUserInfo/viewModel/changeUserInfo_viewModel.dart';
import 'package:flutter_google_maps_ex/feature/home/view/home_view.dart';
import 'package:flutter_google_maps_ex/feature/onboard/view/onboard_view.dart';
import 'package:flutter_google_maps_ex/feature/search/view/search_view.dart';
import 'package:flutter_google_maps_ex/feature/userProfile/view/userProfile_view.dart';
import 'package:flutter_google_maps_ex/piechart.dart';
import 'package:flutter_google_maps_ex/product/init/app_init.dart';
import 'package:flutter_google_maps_ex/silinecek.dart';
import 'package:provider/provider.dart';

void main() async{
  await AppInitialize().make();

  runApp(

    MultiProvider(
      providers: [
        //ChangeNotifierProvider(create: (_) => SigninViewProvider()),
        ChangeNotifierProvider(create: (_) => SignupViewProvider()),
        //ChangeNotifierProvider(create: (_) => FavoriteViewProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileViewProvider()),
        ChangeNotifierProvider(create: (_) => SpamViewProvider()),
      ],
        child: MyApp(),
    ),

  );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Senin Hastanen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
  
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        
        useMaterial3: true,
      ),
      home: OnBoardView(),
    );
  }
}