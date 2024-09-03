// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionDto {
  String? id;
  String? userName;
  Timestamp? insertDate;
  double? amount;
  String? description;
  String? month;
  String? categoryName;
  String? icon;
  TransactionDto({
    this.id,
    this.userName,
    this.insertDate,
    this.amount,
    this.description,
    this.month,
    this.categoryName,
    this.icon,
  });
}
