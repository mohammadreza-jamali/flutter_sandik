import 'package:flutter_sandik/locator.dart';
import 'package:flutter_sandik/model/user.dart';
import 'package:flutter_sandik/model/money_transaction.dart';
import 'package:flutter_sandik/model/group.dart';
import 'package:flutter_sandik/model/budget.dart';
import 'package:flutter_sandik/services/abstract/db_base.dart';
import 'package:flutter_sandik/services/concerete/firestore_db_service.dart';

class DbRepository implements IDbBase{

  IDbBase _dbService=locator<FirestoreDbService>();

  @override
  Future<List<Group>?> getGroups(String userId) async {
    return await _dbService.getGroups(userId);
  }

  @override
  Future<Budget?> getMonthBudget(String groupId,String month) async{
    return await _dbService.getMonthBudget(groupId,month);
  }

  @override
  Future<List<MoneyTransaction>?> getTransactions(String groupId,String month) async{
    return await _dbService.getTransactions(groupId,month);
  }

  @override
  Future<Group> saveGroup(Group group) async{
    return await _dbService.saveGroup(group);
  }

  @override
  Future<Budget> saveMonthBudget(Budget budget)async {
    return await _dbService.saveMonthBudget(budget);
  }

  @override
  Future<MoneyTransaction> saveTransaction(MoneyTransaction transaction)async {
    return await _dbService.saveTransaction(transaction);
  }

  @override
  Future<AppUser> saveUser(AppUser user) async {
    return await _dbService.saveUser(user);
  }

  @override
  Future<List<AppUser>?> getUsers()async {
    return await _dbService.getUsers();
  }

}