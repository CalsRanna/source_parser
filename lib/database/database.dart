import 'dart:async';

import 'package:floor/floor.dart';
import 'package:source_parser/dao/book_dao.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart' as sqflite;

import '../model/book.dart';
import '../model/book_source.dart';
import '../model/rule.dart';
import '../dao/book_source_dao.dart';
import '../dao/rule_dao.dart';

part 'database.g.dart';

@Database(version: 1, entities: [Book, BookSource, Rule])
abstract class AppDatabase extends FloorDatabase {
  BookDao get bookDao;
  BookSourceDao get bookSourceDao;
  RuleDao get ruleDao;
}
