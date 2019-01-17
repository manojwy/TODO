import 'dart:async';

import 'database.dart';

class Repository {
  static final Repository _instance = new Repository.internal();

  factory Repository() => _instance;

  static DatabaseHelper _database;

  Repository.internal();

  static DatabaseHelper getDatabase() {
    return DatabaseHelper();
  }

}