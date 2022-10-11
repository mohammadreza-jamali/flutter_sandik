import 'package:event_bus/event_bus.dart';
import 'package:flutter_sandik/core/application/navigation_service.dart';
import 'package:flutter_sandik/core/application/shared_preference_manager.dart';
import 'package:flutter_sandik/core/application/theme_manager.dart';
import 'package:flutter_sandik/repository/db_repository.dart';
import 'package:flutter_sandik/repository/user_repository.dart';
import 'package:flutter_sandik/services/concerete/firebase_auth_service.dart';
import 'package:flutter_sandik/services/concerete/firestore_db_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt locator=GetIt.instance;
void setupLocator(){
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => FirestoreDbService());
  locator.registerLazySingleton(() => DbRepository());
  locator.registerSingletonAsync(() => SharedPreferences.getInstance());
  locator.registerLazySingleton(() => EventBus(sync: true));
  locator.registerLazySingleton(() => ThemeManager());
  locator.registerLazySingleton(() => NavigationService());
}