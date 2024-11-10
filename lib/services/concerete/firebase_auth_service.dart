import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_sandik/dtos/login_dto.dart';
import 'package:flutter_sandik/dtos/sign_result_dto.dart';
import 'package:flutter_sandik/model/user.dart';
import 'package:flutter_sandik/services/abstract/auth_base.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService implements IAuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  AppUser? getCurrentUser() {
    User? user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return _mapUser(user);
  }

  @override
  Future<bool> signOut() async {
    await _firebaseAuth.signOut();
    GoogleSignIn _googleSignIn = GoogleSignIn();
    if (await _googleSignIn.isSignedIn()) await _googleSignIn.signOut();
    return true;
  }

  AppUser _mapUser(User user) {
    return AppUser(
      userId: user.uid,
      email: user.email,
      name: user.displayName,
    );
  }

  @override
  Future<AppUser?> signWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount? _googleUser = await _googleSignIn.signIn();
    if (_googleUser != null) {
      GoogleSignInAuthentication? _googleAuth = await _googleUser.authentication;
      if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
        UserCredential? _user =
            await _firebaseAuth.signInWithCredential(GoogleAuthProvider.credential(idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken));
        if (_user.user == null) return null;
        return _mapUser(_user.user!);
      }
    }
    return null;
  }

   @override
  Future<SignResultDto?> signWithEmailPassword(LoginDto dto) async {
    UserCredential? _user=null;
    try {
      _user = await _firebaseAuth.signInWithEmailAndPassword(
          email: dto.email, password: dto.password);
      if (_user.user == null) return Future.value(null);
      
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return SignResultDto(
            errorMessage: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return SignResultDto(
            errorMessage: 'The account already exists for that email.');
      }
    } catch (e) {
      return SignResultDto(errorMessage: 'Unknown error occurred.');
    }

    return SignResultDto(user: _mapUser(_user!.user!), errorMessage: "");
  }

  @override
  Future<SignResultDto?> registerWithEmailPassword(LoginDto dto) async {
    UserCredential? _user=null;
    try {
       _user= await _firebaseAuth.createUserWithEmailAndPassword(
          email: dto.email, password: dto.password);
      if (_user.user == null) return Future.value(null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return SignResultDto(
            errorMessage: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return SignResultDto(
            errorMessage: 'The account already exists for that email.');
      }
    } catch (e) {
      return SignResultDto(errorMessage: 'Unknown error occurred.');
    }
    return SignResultDto(user: _mapUser(_user!.user!), errorMessage: "");
  }
}
