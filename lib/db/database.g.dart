// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorDataBase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$DataBaseBuilder databaseBuilder(String name) =>
      _$DataBaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$DataBaseBuilder inMemoryDatabaseBuilder() => _$DataBaseBuilder(null);
}

class _$DataBaseBuilder {
  _$DataBaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$DataBaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$DataBaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<DataBase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$DataBase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$DataBase extends DataBase {
  _$DataBase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  NoteDao? _noteDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
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
            'CREATE TABLE IF NOT EXISTS `note` (`id` TEXT NOT NULL, `createTime` INTEGER NOT NULL, `updateTime` INTEGER NOT NULL, `text` TEXT NOT NULL, `title` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  NoteDao get noteDao {
    return _noteDaoInstance ??= _$NoteDao(database, changeListener);
  }
}

class _$NoteDao extends NoteDao {
  _$NoteDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _noteItemInsertionAdapter = InsertionAdapter(
            database,
            'note',
            (NoteItem item) => <String, Object?>{
                  'id': item.id,
                  'createTime': item.createTime,
                  'updateTime': item.updateTime,
                  'text': item.text,
                  'title': item.title
                }),
        _noteItemDeletionAdapter = DeletionAdapter(
            database,
            'note',
            ['id'],
            (NoteItem item) => <String, Object?>{
                  'id': item.id,
                  'createTime': item.createTime,
                  'updateTime': item.updateTime,
                  'text': item.text,
                  'title': item.title
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<NoteItem> _noteItemInsertionAdapter;

  final DeletionAdapter<NoteItem> _noteItemDeletionAdapter;

  @override
  Future<void> deleteItems(List<String> noteIds) async {
    const offset = 1;
    final _sqliteVariablesForNoteIds =
        Iterable<String>.generate(noteIds.length, (i) => '?${i + offset}')
            .join(',');
    await _queryAdapter.queryNoReturn(
        'DELETE FROM note WHERE id IN (' + _sqliteVariablesForNoteIds + ')',
        arguments: [...noteIds]);
  }

  @override
  Future<NoteItem?> findNoteItemById(String id) async {
    return _queryAdapter.query('SELECT * FROM note WHERE id = ?1',
        mapper: (Map<String, Object?> row) => NoteItem(row['id'] as String,
            createTime: row['createTime'] as int,
            updateTime: row['updateTime'] as int,
            text: row['text'] as String,
            title: row['title'] as String),
        arguments: [id]);
  }

  @override
  Future<List<NoteItem>> findNoteItems() async {
    return _queryAdapter.queryList(
        'SELECT * FROM note  ORDER BY updateTime DESC',
        mapper: (Map<String, Object?> row) => NoteItem(row['id'] as String,
            createTime: row['createTime'] as int,
            updateTime: row['updateTime'] as int,
            text: row['text'] as String,
            title: row['title'] as String));
  }

  @override
  Future<void> saveItem(NoteItem noteItem) async {
    await _noteItemInsertionAdapter.insert(
        noteItem, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteItem(NoteItem noteItem) async {
    await _noteItemDeletionAdapter.delete(noteItem);
  }
}
