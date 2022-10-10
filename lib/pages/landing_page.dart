import 'package:flutter/material.dart';
import 'package:flutter_sandik/pages/home_page.dart';
import 'package:flutter_sandik/pages/sign_in.dart';
import 'package:flutter_sandik/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     var _userModel=Provider.of<UserModel>(context,listen: true);
     if(_userModel.state==ViewState.Idle){
       if(_userModel.user==null)
       return SignIn();
       else

       return HomePage(_userModel.user);
     }else{
       return Scaffold(
         body: Center(child: CircularProgressIndicator(),),
       );
     }
    
      }
        
  }
