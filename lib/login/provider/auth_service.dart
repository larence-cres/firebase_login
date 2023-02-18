import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthService {
  Future<User?> signInWithGoogle();
  Future<void> signOut();
  User? getCurrentUser();
}

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthService(this._firebaseAuth);

  @override
  Future<User?> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Google sign in aborted');
    }
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    return userCredential.user;
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  @override
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}
