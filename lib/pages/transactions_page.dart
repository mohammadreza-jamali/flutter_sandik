import 'package:flutter/material.dart';
import 'package:flutter_sandik/model/budget.dart';
import 'package:flutter_sandik/model/money_transaction.dart';
import 'package:flutter_sandik/pages/add_budget.dart';
import 'package:flutter_sandik/pages/add_transaction.dart';
import 'package:flutter_sandik/viewmodel/transaction.dart';
import 'package:flutter_sandik/viewmodel/user_model.dart';
import 'package:provider/src/provider.dart';

class TransactionsPage extends StatelessWidget {
   TransactionsPage(this.groupId, {Key? key}) : super(key: key);
  final String groupId;
  List<MoneyTransaction>? _transactions;
  Budget? _budget;
  late MTransaction _transaction;
  String filterDate = "";
  double? _remaining;

  @override
  Widget build(BuildContext context) {
    _transaction = Provider.of<MTransaction>(context);
    if(_transaction.state==ViewState.Idle){
      filterDate =
        "${DateTime.now().year.toString().padLeft(2, "0")}${DateTime.now().month.toString().padLeft(2, "0")}";
    return  Scaffold(
        appBar: AppBar(
          title: Text("Transactions"),
          actions: [
            IconButton(onPressed:()=> _addTransaction(context), icon: Icon(Icons.paid))
          ],
        ),
        body: FutureBuilder(
          future: _getInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (_budget == null || _transactions == null) {
                return Center(
                  child: Column(
                    children: [
                      Text("Budget Not Defined"),
                      ElevatedButton(
                          onPressed:()=> _addBudget(context), child: Text("Add Budget"))
                    ],
                  ),
                );
              }
              return Stack(
                children: [
                 
                  Positioned.fill(
                      child: _transactions != null
                          ? ListView.builder(
                              itemCount: _transactions!.length,
                              itemBuilder: (context, index) => Container(
                                    margin: EdgeInsets.all(4),
                                    color: Colors.orange,
                                    child: ListTile(
                                      title: Text(
                                          (_transactions![index].description ??
                                                  0)
                                              .toString()),
                                      subtitle: Text(_transactions![index]
                                          .insertDate!
                                          .toDate()
                                          .toString()),
                                      trailing: Text(
                                        (_transactions![index].amount ?? 0)
                                            .toString(),
                                      ),
                                    ),
                                  ))
                          : Container(
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: Text(
                                    "This Group Has Not Transaction For This Month"),
                              ),
                            )),
                             Positioned(
                      bottom: 10,
                      left: 0,
                      child: _budget != null
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              color: Colors.white70,
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text("Budget Amount"),
                                    trailing: Text(
                                      (_budget!.budgetValue ?? 0).toString(),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text("Remaining Amount"),
                                    trailing: Text(
                                      _remaining.toString(),
                                      style: TextStyle(
                                          color: (_remaining ?? 0) > 0
                                              ? Colors.green.shade800
                                              : Colors.red.shade800),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Center(
                              child: Column(
                                children: [
                                  Text("Budget not definded for this month")
                                ],
                              ),
                            ))
                ],
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
    }else{
      return Scaffold(body: Center(child: CircularProgressIndicator(),),);
    }
    
  }

  Future _getInfo() async {
    var data =
        await _transaction.getTransactionInfo(groupId, filterDate);
    _transactions = data["transactions"];
    _budget = data["budget"];
    _remaining = data["remaining"];
  }

  void _addTransaction(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddTransaction(groupId),
    ));
  }

  void _addBudget(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddBudget(groupId),
    ));
  }
}
