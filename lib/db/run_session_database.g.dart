// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'run_session_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorRunSessionDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$RunSessionDatabaseBuilder databaseBuilder(String name) =>
      _$RunSessionDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$RunSessionDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$RunSessionDatabaseBuilder(null);
}

class _$RunSessionDatabaseBuilder {
  _$RunSessionDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$RunSessionDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$RunSessionDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<RunSessionDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$RunSessionDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$RunSessionDatabase extends RunSessionDatabase {
  _$RunSessionDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  RunSessionDao? _runSessionDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `RunSession` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `email` TEXT, `img` BLOB, `runSessionTitle` TEXT NOT NULL, `timestamp` REAL NOT NULL, `avgSpeedInKMH` REAL NOT NULL, `distanceInMeters` INTEGER NOT NULL, `timeInMilis` REAL NOT NULL, `caloriesBurnt` INTEGER NOT NULL, `stepsPerSession` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  RunSessionDao get runSessionDao {
    return _runSessionDaoInstance ??= _$RunSessionDao(database, changeListener);
  }
}

class _$RunSessionDao extends RunSessionDao {
  _$RunSessionDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _runSessionInsertionAdapter = InsertionAdapter(
            database,
            'RunSession',
            (RunSession item) => <String, Object?>{
                  'id': item.id,
                  'email': item.email,
                  'img': item.img,
                  'runSessionTitle': item.runSessionTitle,
                  'timestamp': item.timestamp,
                  'avgSpeedInKMH': item.avgSpeedInKMH,
                  'distanceInMeters': item.distanceInMeters,
                  'timeInMilis': item.timeInMilis,
                  'caloriesBurnt': item.caloriesBurnt,
                  'stepsPerSession': item.stepsPerSession
                },
            changeListener),
        _runSessionDeletionAdapter = DeletionAdapter(
            database,
            'RunSession',
            ['id'],
            (RunSession item) => <String, Object?>{
                  'id': item.id,
                  'email': item.email,
                  'img': item.img,
                  'runSessionTitle': item.runSessionTitle,
                  'timestamp': item.timestamp,
                  'avgSpeedInKMH': item.avgSpeedInKMH,
                  'distanceInMeters': item.distanceInMeters,
                  'timeInMilis': item.timeInMilis,
                  'caloriesBurnt': item.caloriesBurnt,
                  'stepsPerSession': item.stepsPerSession
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<RunSession> _runSessionInsertionAdapter;

  final DeletionAdapter<RunSession> _runSessionDeletionAdapter;

  @override
  Stream<List<RunSession>> getAllRunSessionsSortedByDate(String email) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM runsession WHERE email = ?1 ORDER BY timestamp DESC',
        mapper: (Map<String, Object?> row) => RunSession(
            row['id'] as int,
            row['email'] as String?,
            row['img'] as Uint8List?,
            row['runSessionTitle'] as String,
            row['timestamp'] as double,
            row['avgSpeedInKMH'] as double,
            row['distanceInMeters'] as int,
            row['timeInMilis'] as double,
            row['caloriesBurnt'] as int,
            row['stepsPerSession'] as int),
        arguments: [email],
        queryableName: 'RunSession',
        isView: false);
  }

  @override
  Stream<List<RunSession>> getAllRunSessionsSortedByTimeInMilis(String email) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM runsession WHERE email = ?1 ORDER BY timeInMilis DESC',
        mapper: (Map<String, Object?> row) => RunSession(
            row['id'] as int,
            row['email'] as String?,
            row['img'] as Uint8List?,
            row['runSessionTitle'] as String,
            row['timestamp'] as double,
            row['avgSpeedInKMH'] as double,
            row['distanceInMeters'] as int,
            row['timeInMilis'] as double,
            row['caloriesBurnt'] as int,
            row['stepsPerSession'] as int),
        arguments: [email],
        queryableName: 'RunSession',
        isView: false);
  }

  @override
  Stream<List<RunSession>> getAllRunSessionsSortedByCaloriesBurnt(
      String email) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM runsession WHERE email = ?1 ORDER BY caloriesBurnt DESC',
        mapper: (Map<String, Object?> row) => RunSession(
            row['id'] as int,
            row['email'] as String?,
            row['img'] as Uint8List?,
            row['runSessionTitle'] as String,
            row['timestamp'] as double,
            row['avgSpeedInKMH'] as double,
            row['distanceInMeters'] as int,
            row['timeInMilis'] as double,
            row['caloriesBurnt'] as int,
            row['stepsPerSession'] as int),
        arguments: [email],
        queryableName: 'RunSession',
        isView: false);
  }

  @override
  Stream<List<RunSession>> getAllRunSessionsSortedByAvgSpeed(String email) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM runsession WHERE email = ?1 ORDER BY avgSpeedInKMH DESC',
        mapper: (Map<String, Object?> row) => RunSession(
            row['id'] as int,
            row['email'] as String?,
            row['img'] as Uint8List?,
            row['runSessionTitle'] as String,
            row['timestamp'] as double,
            row['avgSpeedInKMH'] as double,
            row['distanceInMeters'] as int,
            row['timeInMilis'] as double,
            row['caloriesBurnt'] as int,
            row['stepsPerSession'] as int),
        arguments: [email],
        queryableName: 'RunSession',
        isView: false);
  }

  @override
  Stream<List<RunSession>> getAllRunSessionsSortedByDistance(String email) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM runsession WHERE email = ?1 ORDER BY distanceInMeters DESC',
        mapper: (Map<String, Object?> row) => RunSession(
            row['id'] as int,
            row['email'] as String?,
            row['img'] as Uint8List?,
            row['runSessionTitle'] as String,
            row['timestamp'] as double,
            row['avgSpeedInKMH'] as double,
            row['distanceInMeters'] as int,
            row['timeInMilis'] as double,
            row['caloriesBurnt'] as int,
            row['stepsPerSession'] as int),
        arguments: [email],
        queryableName: 'RunSession',
        isView: false);
  }

  @override
  Stream<List<RunSession>> getAllRunSessionsSortedBySteps(String email) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM runsession WHERE email = ?1 ORDER BY stepsPerSession DESC',
        mapper: (Map<String, Object?> row) => RunSession(
            row['id'] as int,
            row['email'] as String?,
            row['img'] as Uint8List?,
            row['runSessionTitle'] as String,
            row['timestamp'] as double,
            row['avgSpeedInKMH'] as double,
            row['distanceInMeters'] as int,
            row['timeInMilis'] as double,
            row['caloriesBurnt'] as int,
            row['stepsPerSession'] as int),
        arguments: [email],
        queryableName: 'RunSession',
        isView: false);
  }

  @override
  Future<void> insertRunSession(RunSession runSession) async {
    await _runSessionInsertionAdapter.insert(
        runSession, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteRunSession(RunSession runSession) async {
    await _runSessionDeletionAdapter.delete(runSession);
  }
}
