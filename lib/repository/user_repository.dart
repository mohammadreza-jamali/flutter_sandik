import 'package:flutter_sandik/dtos/login_dto.dart';
import 'package:flutter_sandik/dtos/sign_result_dto.dart';
import 'package:flutter_sandik/locator.dart';
import 'package:flutter_sandik/model/user.dart';
import 'package:flutter_sandik/services/abstract/auth_base.dart';
import 'package:flutter_sandik/services/concerete/firebase_auth_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements IAuthBase {
  IAuthBase _authService = locator<FirebaseAuthService>();

  @override
  AppUser? getCurrentUser() {
    return _authService.getCurrentUser();
  }

  @override
  Future signOut() async {
    return await _authService.signOut();
  }

  @override
  Future<AppUser?> signWithGoogle() async {
    return await _authService.signWithGoogle();
  }

  @override
  Future<SignResultDto?> registerWithEmailPassword(LoginDto dto) async {
    return await _authService.registerWithEmailPassword(dto);
  }

  @override
  Future<SignResultDto?> signWithEmailPassword(LoginDto dto) async {
    return await _authService.signWithEmailPassword(dto);
  }
}
