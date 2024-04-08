
import 'package:flutter/material.dart';
import 'package:flutter_sandik/locator.dart';
import 'package:flutter_sandik/model/user.dart';
import 'package:flutter_sandik/repository/db_repository.dart';
import 'package:flutter_sandik/repository/user_repository.dart';
import 'package:flutter_sandik/services/abstract/auth_base.dart';

enum ViewState{Idle,Busy}

class UserModel with ChangeNotifier implements IAuthBase{
  UserModel(){
    getCurrentUser();
  }

  ViewState _state=ViewState.Idle;
  UserRepository _userRepository=locator<UserRepository>();
  DbRepository _dbRepository=locator<DbRepository>();

  AppUser? _user;

  AppUser? get user=>_user;

  ViewState get state=>_state;
  set state(ViewState value){
    _state=value;
    notifyListeners();
  }

  @override
  AppUser? getCurrentUser() {
    state=ViewState.Busy;
    _user= _userRepository.getCurrentUser();
    state=ViewState.Idle;
    return user;
  }

  @override
  Future signOut() async {
    state=ViewState.Busy;
    await _userRepository.signOut();
    _user=null;
    state=ViewState.Idle;
  }

  @override
  Future<AppUser?> SignWithGoogle() async {
     state=ViewState.Busy;
     _user=await _userRepository.SignWithGoogle();
     state=ViewState.Idle;
     return _user;
  }


}