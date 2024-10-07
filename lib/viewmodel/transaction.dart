import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sandik/locator.dart';
import 'package:flutter_sandik/model/category.dart';
import 'package:flutter_sandik/model/transaction_per_month.dart';
import 'package:flutter_sandik/model/user.dart';
import 'package:flutter_sandik/model/money_transaction.dart';
import 'package:flutter_sandik/model/group.dart';
import 'package:flutter_sandik/model/budget.dart';
import 'package:flutter_sandik/repository/db_repository.dart';
import 'package:flutter_sandik/services/abstract/db_base.dart';
import 'package:flutter_sandik/viewmodel/user_model.dart';

class MTransaction with ChangeNotifier implements IDbBase {
  ViewState _state = ViewState.Idle;
  DbRepository _dbRepository = locator<DbRepository>();

  ViewState get state => _state;
  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  double remaining = 0;

  @override
  Future<List<Group>?> getGroups(String userId) async {
    return await _dbRepository.getGroups(userId);
  }

  Future<Map<String, dynamic>> getTransactionInfo(String groupId, String month) async {
    var budget = await getMonthBudget(groupId, month);
    var transactions = await getTransactions(groupId, month);
    double transactionsSum = 0;
    transactions?.forEach((element) {
      transactionsSum += element.amount!;
    });
    var remaining = (budget?.budgetValue ?? 0) - transactionsSum;
    return {"budget": budget, "transactions": transactions, "remaining": remaining};
  }

  Future<List<TransactionPerMonth>?> getTransactionsMonthlyReport(String groupId) async {
    var transactions = await getAllTransactions(groupId);

    if (transactions == null) return [];
    var groups = groupBy(transactions, (MoneyTransaction transaction) => transaction.month);

    List<TransactionPerMonth>? _transactions = [];
    for (var group in groups.entries) {
      double _sum = 0;
      var budget = await getMonthBudget(groupId, group.key!);
      for (var transaction in group.value) {
        _sum += transaction.amount!;
      }
      group.value.sort((a, b) => a.insertDate!.compareTo(b.insertDate!));
      _transactions.add(TransactionPerMonth(
          month: group.key, transaction: group.value, plannedBudget: budget!.budgetValue, sum: _sum, overPayed: budget.budgetValue! - _sum));
    }
    _transactions.sort((a, b) => a.month!.compareTo(b.month!));
    return _transactions;
  }

  @override
  Future<Budget?> getMonthBudget(String groupId, String month) async {
    return await _dbRepository.getMonthBudget(groupId, month);
  }

  @override
  Future<List<MoneyTransaction>?> getTransactions(String groupId, String month) async {
    return await _dbRepository.getTransactions(groupId, month);
  }

  @override
  Future<List<MoneyTransaction>?> getAllTransactions(String groupId) async {
    return await _dbRepository.getAllTransactions(groupId);
  }

  @override
  Future<Group> saveGroup(Group group) async {
    return await _dbRepository.saveGroup(group);
  }

  @override
  Future<Budget> saveMonthBudget(Budget budget) async {
    state = ViewState.Busy;
    var data = await _dbRepository.saveMonthBudget(budget);
    state = ViewState.Idle;
    return data;
  }

  @override
  Future<MoneyTransaction> saveTransaction(MoneyTransaction transaction) async {
    state = ViewState.Busy;
    var data = await _dbRepository.saveTransaction(transaction);
    state = ViewState.Idle;
    return data;
  }

  @override
  Future<AppUser> saveUser(AppUser user) async {
    state = ViewState.Busy;
    var data = await _dbRepository.saveUser(user);
    state = ViewState.Idle;
    return data;
  }

  @override
  Future<List<AppUser>?> getUsers() async {
    return await _dbRepository.getUsers();
  }

  @override
  Future deleteGroup(String groupId) async {
    state = ViewState.Busy;
    await _dbRepository.deleteGroup(groupId);
    state = ViewState.Idle;
  }

  @override
  Future updateGroup(Group group) async {
    state = ViewState.Busy;
    await _dbRepository.updateGroup(group);
    state = ViewState.Idle;
  }

  @override
  Future<Category> addCategory(Category category) async {
    state = ViewState.Busy;
    var result = await _dbRepository.addCategory(category);
    state = ViewState.Idle;
    return result;
  }

  @override
  Future deleteCategory(String categoryId) async {
    state = ViewState.Busy;
    await _dbRepository.deleteCategory(categoryId);
    state = ViewState.Idle;
  }

  @override
  Future<List<Category>> initDefaultCategories(List<Category> categories) async {
    state = ViewState.Busy;
    var result = await _dbRepository.initDefaultCategories(categories);
    state = ViewState.Idle;
    return result;
  }

  @override
  Future<List<Category>> getCategories(String groupId, bool isDefault) async {
    var result = await _dbRepository.getCategories(groupId, isDefault);
    return result;
  }

  @override
  Future<List<Category>> getAllCategories(String groupId) async {
    var result = await _dbRepository.getAllCategories(groupId);
    return result;
  }
}
