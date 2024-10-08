import 'package:flutter_sandik/model/budget.dart';
import 'package:flutter_sandik/model/category.dart';
import 'package:flutter_sandik/model/group.dart';
import 'package:flutter_sandik/model/money_transaction.dart';
import 'package:flutter_sandik/model/user.dart';

abstract class IDbBase {
  Future<AppUser> saveUser(AppUser user);
  Future<AppUser> updateUser(AppUser user);
  Future<List<AppUser>?> getUsers();
  Future<List<AppUser>?> getUsersByIds(List<String> userIds);
  Future<Group> saveGroup(Group group);
  Future<Budget> saveMonthBudget(Budget budget);
  Future<MoneyTransaction> saveTransaction(MoneyTransaction transaction);
  Future<List<Group>?> getGroups(String userId);
  Future<Budget?> getMonthBudget(String groupId, String month);
  Future<List<MoneyTransaction>?> getTransactions(String groupId, String month);
  Future deleteGroup(String groupId);
  Future updateGroup(Group group);
  Future<List<MoneyTransaction>?> getAllTransactions(String groupId);
  Future<List<Category>> initDefaultCategories(List<Category> categories);
  Future<List<Category>> getCategories(String groupId, bool isDefault);
  Future<List<Category>> getAllCategories(String groupId);
  Future<Category> addCategory(Category category);
  Future deleteCategory(String categoryId);
  Future<AppUser?> getUserInfo(String userId);
}
