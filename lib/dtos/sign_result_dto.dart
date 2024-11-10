import 'package:flutter_sandik/model/user.dart';

class SignResultDto{
  AppUser? user;
  String? errorMessage;

  SignResultDto({this.user, this.errorMessage});
}