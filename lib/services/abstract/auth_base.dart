import 'package:flutter_sandik/model/user.dart';

abstract class IAuthBase{
  AppUser? getCurrentUser();
  Future signOut();
  Future<AppUser?> SignWithGoogle();
}