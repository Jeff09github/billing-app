import 'package:maaa/model/customer/customer.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/bill/bill.dart';

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
    // const _boolType = 'BOOLEAN NOT NULL';
    const _integerType = 'INTEGER NOT NULL';

    final _batch = db.batch();
    _batch.execute('''
      CREATE TABLE $tableCustomers(
        ${CustomerField.id} $_idType,
        ${CustomerField.fullName} $_textType,
        ${CustomerField.createdAt} $_textType,
        ${CustomerField.updatedAt} $_textType
      )
    ''');
    _batch.execute('''
      CREATE TABLE $tableBills(
        ${BillField.id} $_idType,
        ${BillField.customerId} $_integerType,
        ${BillField.type} $_textType,
        ${BillField.currentReading} $_textType,
        ${BillField.previousReading} $_textType,
        ${BillField.consumeCM} $_integerType,
        ${BillField.billAmount} $_integerType,
        ${BillField.previousbalance} $_integerType,
        ${BillField.totalAmount} $_integerType,
        ${BillField.createdAt} $_textType,
        ${BillField.updatedAt} $_textType
      )
    ''');

    await _batch.commit();
  }

  Future<Customer?> addCustomer(Customer customer) async {
    try {
      final _db = await instance.database;
      final id = await _db.insert(tableCustomers, customer.toJson());
      return customer.copy(id: id);
    } catch (e) {
      return null;
    }
  }
}
