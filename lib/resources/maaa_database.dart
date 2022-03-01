import 'package:maaa/model/customer/customer.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MaaaDatabase {
  static final MaaaDatabase instance = MaaaDatabase._init();

  static Database? _database;

  MaaaDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('maaa.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, fileName);

    return await openDatabase(path, onCreate: _createDB, version: 1);
  }

  Future<void> _createDB(Database db, int version) async {
    const _idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const _textType = 'TEXT NOT NULL';
    const _boolType = 'BOOLEAN NOT NULL';
    const _integerType = 'INTEGER NOT NULL';

    final _batch = db.batch();
    _batch.execute('''
      CREATE TABLE $tableCustomers(
        ${CustomerField.id} $_idType,
        ${CustomerField.fullName} $_textType,
      )
    ''');
  }
}
