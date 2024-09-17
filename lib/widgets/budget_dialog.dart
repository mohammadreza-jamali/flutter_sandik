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
            top:100,
            left: 40,
            child: Container(
              padding: EdgeInsets.only(top: 40),
              width: MediaQuery.of(context).size.width-80,
              height: 260,
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
                      width: MediaQuery.of(context).size.width-100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(child: Text('Oops!',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 32,fontStyle: FontStyle.italic),)),
                          SizedBox(height: 4,),
                          Center(child: Text('!یادت رفته بودجه این ماه رو تعیین کنی',style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: 12),)),
                          SizedBox(height: 16,),
                          Container(
                            width: (MediaQuery.of(context).size.width-80)/2,
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
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 7,
                    right: 7,
                    child: ElevatedButton(onPressed:()=> _saveGroup(context),style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.indigo.shade50)), child: Text("Save",style: TextStyle(color: Color(0xff1A1A40)),)))
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