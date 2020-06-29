import 'package:firebase_auth/firebase_auth.dart';

/// Utility class to manage Firebase authorization related functions such as
/// create user / modify password / authenticate user

class FireBaseOps {
  //Todo: Google, FB SignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> validateUserCredentials(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser user = result.user;
      return user != null ? true : false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future createUser(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return user != null ? user.uid : null;
    } catch (e) {
      print(e.toString());
      return e;
    }
  }
}
