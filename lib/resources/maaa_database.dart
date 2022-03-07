import 'package:maaa/model/customer/customer.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/bill/bill.dart';
import '../model/reading/reading.dart';

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
    print('init db');
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, fileName);

    return await openDatabase(path, onCreate: _createDB, version: 1);
  }

  Future<void> _createDB(Database db, int version) async {
    const _idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const _textType = 'TEXT NOT NULL';
    const _textTypeN = 'TEXT';
    // const _boolType = 'BOOLEAN NOT NULL';
    const _integerType = 'INTEGER NOT NULL';

    final _batch = db.batch();
    _batch.execute('''
      CREATE TABLE $tableCustomers(
        ${CustomerField.id} $_idType,
        ${CustomerField.fullName} $_textType,
        ${CustomerField.createdAt} $_textType,
        ${CustomerField.updatedAt} $_textTypeN
      )
    ''');

    _batch.execute('''
      CREATE TABLE $tableReadings(
        ${ReadingField.id} $_idType,
        ${ReadingField.type} $_textType,
        ${ReadingField.reading} $_integerType,
        ${ReadingField.createdAt} $_textType
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
        ${BillField.updatedAt} $_textTypeN
      )
    ''');

    await _batch.commit();
  }

  Future<Customer?> addCustomer({required String fullName}) async {
    try {
      final _customer = Customer(fullName: fullName, createdAt: DateTime.now());
      final _db = await instance.database;
      final id = await _db.insert(tableCustomers, _customer.toJson());
      print('add customer success');
      return _customer.copy(id: id);
    } catch (e) {
      print('error: $e');
      return null;
    }
  }

  Future<List<Customer>?> getAllCustomer() async {
    try {
      final _db = await instance.database;
      const _orderBy = '${CustomerField.fullName} ASC';
      final _result = await _db.query(tableCustomers, orderBy: _orderBy);
      return _result.map((e) => Customer.fromJson(e)).toList();
    } catch (e) {
      return null;
    }
  }

  Future<void> close() async {
    print('closing');
    final _db = await instance.database;
    await _db.close();
  }
}
