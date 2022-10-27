import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sandik/locator.dart';
import 'package:flutter_sandik/model/user.dart';
import 'package:flutter_sandik/model/money_transaction.dart';
import 'package:flutter_sandik/model/group.dart';
import 'package:flutter_sandik/model/budget.dart';
import 'package:flutter_sandik/repository/db_repository.dart';
import 'package:flutter_sandik/services/abstract/db_base.dart';
import 'package:flutter_sandik/viewmodel/user_model.dart';

class MTransaction with ChangeNotifier implements IDbBase{

 ViewState _state=ViewState.Idle;
  DbRepository _dbRepository=locator<DbRepository>();


  ViewState get state=>_state;
  set state(ViewState value){
    _state=value;
    notifyListeners();
  }
  double remaining=0;
  
  @override
  Future<List<Group>?> getGroups(String userId) async{
    return await _dbRepository.getGroups(userId);
  }
  
  Future<Map<String,dynamic>> getTransactionInfo(String groupId,String month)async{
    var budget=await getMonthBudget(groupId,month);
    var transactions=await getTransactions(groupId,month);
    double transactionsSum=0;
    transactions?.forEach((element) { transactionsSum+=element.amount!;});
    var remaining=(budget?.budgetValue??0) - transactionsSum;
    return {
        "budget":budget,
        "transactions":transactions,
        "remaining":remaining
    };
  }

  // Future<Map<String,dynamic>> getTransactionsMonthlyReport(String groupId)async{
  //   var transactions=await getAllTransactions(groupId);

  //   var grous=groupBy(transactions, (MoneyTransaction transaction) {
  //     transaction.month
  //   },);

  //   // double transactionsSum=0;
  //   // transactions?.forEach((element) { transactionsSum+=element.amount!;});
  //   // var remaining=(budget?.budgetValue??0) - transactionsSum;
  //   // return {
  //   //     "budget":budget,
  //   //     "transactions":transactions,
  //   //     "remaining":remaining
  //   // };
  // }

  @override
  Future<Budget?> getMonthBudget(String groupId,String month) async{
    return await _dbRepository.getMonthBudget(groupId, month);
  }

  @override
  Future<List<MoneyTransaction>?> getTransactions(String groupId,String month) async{
    return await _dbRepository.getTransactions(groupId,month);
  }
  @override
  Future<List<MoneyTransaction>?> getAllTransactions(String groupId) async{
    return await _dbRepository.getAllTransactions(groupId);
  }

  @override
  Future<Group> saveGroup(Group group) async{
    return await _dbRepository.saveGroup(group);
  }

  @override
  Future<Budget> saveMonthBudget(Budget budget) async{
    state=ViewState.Busy;
    var data= await _dbRepository.saveMonthBudget(budget);
    state=ViewState.Idle;
    return data;
  }

  @override
  Future<MoneyTransaction> saveTransaction(MoneyTransaction transaction) async{
    state=ViewState.Busy;
    var data= await _dbRepository.saveTransaction(transaction);
    state=ViewState.Idle;
    return data;
  }

  @override
  Future<AppUser> saveUser(AppUser user)async {
    state=ViewState.Busy;
    var data= await _dbRepository.saveUser(user);
    state=ViewState.Idle;
    return data;
  }

  @override
  Future<List<AppUser>?> getUsers() async {
    return await _dbRepository.getUsers();
  }
  
  @override
  Future deleteGroup(String groupId) async {
    state=ViewState.Busy;
    await _dbRepository.deleteGroup(groupId);
    state=ViewState.Idle;
  }
  
  @override
  Future updateGroup(Group group) async {
    state=ViewState.Busy;
    await _dbRepository.updateGroup(group);
    state=ViewState.Idle;
  }
  

}