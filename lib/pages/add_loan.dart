import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sandik/gen/assets.gen.dart';
import 'package:flutter_sandik/model/loan.dart';
import 'package:flutter_sandik/viewmodel/transaction.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class AddLoan extends StatefulWidget {
  final String groupId;
  AddLoan(this.groupId, {super.key});
  @override
  _AddLoanPageState createState() => _AddLoanPageState();
}

class _AddLoanPageState extends State<AddLoan> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amoountController = TextEditingController();
  final TextEditingController _interestRateController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController();
  final TextEditingController _paidMonthsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submitData() async{
    final _transaction = context.read<MTransaction>();
    await _transaction.addLoan(Loan.init(
      groupId: widget.groupId,
      loanId: Random().nextInt(999999999).toString(),
      loanName: _nameController.text, 
      loanTotalAmount: double.parse(_amoountController.text), 
      loanInterestRate: double.parse(_interestRateController.text), 
      months: int.parse(_monthsController.text), 
      paidMonths: int.parse(_paidMonthsController.text)));
    _formKey.currentState?.reset();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('اطلاعات ارسال شد!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('افزودن وام'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Assets.images.loanPic.image(width: 400, height: 300),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'نام وام',
                  hintText: 'مثال: مسکن',
                  prefixIcon: Icon(MdiIcons.leadPencil),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'این فیلد نمی‌تواند خالی باشد';
                  }
                }),
                              SizedBox(
                                height: 12,
                              ),
                              TextFormField(
                                controller: _amoountController,
                                decoration: InputDecoration(
                labelText: 'مبلغ وام',
                hintText: 'مثال: 20,000,000',
                prefixIcon: Icon(MdiIcons.handCoinOutline),
                                ),
                                inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                ],
                                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'این فیلد نمی‌تواند خالی باشد';
                  }
                }
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Row(
                                children: [
                Expanded(
                  child: TextFormField(
                    controller: _interestRateController,
                    decoration: InputDecoration(
                      labelText: 'درصد بهره بانکی',
                      hintText: 'مثال: 30',
                      prefixIcon: Icon(MdiIcons.sackPercent),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'این فیلد نمی‌تواند خالی باشد';
                  }
                }
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: TextFormField(
                    controller: _monthsController,
                    decoration: InputDecoration(
                      labelText: 'تعداد اقساط (ماه)',
                      hintText: 'مثال: 36',
                      prefixIcon: Icon(MdiIcons.mapLegend),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'این فیلد نمی‌تواند خالی باشد';
                  }
                }
                  ),
                ),
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              TextFormField(
                                controller: _paidMonthsController,
                                decoration: InputDecoration(
                labelText: 'تعداد اقساط پرداخت شده',
                hintText: 'مثال: 6',
                prefixIcon: Icon(MdiIcons.tallyMark5),
                                ),
                                inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                ],
                                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'این فیلد نمی‌تواند خالی باشد';
                  }
                }
                              ),
                SizedBox(height: 20),
                SizedBox(
                  width: 150,
                  height: 48,
                  child: ElevatedButton(
                    style: Theme.of(context).elevatedButtonTheme.style,
                    onPressed:(){
                      if (_formKey.currentState!.validate())_submitData();
                    },
                    child: Text(
                      'ثبت',
                      style: TextStyle(color: Colors.blue.shade200),
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
