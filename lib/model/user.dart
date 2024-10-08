import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  String? userId;
  String? email;
  String? name;
  String? lastName;
  String? country;
  String? city;
  Timestamp? insertDate;
  String? avatarName;

  AppUser({
    this.userId,
    this.email,
    this.name,
    this.avatarName,
    this.lastName,
    this.country,
    this.city,
  });
  AppUser updateAvatar(String avatarName) {
    this.avatarName = avatarName;
    return this;
  }

  Map<String, dynamic> toMap() => {
        "userId": userId,
        "email": email,
        "name": name,
        "insertDate": insertDate ?? FieldValue.serverTimestamp(),
        "avatarName": avatarName,
        "lastName": lastName,
        "country": country,
        "city": city,
      };
  AppUser fromJson(Map<String, dynamic> json) {
    userId = json["userId"];
    email = json["email"];
    name = json["name"];
    insertDate = json["insertDate"];
    avatarName = json["avatarName"];
    lastName = json["lastName"];
    country = json["country"];
    city = json["city"];
    return this;
  }

  DateTime get formattedInsertDate => ((insertDate ?? FieldValue.serverTimestamp()) as Timestamp).toDate();
}
