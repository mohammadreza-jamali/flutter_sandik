import 'package:flutter_sandik/model/money_transaction.dart';

class TransactionPerMonth{
  double? sum;
  double? plannedBudget;
  double? overPayed;
  List<MoneyTransaction>? transaction;
  TransactionPerMonth({required this.transaction,required this.plannedBudget,required this.sum, required this.overPayed});
}