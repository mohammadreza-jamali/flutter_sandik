import 'package:flutter/cupertino.dart';
import 'package:flutter_sandik/model/budget.dart';
import 'package:flutter_sandik/pages/home_screen.dart';
import 'package:flutter_sandik/viewmodel/transaction.dart';
import 'package:flutter_sandik/widgets/budget_dialog.dart';
import 'package:provider/provider.dart';

class BudgetOverlayView extends StatefulWidget {
  const BudgetOverlayView(
      {required this.groupId, required this.groupName, super.key});
  final String groupId;
  final String groupName;

  @override
  State<BudgetOverlayView> createState() => _BudgetOverlayViewState();
}

class _BudgetOverlayViewState extends State<BudgetOverlayView> {
  late MTransaction _mTransaction;
  Budget? budget;

  @override
  Widget build(BuildContext context) {
    _mTransaction = Provider.of<MTransaction>(context)..addListener(listener);

    return Stack(
      children: [
        HomeScreen(groupId: widget.groupId, groupName: widget.groupName),

        FutureBuilder(future: getBudget(), builder:(context, snapshot) {
          if(snapshot.connectionState==ConnectionState.done){
            return budget == null || budget!.budgetValue==0 ? BudgetDialog(groupId: widget.groupId) : SizedBox();
          }
          return SizedBox();
        }, )
        
      ],
    );
  }

  void listener() async{
    await getBudget();
  }

  getBudget() async {
    budget = await _mTransaction.getMonthBudget(widget.groupId,
        "${DateTime.now().year.toString().padLeft(2, "0")}${DateTime.now().month.toString().padLeft(2, "0")}");
  }
}
