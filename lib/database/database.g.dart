// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: library_private_types_in_public_api, unnecessary_string_escapes

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  BookDao? _bookDaoInstance;

  BookSourceDao? _bookSourceDaoInstance;

  RuleDao? _ruleDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `books` (`id` INTEGER, `author` TEXT, `cover` TEXT, `category` TEXT, `introduction` TEXT, `name` TEXT, `url` TEXT, `catalogue_url` TEXT, `status` TEXT, `words` TEXT, `latest_chapter` TEXT, `sourceId` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `book_sources` (`charset` TEXT NOT NULL, `comment` TEXT, `enabled` INTEGER NOT NULL, `explore_enabled` INTEGER NOT NULL, `explore_url` TEXT, `group` TEXT NOT NULL, `header` TEXT, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `login_url` TEXT, `name` TEXT NOT NULL, `order` INTEGER NOT NULL, `response_time` INTEGER, `search_url` TEXT, `type` INTEGER NOT NULL, `update_at` INTEGER, `url` TEXT NOT NULL, `url_pattern` TEXT, `weight` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `rules` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `source_id` INTEGER, `value` TEXT)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  BookDao get bookDao {
    return _bookDaoInstance ??= _$BookDao(database, changeListener);
  }

  @override
  BookSourceDao get bookSourceDao {
    return _bookSourceDaoInstance ??= _$BookSourceDao(database, changeListener);
  }

  @override
  RuleDao get ruleDao {
    return _ruleDaoInstance ??= _$RuleDao(database, changeListener);
  }
}

class _$BookDao extends BookDao {
  _$BookDao(
    this.database,
    this.changeListener,
  ) : _queryAdapter = QueryAdapter(database);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  @override
  Future<List<Book>> getAllBooks() async {
    return _queryAdapter.queryList('select * from books',
        mapper: (Map<String, Object?> row) => Book(
            id: row['id'] as int?,
            author: row['author'] as String?,
            category: row['category'] as String?,
            cover: row['cover'] as String?,
            introduction: row['introduction'] as String?,
            name: row['name'] as String?,
            url: row['url'] as String?,
            catalogueUrl: row['catalogue_url'] as String?,
            status: row['status'] as String?,
            words: row['words'] as String?,
            latestChapter: row['latest_chapter'] as String?,
            sourceId: row['sourceId'] as int?));
  }
}

