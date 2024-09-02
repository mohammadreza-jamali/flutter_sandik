import 'package:cloud_firestore/cloud_firestore.dart';

class MoneyTransaction{
  String? id;
  String? userId;
  String? groupId;
  Timestamp? insertDate;
  double? amount;
  String? description;
  String? month;
  String? categoryId;
  MoneyTransaction();
  MoneyTransaction.init({required this.id,required this.amount,required this.month,required this.groupId,required this.categoryId,this.userId,this.description});
     Map<String,dynamic> toMap()=>{
    "id":id,
    "userId":userId,
    "insertDate":insertDate??FieldValue.serverTimestamp(),
    "amount":amount,
    "month":month,
    "description":description,
    "groupId":groupId,
    "categoryId":categoryId
  };
  MoneyTransaction fromJson(Map<String,dynamic> json){
    id=json["id"];
    userId=json["userId"];
    insertDate=json["insertDate"];
    amount=json["amount"];
    month=json["month"];
    description=json["description"];
    groupId=json["groupId"];
    categoryId= json["categoryId"];
    return this;
  }
}