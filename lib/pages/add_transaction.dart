import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_sandik/model/category.dart';
import 'package:flutter_sandik/model/money_transaction.dart';
import 'package:flutter_sandik/viewmodel/transaction.dart';
import 'package:flutter_sandik/viewmodel/user_model.dart';
import 'package:flutter_sandik/widgets/custom_dropdown.dart';
import 'package:provider/src/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTransaction extends StatefulWidget {
   AddTransaction(this.groupId,{Key? key}) : super(key: key);
  final String groupId;

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  double? _amount;

  String? _description;

  List<Category>? _categories;
  Map<String,String> _categoriesMap={};
  String? _selectedCategory;
  
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
            SizedBox(
              height: 8,
            ),
            FutureBuilder(future: getCategories(), builder: (context, snapshot) {
            if(snapshot.connectionState==ConnectionState.done){
              return GenericCustomDropdown<String>(items: _categoriesMap,hintText: "select your category",onChanged: (String val){
                  _selectedCategory=val;
              });
            }
            if(snapshot.hasError){
            return Center(child:Text("Error"));
          }
          return CircularProgressIndicator();
            }),
            ElevatedButton(onPressed:()=> _saveTransaction(context), child: Text("Save"))
          ],
        ),
      ),),
    ); 
  }

  getCategories() async {
    var _transaction = context.read<MTransaction>();
    _categories=await _transaction.getCategories(widget.groupId); 
    _categoriesMap.addEntries((_categories??[]).map((category)=>{category.categoryId!:category.categoryName!}.entries.first));
  }

  _saveTransaction(BuildContext context)async{
    if(_amount==null || _amount==0) return;
    final _userModel=context.read<UserModel>();
    final _transaction=context.read<MTransaction>();
    var filterDate="${DateTime.now().year.toString().padLeft(2,"0")}${DateTime.now().month.toString().padLeft(2,"0")}";
    await _transaction.saveTransaction(MoneyTransaction.init(id:Random().nextInt(999999999).toString(), groupId:  widget.groupId,
        categoryId: _selectedCategory,amount: _amount,description: _description,userId: _userModel.getCurrentUser()!.userId!,month:filterDate ));
    ScaffoldMessenger.of(context).showSnackBar (SnackBar(content:Text("Your Paid Saved Successfully"),showCloseIcon: true));
        
    Navigator.of(context).pop();
  }
}
