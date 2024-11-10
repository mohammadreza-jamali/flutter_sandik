import 'package:flutter_sandik/dtos/login_dto.dart';
import 'package:flutter_sandik/dtos/sign_result_dto.dart';
import 'package:flutter_sandik/model/user.dart';

abstract class IAuthBase {
  AppUser? getCurrentUser();
  Future signOut();
  Future<AppUser?> signWithGoogle();
  Future<SignResultDto?> signWithEmailPassword(LoginDto dto);
  Future<SignResultDto?> registerWithEmailPassword(LoginDto dto);
}
