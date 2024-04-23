import 'package:flutter/material.dart';
import 'package:flutter_sandik/model/budget.dart';
import 'package:flutter_sandik/viewmodel/transaction.dart';
import 'package:provider/provider.dart';
class AddBudget extends StatefulWidget {
  const AddBudget(this.groupId,{Key? key}) : super(key: key);

  final String groupId;
  @override
  State<AddBudget> createState() => _AddBudgetState();
}

class _AddBudgetState extends State<AddBudget> {

  double? _budget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Budget"),),
      body: Form(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              keyboardType:TextInputType.number ,
              decoration: InputDecoration(
                label: Text("Budget"),
                hintText: "1000",
              ),
              onChanged: (value) {
                _budget=double.parse(value==""?"0":value);
              },
              validator: (value) {
                if(value!.isEmpty) return "Value not Correct";
              },
            ),
            ElevatedButton(onPressed:()=> _saveGroup(context), child: Text("Save"))
          ],
        ),
      ),),
    );
  }
  _saveGroup(BuildContext context)async{
    if(_budget==null || _budget==0) return;
    final _transaction=context.read<MTransaction>();
    await _transaction.saveMonthBudget(Budget.init(budgetmonth: "${DateTime.now().year.toString().padLeft(2,"0")}${DateTime.now().month.toString().padLeft(2,"0")}"
    , budgetValue:  _budget,
     groupId: widget.groupId ));
  }
}