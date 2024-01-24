
import 'package:firebase_auth/firebase_auth.dart';

class SignoutService{

    static final _authInstance = FirebaseAuth.instance;

    static Future<void> signoutUser()async{
      await _authInstance.signOut();
    }
    
}