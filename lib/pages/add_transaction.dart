import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_sandik/model/money_transaction.dart';
import 'package:flutter_sandik/viewmodel/transaction.dart';
import 'package:flutter_sandik/viewmodel/user_model.dart';
import 'package:provider/src/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTransaction extends StatelessWidget {
   AddTransaction(this.groupId,{Key? key}) : super(key: key);
  final String groupId;

  double? _amount;
  String? _description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Transaction"),),
      body: Form(child: Container(
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                label: Text("Paid Amount"),
                hintText: "200",
              ),
              onChanged: (value) {
                _amount=double.parse(value==""?"0":value);
              },
              validator: (value) {
                if(value!.isEmpty) return "Value not Correct";
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                label: Text("Paid Description"),
                hintText: "paid to shok for chips",
              ),
              onChanged: (value) {
                _description=value;
              },
            ),
            ElevatedButton(onPressed:()=> _saveTransaction(context), child: Text("Save"))
          ],
        ),
      ),),
    );
  }
  _saveTransaction(BuildContext context)async{
    if(_amount==null || _amount==0) return;
    final _userModel=context.read<UserModel>();
    final _transaction=context.read<MTransaction>();
    var filterDate="${DateTime.now().year.toString().padLeft(2,"0")}${DateTime.now().month.toString().padLeft(2,"0")}";
    await _transaction.saveTransaction(MoneyTransaction.init(id:Random().nextInt(999999999).toString(), groupId:  groupId,amount: _amount,description: _description,userId: _userModel.getCurrentUser()!.userId!,month:filterDate  ));
    Fluttertoast.showToast(
        msg: "Your Paid Saved Successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0
    );
    Navigator.of(context).pop();
  }
}
