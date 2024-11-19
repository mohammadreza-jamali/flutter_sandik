import 'package:flutter_sandik/core/constants/app_style.dart';
import 'package:flutter_sandik/dtos/login_dto.dart';

import '../gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandik/model/user.dart';
import 'package:flutter_sandik/viewmodel/transaction.dart';
import 'package:flutter_sandik/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _passwordController = TextEditingController();
  ValueNotifier<String> _errorMessage  = ValueNotifier("");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 64, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.images.icons.piggyBank.image(width: 100, height: 100),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade900,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                                onPressed: () {},
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                )),
                            SizedBox(
                              width: 50,
                            ),
                            TextButton(
                                onPressed: () {},
                                child: Text(
                                  'SIGN UP',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                )),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome back',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
                                ),
                                Text(
                                  'sign in with your account',
                                  style: TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                                SizedBox(
                                  height: 32,
                                ),
                                TextField(
                                  decoration: InputDecoration(
                                    label: Text(
                                      'Username',
                                      style: TextStyle(fontSize: 14, color: Colors.grey),
                                    ),
                                  ),
                                ),
                                TextField(
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                      label: Text(
                                        'Password',
                                        style: TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                      suffixIcon: TextButton(
                                          onPressed: () {},
                                          child: Text(
                                            'Show',
                                            style: TextStyle(fontSize: 12, color: Colors.purple.shade700),
                                          ))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 32, bottom: 16),
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        await _signInWithEmailPassword();
                                      },
                                      style: ButtonStyle(
                                        minimumSize: WidgetStateProperty.all(Size(MediaQuery.of(context).size.width, 60)),
                                        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                        backgroundColor: WidgetStateProperty.all(Colors.blue.shade900),
                                      ),
                                      child: Text(
                                        'LOGIN',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Forgot your password?'),
                                    TextButton(onPressed: () {}, child: Text('Reset here')),
                                  ],
                                ),
                                SizedBox(
                                  height: 32,
                                ),
                                Center(
                                  child: Text('OR SIGN IN WITH'),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Center(
                                    child: InkWell(
                                  onTap: () async {
                                    var user = await _signInWithGoogle(context);
                                    await _saveUser(context, user);
                                  },
                                  child: Assets.images.icons.googleIcon.svg(),
                                )),
                                ValueListenableBuilder(valueListenable: _errorMessage, builder: (context, value, child) {
                                  return Text(value,style: AppStyle.bold16.apply(color: Colors.red,fontStyle: FontStyle.italic),);
                                })
                                ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

   _signInWithEmailPassword() async {
    var _userModel = context.read<UserModel>();
    var result= await _userModel.signWithEmailPassword(LoginDto(email: "pooria.jamali@gmail.com", password: _passwordController.text));
    AppUser? _user = result?.user;
    var errorMessage=result?.errorMessage;
    if(errorMessage!=null){
      _errorMessage.value=errorMessage;
      await Future.delayed(Duration(seconds: 5));
      _errorMessage.value="";
    }
    
    print("created User Id Is : ${_user?.userId}");
  }

   _registerWithEmailPassword(BuildContext context) async {
    var _userModel = context.read<UserModel>();
    var result= await _userModel.registerWithEmailPassword(LoginDto(email: "pooria.jamali@gmail.com", password: _passwordController.text));
    AppUser? _user = result?.user;
    var errorMessage=result?.errorMessage;
if(errorMessage!=null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(showCloseIcon: true,backgroundColor: Colors.red,content: Text(errorMessage ?? "",style: AppStyle.bold16.apply(color: Colors.white,fontStyle: FontStyle.italic),)));
    }
    print("created User Id Is : ${_user?.userId}");
  }

  _signInWithGoogle(BuildContext context) async {
    var _userModel = context.read<UserModel>();
    AppUser? _user = await _userModel.signWithGoogle();

    print("created User Id Is : ${_user!.userId}");
  }

  _saveUser(BuildContext context, AppUser user) async {
    final _transaction = context.read<MTransaction>();
    await _transaction.saveUser(user);
  }
}
