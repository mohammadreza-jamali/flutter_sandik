import 'package:flutter/material.dart';
import 'package:flutter_sandik/pages/group_page.dart';
import 'package:flutter_sandik/pages/login_page.dart';
import 'package:flutter_sandik/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _userModel = Provider.of<UserModel>(context, listen: true);
    if (_userModel.state == ViewState.Idle) {
      if (_userModel.user == null)
        return LoginPage();
      else
        return GroupPage(_userModel.user!);
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
