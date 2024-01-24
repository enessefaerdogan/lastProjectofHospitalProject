
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService{

  late  SharedPreferences _prefs;

  SharedPreferencesService(){

   init();

  }

  init()async{

    _prefs = await SharedPreferences.getInstance();

  }

  createString({key, value})async{

   await _prefs.setString(key, value);

  }


  Future<String> readString({key})async{
    
    String? _myString = await _prefs.getString(key);

    return _myString.toString() ?? "";

  }


  Future<bool> containsKey({key})async{
    
    bool? _contains = await _prefs.containsKey(key);

    return _contains;

  }

    
}