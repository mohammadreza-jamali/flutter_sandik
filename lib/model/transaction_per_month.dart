import 'package:flutter_sandik/model/money_transaction.dart';

class TransactionPerMonth{
  double? sum;
  double? plannedBudget;
  double? overPayed;
  String? month;
  List<MoneyTransaction>? transaction;
  TransactionPerMonth({required this.month,required this.transaction,required this.plannedBudget,required this.sum, required this.overPayed});
  get humanReadbleMonth=> "${month!.substring(0,4)}/${month!.substring(4,6)}";
}