import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_google_maps_ex/product/service/firebase/options/firebase_options.dart';
import 'package:logger/logger.dart';

@immutable
final class AppInitialize{

  Future<void> make() async{

    await runZonedGuarded(() => appInitialize(), (error, stack) { 
    
      Logger().e(error);

    });
  }

  static Future<void> appInitialize() async{

    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    );

    FlutterError.onError = (details) {
    /// flutterda herhangi error alınınca buraya consol log düşer
    /// crashlytics log buraya eklenir
    /// Todo: add custom logger
    Logger().e(details.exceptionAsString());
    };

  }


}