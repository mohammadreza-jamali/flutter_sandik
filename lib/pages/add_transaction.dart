import 'dart:math';
import 'package:flutter_sandik/gen/assets.gen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandik/model/category.dart';
import 'package:flutter_sandik/model/money_transaction.dart';
import 'package:flutter_sandik/viewmodel/transaction.dart';
import 'package:flutter_sandik/viewmodel/user_model.dart';
import 'package:flutter_sandik/widgets/custom_dropdown.dart';
import 'package:provider/src/provider.dart';

class AddTransaction extends StatefulWidget {
  AddTransaction(this.groupId, {Key? key}) : super(key: key);
  final String groupId;

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  double? _amount;

  String? _description;

  List<Category>? _categories;
  Map<String, String> _categoriesMap = {};
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff050119),
      appBar: AppBar(
        backgroundColor: Color(0xff03001C),
        title: Text("Add Transaction"),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Form(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Center(child: Assets.images.transactionPhoto.image(width: 400,height: 300)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                child: Container(
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          label: Text("Paid Amount"),
                          hintText: "200",
                        ),
                        onChanged: (value) {
                          _amount = double.parse(value == "" ? "0" : value);
                        },
                        validator: (value) {
                          if (value!.isEmpty) return "Value not Correct";
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          label: Text("Paid Description"),
                          hintText: "paid to shok for chips",
                        ),
                        onChanged: (value) {
                          _description = value;
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      FutureBuilder(
                          future: getCategories(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return GenericCustomDropdown<String>(
                                  items: _categoriesMap,
                                  hintText: "select your category",
                                  onChanged: (String val) {
                                    _selectedCategory = val;
                                  });
                            }
                            if (snapshot.hasError) {
                              return Center(child: Text("Error"));
                            }
                            return CircularProgressIndicator();
                          }),
                          SizedBox(height: 16,),
                      SizedBox(
                        width: 160,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () => _saveTransaction(context),
                            child: Text("Save",style: TextStyle(color: Color(0xff1A1A40)),)),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getCategories() async {
    var _transaction = context.read<MTransaction>();
    _categories = await _transaction.getCategories(widget.groupId, false);
    _categoriesMap.addEntries((_categories ?? []).map((category) =>
        {category.categoryId!: category.categoryName!}.entries.first));
  }

  _saveTransaction(BuildContext context) async {
    if (_amount == null || _amount == 0) return;
    final _userModel = context.read<UserModel>();
    final _transaction = context.read<MTransaction>();
    var filterDate =
        "${DateTime.now().year.toString().padLeft(2, "0")}${DateTime.now().month.toString().padLeft(2, "0")}";
    await _transaction.saveTransaction(MoneyTransaction.init(
        id: Random().nextInt(999999999).toString(),
        groupId: widget.groupId,
        categoryId: _selectedCategory,
        amount: _amount,
        description: _description,
        userId: _userModel.getCurrentUser()!.userId!,
        month: filterDate));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Your Paid Saved Successfully"), showCloseIcon: true));

    Navigator.of(context).pop();
  }

  String _faDateTime() {
    DateTime now = DateTime.now();
    initializeDateFormatting(' fa ', null);
    String formattedDatePersian =
        DateFormat(' yyyy_MM_dd HH:mm:ss ', ' fa_IR ').format(now);
    return(formattedDatePersian);
  }

  
}