class _$BookSourceDao extends BookSourceDao {
  _$BookSourceDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _bookSourceInsertionAdapter = InsertionAdapter(
            database,
            'book_sources',
            (BookSource item) => <String, Object?>{
                  'charset': item.charset,
                  'comment': item.comment,
                  'enabled': item.enabled ? 1 : 0,
                  'explore_enabled': item.exploreEnabled ? 1 : 0,
                  'explore_url': item.exploreUrl,
                  'group': item.group,
                  'header': item.header,
                  'id': item.id,
                  'login_url': item.loginUrl,
                  'name': item.name,
                  'order': item.order,
                  'response_time': item.responseTime,
                  'search_url': item.searchUrl,
                  'type': item.type,
                  'update_at': item.updatedAt,
                  'url': item.url,
                  'url_pattern': item.urlPattern,
                  'weight': item.weight
                }),
        _bookSourceUpdateAdapter = UpdateAdapter(
            database,
            'book_sources',
            ['id'],
            (BookSource item) => <String, Object?>{
                  'charset': item.charset,
                  'comment': item.comment,
                  'enabled': item.enabled ? 1 : 0,
                  'explore_enabled': item.exploreEnabled ? 1 : 0,
                  'explore_url': item.exploreUrl,
                  'group': item.group,
                  'header': item.header,
                  'id': item.id,
                  'login_url': item.loginUrl,
                  'name': item.name,
                  'order': item.order,
                  'response_time': item.responseTime,
                  'search_url': item.searchUrl,
                  'type': item.type,
                  'update_at': item.updatedAt,
                  'url': item.url,
                  'url_pattern': item.urlPattern,
                  'weight': item.weight
                }),
        _bookSourceDeletionAdapter = DeletionAdapter(
            database,
            'book_sources',
            ['id'],
            (BookSource item) => <String, Object?>{
                  'charset': item.charset,
                  'comment': item.comment,
                  'enabled': item.enabled ? 1 : 0,
                  'explore_enabled': item.exploreEnabled ? 1 : 0,
                  'explore_url': item.exploreUrl,
                  'group': item.group,
                  'header': item.header,
                  'id': item.id,
                  'login_url': item.loginUrl,
                  'name': item.name,
                  'order': item.order,
                  'response_time': item.responseTime,
                  'search_url': item.searchUrl,
                  'type': item.type,
                  'update_at': item.updatedAt,
                  'url': item.url,
                  'url_pattern': item.urlPattern,
                  'weight': item.weight
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<BookSource> _bookSourceInsertionAdapter;

  final UpdateAdapter<BookSource> _bookSourceUpdateAdapter;

  final DeletionAdapter<BookSource> _bookSourceDeletionAdapter;

  @override
  Future<BookSource?> getBookSource(int id) async {
    return _queryAdapter.query('select * from book_sources where id=?1',
        mapper: (Map<String, Object?> row) => BookSource(
            row['charset'] as String,
            row['comment'] as String?,
            (row['enabled'] as int) != 0,
            (row['explore_enabled'] as int) != 0,
            row['explore_url'] as String?,
            row['group'] as String,
            row['header'] as String?,
            row['id'] as int?,
            row['login_url'] as String?,
            row['name'] as String,
            row['order'] as int,
            row['response_time'] as int?,
            row['search_url'] as String?,
            row['type'] as int,
            row['update_at'] as int?,
            row['url'] as String,
            row['url_pattern'] as String?,
            row['weight'] as int),
        arguments: [id]);
  }

  @override
  Future<BookSource?> findBookSourceByName(String name) async {
    return _queryAdapter.query('select * from book_sources where name=?1',
        mapper: (Map<String, Object?> row) => BookSource(
            row['charset'] as String,
            row['comment'] as String?,
            (row['enabled'] as int) != 0,
            (row['explore_enabled'] as int) != 0,
            row['explore_url'] as String?,
            row['group'] as String,
            row['header'] as String?,
            row['id'] as int?,
            row['login_url'] as String?,
            row['name'] as String,
            row['order'] as int,
            row['response_time'] as int?,
            row['search_url'] as String?,
            row['type'] as int,
            row['update_at'] as int?,
            row['url'] as String,
            row['url_pattern'] as String?,
            row['weight'] as int),
        arguments: [name]);
  }

  @override
  Future<BookSource?> findBookSourceByUrl(String url) async {
    return _queryAdapter.query('select * from book_sources where url like %?1%',
        mapper: (Map<String, Object?> row) => BookSource(
            row['charset'] as String,
            row['comment'] as String?,
            (row['enabled'] as int) != 0,
            (row['explore_enabled'] as int) != 0,
            row['explore_url'] as String?,
            row['group'] as String,
            row['header'] as String?,
            row['id'] as int?,
            row['login_url'] as String?,
            row['name'] as String,
            row['order'] as int,
            row['response_time'] as int?,
            row['search_url'] as String?,
            row['type'] as int,
            row['update_at'] as int?,
            row['url'] as String,
            row['url_pattern'] as String?,
            row['weight'] as int),
        arguments: [url]);
  }

  @override
  Future<BookSource?> findFirstExploreEnabledBookSource() async {
    return _queryAdapter.query(
        'select * from book_sources where explore_enabled=1 order by weight asc limit 1',
        mapper: (Map<String, Object?> row) => BookSource(
            row['charset'] as String,
            row['comment'] as String?,
            (row['enabled'] as int) != 0,
            (row['explore_enabled'] as int) != 0,
            row['explore_url'] as String?,
            row['group'] as String,
            row['header'] as String?,
            row['id'] as int?,
            row['login_url'] as String?,
            row['name'] as String,
            row['order'] as int,
            row['response_time'] as int?,
            row['search_url'] as String?,
            row['type'] as int,
            row['update_at'] as int?,
            row['url'] as String,
            row['url_pattern'] as String?,
            row['weight'] as int));
  }

  @override
  Future<List<BookSource>> getAllBookSources() async {
    return _queryAdapter.queryList('SELECT * FROM book_sources',
        mapper: (Map<String, Object?> row) => BookSource(
            row['charset'] as String,
            row['comment'] as String?,
            (row['enabled'] as int) != 0,
            (row['explore_enabled'] as int) != 0,
            row['explore_url'] as String?,
            row['group'] as String,
            row['header'] as String?,
            row['id'] as int?,
            row['login_url'] as String?,
            row['name'] as String,
            row['order'] as int,
            row['response_time'] as int?,
            row['search_url'] as String?,
            row['type'] as int,
            row['update_at'] as int?,
            row['url'] as String,
            row['url_pattern'] as String?,
            row['weight'] as int));
  }

  @override
  Future<List<BookSource>> getAllExploreEnabledBookSources() async {
    return _queryAdapter.queryList(
        'select * from book_sources where explore_enabled=1 order by weight asc',
        mapper: (Map<String, Object?> row) => BookSource(
            row['charset'] as String,
            row['comment'] as String?,
            (row['enabled'] as int) != 0,
            (row['explore_enabled'] as int) != 0,
            row['explore_url'] as String?,
            row['group'] as String,
            row['header'] as String?,
            row['id'] as int?,
            row['login_url'] as String?,
            row['name'] as String,
            row['order'] as int,
            row['response_time'] as int?,
            row['search_url'] as String?,
            row['type'] as int,
            row['update_at'] as int?,
            row['url'] as String,
            row['url_pattern'] as String?,
            row['weight'] as int));
  }

  @override
  Future<List<BookSource>> getAllEnabledBookSources() async {
    return _queryAdapter.queryList(
        'select * from book_sources where enabled=1 order by weight asc',
        mapper: (Map<String, Object?> row) => BookSource(
            row['charset'] as String,
            row['comment'] as String?,
            (row['enabled'] as int) != 0,
            (row['explore_enabled'] as int) != 0,
            row['explore_url'] as String?,
            row['group'] as String,
            row['header'] as String?,
            row['id'] as int?,
            row['login_url'] as String?,
            row['name'] as String,
            row['order'] as int,
            row['response_time'] as int?,
            row['search_url'] as String?,
            row['type'] as int,
            row['update_at'] as int?,
            row['url'] as String,
            row['url_pattern'] as String?,
            row['weight'] as int));
  }

  @override
  Future<void> emptyBookSources() async {
    await _queryAdapter.queryNoReturn(
        'delete from book_sources;update sqlite_sequence set seq=0 where name=\"book_sources\";');
  }

  @override
  Future<void> insertBookSource(BookSource bookSource) async {
    await _bookSourceInsertionAdapter.insert(
        bookSource, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateBookSource(BookSource bookSource) async {
    await _bookSourceUpdateAdapter.update(bookSource, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteBookSource(BookSource bookSource) async {
    await _bookSourceDeletionAdapter.delete(bookSource);
  }
}

class _$RuleDao extends RuleDao {
  _$RuleDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _ruleInsertionAdapter = InsertionAdapter(
            database,
            'rules',
            (Rule item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'source_id': item.sourceId,
                  'value': item.value
                }),
        _ruleUpdateAdapter = UpdateAdapter(
            database,
            'rules',
            ['id'],
            (Rule item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'source_id': item.sourceId,
                  'value': item.value
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Rule> _ruleInsertionAdapter;

  final UpdateAdapter<Rule> _ruleUpdateAdapter;

  @override
  Future<Rule?> findRuleById(int id) async {
    return _queryAdapter.query('select * from rules where id=?1',
        mapper: (Map<String, Object?> row) => Rule(
            row['id'] as int?,
            row['name'] as String,
            row['source_id'] as int?,
            row['value'] as String?),
        arguments: [id]);
  }

  @override
  Future<List<Rule>> getRulesBySourceId(int sourceId) async {
    return _queryAdapter.queryList(
        'select * from rules where source_id=?1 order by name',
        mapper: (Map<String, Object?> row) => Rule(
            row['id'] as int?,
            row['name'] as String,
            row['source_id'] as int?,
            row['value'] as String?),
        arguments: [sourceId]);
  }

  @override
  Future<Rule?> getRuleByNameAndSourceId(
    String name,
    int sourceId,
  ) async {
    return _queryAdapter.query(
        'select * from rules where name=?1 and source_id=?2',
        mapper: (Map<String, Object?> row) => Rule(
            row['id'] as int?,
            row['name'] as String,
            row['source_id'] as int?,
            row['value'] as String?),
        arguments: [name, sourceId]);
  }

  @override
  Future<List<Rule>> getAllRules() async {
    return _queryAdapter.queryList('select * from rules',
        mapper: (Map<String, Object?> row) => Rule(
            row['id'] as int?,
            row['name'] as String,
            row['source_id'] as int?,
            row['value'] as String?));
  }

  @override
  Future<void> emptyRules() async {
    await _queryAdapter.queryNoReturn(
        'delete from rules;update sqlite_sequence set seq=0 where name=\"rules\";');
  }

  @override
  Future<void> insertRule(Rule rule) async {
    await _ruleInsertionAdapter.insert(rule, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateRule(Rule rule) async {
    await _ruleUpdateAdapter.update(rule, OnConflictStrategy.abort);
  }
}
