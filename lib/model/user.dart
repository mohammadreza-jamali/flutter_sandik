import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser{
  String? userId;
  String? email;
  String? name;
  Timestamp? insertDate;

  AppUser({this.userId,this.email,this.name});
  Map<String,dynamic> toMap()=>{
    "userId":userId,
    "email":email,
    "name":name,
    "insertDate":insertDate??FieldValue.serverTimestamp()
  };
  AppUser fromJson(Map<String,dynamic> json){
    userId=json["userId"];
    email=json["email"];
    name=json["name"];
    insertDate=json["insertDate"];
    return this;
  }
}