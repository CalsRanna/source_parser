import 'dart:async';

import 'package:floor/floor.dart';
import 'package:source_parser/dao/book_dao.dart';
import 'package:source_parser/dao/book_source_dao.dart';
import 'package:source_parser/dao/rule_dao.dart';
import 'package:source_parser/model/book.dart';
import 'package:source_parser/model/book_source.dart';
import 'package:source_parser/model/rule.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version: 1, entities: [Book, BookSource, Rule])
abstract class AppDatabase extends FloorDatabase {
  BookDao get bookDao;
  BookSourceDao get bookSourceDao;
  RuleDao get ruleDao;
}
