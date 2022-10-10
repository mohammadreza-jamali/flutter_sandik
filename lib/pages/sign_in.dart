import 'package:flutter/material.dart';
import 'package:flutter_sandik/model/user.dart';
import 'package:flutter_sandik/viewmodel/transaction.dart';
import 'package:flutter_sandik/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
     Scaffold(
       appBar: AppBar(title: Text("Sandik Application"),elevation: 4,),
       body: Container(
        child: Center(child: ElevatedButton(onPressed: ()async{ var user=await _signInWithGoogle(context);
        await _saveUser(context,user);
        } ,child: Text("SignWithGoole"),))
         ),
     );
  }
  _signInWithGoogle(BuildContext context) async{
    var _userModel=context.read<UserModel>();
    AppUser? _user =await _userModel.SignWithGoogle();
    
    print("created User Id Is : ${_user!.userId}");
  }
  _saveUser(BuildContext context,AppUser user)async{
    final _transaction=context.read<MTransaction>();
    await _transaction.saveUser(user);
  }
}