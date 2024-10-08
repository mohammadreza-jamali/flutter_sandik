import 'package:flutter_sandik/model/category.dart';
import 'package:flutter_sandik/model/user.dart';
import 'package:flutter_sandik/model/money_transaction.dart';
import 'package:flutter_sandik/model/group.dart';
import 'package:flutter_sandik/model/budget.dart';
import 'package:flutter_sandik/services/abstract/db_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDbService implements IDbBase {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<Group>?> getGroups(String userId) async {
    var groups = await _firestore.collection("Groups").where("groupUsers", arrayContains: userId).get();
    return groups.docs.map((e) => Group().fromJson(e.data())).toList();
  }

  @override
  Future<Budget?> getMonthBudget(String groupId, String month) async {
    var budget = await _firestore.collection("Budgets").where("budgetmonth", isEqualTo: month).where("groupId", isEqualTo: groupId).get();
    try {
      return Budget().fromJson(budget.docs[0].data());
    } catch (e) {
      return Budget.init(budgetValue: 0, budgetmonth: month, groupId: groupId);
    }
  }

  @override
  Future<List<MoneyTransaction>?> getTransactions(String groupId, String month) async {
    var transactions = await _firestore.collection("Transactions").where("groupId", isEqualTo: groupId).where("month", isEqualTo: month).get();
    var list = transactions.docs.map((e) => MoneyTransaction().fromJson(e.data())).toList();
    list.sort((a, b) => a.insertDate!.compareTo(b.insertDate!));
    return list;
  }

  Future<List<MoneyTransaction>?> getAllTransactions(String groupId) async {
    var transactions = await _firestore.collection("Transactions").where("groupId", isEqualTo: groupId).get();
    var list = transactions.docs.map((e) => MoneyTransaction().fromJson(e.data())).toList();
    return list;
  }

  @override
  Future<Group> saveGroup(Group group) async {
    await _firestore.collection("Groups").doc(group.groupId).set(group.toMap(), SetOptions(merge: true));
    return group;
  }

  @override
  Future<Budget> saveMonthBudget(Budget budget) async {
    await _firestore.collection("Budgets").doc("${budget.groupId}_${budget.budgetmonth}").set(budget.toMap(), SetOptions(merge: true));
    return budget;
  }

  @override
  Future<MoneyTransaction> saveTransaction(MoneyTransaction transaction) async {
    await _firestore.collection("Transactions").doc(transaction.id).set(transaction.toMap(), SetOptions(merge: true));
    return transaction;
  }

  @override
  Future<AppUser> saveUser(AppUser user) async {
    await _firestore.collection("Users").doc(user.userId).set(user.toMap(), SetOptions(merge: true));
    return user;
  }

  @override
  Future<List<AppUser>?> getUsers() async {
    var users = await _firestore.collection("Users").get();
    return users.docs.map((e) => AppUser().fromJson(e.data())).toList();
  }

  @override
  Future<List<AppUser>?> getUsersByIds(List<String> userIds) async {
    var users = await _firestore.collection("Users").where("userId", whereIn: userIds).get();
    return users.docs.map((e) => AppUser().fromJson(e.data())).toList();
  }

  @override
  Future<AppUser?> getUserInfo(String userId) async {
    var user = await _firestore.collection("Users").where("userId", isEqualTo: userId).get();
    return AppUser().fromJson(user.docs[0].data());
  }

  Future deleteGroup(String groupId) async {
    await _firestore.collection("Groups").doc(groupId).delete();
  }

  Future updateGroup(Group group) async {
    await _firestore.collection("Groups").doc(group.groupId).update(group.toMap());
  }

  @override
  Future<List<Category>> initDefaultCategories(List<Category> categories) async {
    for (var category in categories) {
      await _firestore.collection("Categories").doc(category.categoryId).set(category.toMap(), SetOptions(merge: true));
    }

    return categories;
  }

  @override
  Future<List<Category>> getCategories(String groupId, bool isDefault) async {
    var categories = await _firestore.collection("Categories").where("groupId", isEqualTo: groupId).where("isDefault", isEqualTo: isDefault).get();
    var list = categories.docs.map((e) => Category().fromJson(e.data())).toList();
    return list;
  }

  @override
  Future<List<Category>> getAllCategories(String groupId) async {
    var categories = await _firestore.collection("Categories").where("groupId", isEqualTo: groupId).get();
    var list = categories.docs.map((e) => Category().fromJson(e.data())).toList();
    return list;
  }

  @override
  Future<Category> addCategory(Category category) async {
    await _firestore.collection("Categories").doc(category.categoryId).set(category.toMap(), SetOptions(merge: true));
    return category;
  }

  Future deleteCategory(String categoryId) async {
    await _firestore.collection("Categories").doc(categoryId).delete();
  }

  @override
  Future<AppUser> updateUser(AppUser user) async {
    await _firestore.collection("Users").doc(user.userId).update(user.toMap());
    return user;
  }
}
