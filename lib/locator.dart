import 'package:flutter_sandik/repository/db_repository.dart';
import 'package:flutter_sandik/repository/user_repository.dart';
import 'package:flutter_sandik/services/concerete/firebase_auth_service.dart';
import 'package:flutter_sandik/services/concerete/firestore_db_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator=GetIt.instance;
void setupLocator(){
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => FirestoreDbService());
  locator.registerLazySingleton(() => DbRepository());
}