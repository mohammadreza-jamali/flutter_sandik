import 'package:flutter/material.dart';
import 'package:flutter_sandik/model/budget.dart';
import 'package:flutter_sandik/viewmodel/transaction.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class BudgetDialog extends StatefulWidget {
  const BudgetDialog({required this.groupId, super.key});

final String groupId;
  @override
  State<BudgetDialog> createState() => _BudgetDialogState();
}

class _BudgetDialogState extends State<BudgetDialog> with SingleTickerProviderStateMixin {

  double? _budget;
  late MTransaction _transaction;
  ValueNotifier<int> index=ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100)).then((t){
      index.value=1;
    });
  }

  @override
  Widget build(BuildContext context) {
    _transaction = Provider.of<MTransaction>(context);

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned(
            top:80,
            left: 40,
            child: Container(
              padding: EdgeInsets.only(top: 50),
              width: MediaQuery.of(context).size.width-80,
              height: 200,
              decoration: BoxDecoration(
                color: Color(0xff050119),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [BoxShadow(color: Colors.blue.shade100,blurRadius: 8,spreadRadius: 1,offset: Offset(1, 2))]
              ),
              child: Form(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width/2,
                      child: TextFormField(
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
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: ElevatedButton(onPressed:()=> _saveGroup(context), child: Text("Save")))
                ],
              ),
            ),),
            ),
          ),
          Positioned(
            top: 40,
            left: MediaQuery.of(context).size.width/2-50,
            child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Color(0xff050119),
              borderRadius: BorderRadius.circular(50),
              border: Border(top: BorderSide(color: Colors.blue.shade100), )
            ),
            child: Center(child: 
            ValueListenableBuilder(
              valueListenable: index,
              builder: (BuildContext context, dynamic value, Widget? child) {
                return  AnimatedSwitcher(
                        duration: const Duration(milliseconds: 800),
                        transitionBuilder: (child, anim) => RotationTransition(
                              turns: child.key == ValueKey('icon1')
                                  ? Tween<double>(begin: 1, end: 0)
                                      .animate(anim)
                                  : Tween<double>(begin: 0.5, end: 1)
                                      .animate(anim),
                              child:
                                  FadeTransition(opacity: anim, child: child),
                            ),
                        child: value == 0
                            ? Icon(MdiIcons.accountReactivate, size: 80,color: Colors.blue, key: const ValueKey('icon1'))
                            : Icon(
                                MdiIcons.piggyBank,
                                size: 80,
                                  color: Colors.pink.shade300,
                                key: const ValueKey('icon2'),
                              ));
              },
            ),
              
            ),
          ))
        ],
      ),
    );
  }
  _saveGroup(BuildContext context) async {
    if (_budget == null || _budget == 0) return;
    await _transaction.saveMonthBudget(Budget.init(
        budgetmonth:
            "${DateTime.now().year.toString().padLeft(2, "0")}${DateTime.now().month.toString().padLeft(2, "0")}",
        budgetValue: _budget,
        groupId: widget.groupId));
  }
}