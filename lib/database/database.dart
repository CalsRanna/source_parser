import 'dart:async';

import 'package:floor/floor.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart' as sqflite;

import '../entity/book_source.dart';
import '../entity/rule.dart';
import 'book_source_dao.dart';
import 'rule_dao.dart';

part 'database.g.dart';

@Database(version: 1, entities: [BookSource, Rule])
abstract class AppDatabase extends FloorDatabase {
  BookSourceDao get bookSourceDao;
  RuleDao get ruleDao;
}
