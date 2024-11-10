import 'package:flutter/material.dart';
import 'package:flutter_sandik/dtos/login_dto.dart';
import 'package:flutter_sandik/dtos/sign_result_dto.dart';
import 'package:flutter_sandik/locator.dart';
import 'package:flutter_sandik/model/user.dart';
import 'package:flutter_sandik/repository/db_repository.dart';
import 'package:flutter_sandik/repository/user_repository.dart';
import 'package:flutter_sandik/services/abstract/auth_base.dart';

enum ViewState { Idle, Busy }

class UserModel with ChangeNotifier implements IAuthBase {
  UserModel() {
    getCurrentUser();
  }

  ViewState _state = ViewState.Idle;
  UserRepository _userRepository = locator<UserRepository>();
  DbRepository _dbRepository = locator<DbRepository>();

  AppUser? _user;
  String? _errorMessage;

  AppUser? get user => _user;
  String? get errorMessage => _errorMessage;

  ViewState get state => _state;
  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  @override
  AppUser? getCurrentUser() {
    state = ViewState.Busy;
    _user = _userRepository.getCurrentUser();
    state = ViewState.Idle;
    return user;
  }

  @override
  Future signOut() async {
    state = ViewState.Busy;
    await _userRepository.signOut();
    _user = null;
    state = ViewState.Idle;
  }

  @override
  Future<AppUser?> signWithGoogle() async {
    state = ViewState.Busy;
    _user = await _userRepository.signWithGoogle();
    state = ViewState.Idle;
    return _user;
  }

  @override
  Future<SignResultDto?> registerWithEmailPassword(LoginDto dto) async {
    state = ViewState.Busy;
    var data = await _userRepository.registerWithEmailPassword(dto);
    _user=data?.user;
    _errorMessage=data?.errorMessage;
    state = ViewState.Idle;
    return data;
  }

  @override
  Future<SignResultDto?> signWithEmailPassword(LoginDto dto) async {
    state = ViewState.Busy;
    var data = await _userRepository.signWithEmailPassword(dto);
    _user=data?.user;
    _errorMessage=data?.errorMessage;
    state = ViewState.Idle;
    return data;
  }
}
