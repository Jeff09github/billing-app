import 'package:flutter/foundation.dart';
import 'package:maaa/presentation/resources/enum.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/model.dart';

class LocalDatabase {
  static final LocalDatabase instance = LocalDatabase._init();

  static Database? _database;

  LocalDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('maaa.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    if (kDebugMode) {
      print('init db');
    }
    final appDocumentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(appDocumentsDirectory.path, fileName);
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
        ${CustomerField.previousReading} $_textTypeN,
        ${CustomerField.currentReading} $_textTypeN,
        ${CustomerField.toPay} $_integerType,
        ${CustomerField.createdAt} $_textType,
        ${CustomerField.updatedAt} $_textTypeN
      )
    ''');

    _batch.execute('''
      CREATE TABLE $tableReadings(
        ${ReadingField.id} $_idType,
        ${ReadingField.customerId} $_integerType,
        ${ReadingField.billType} $_textType,
        ${ReadingField.reading} $_textType,
        ${ReadingField.createdAt} $_textType
      )
    ''');

    _batch.execute('''
      CREATE TABLE $tableBills(
        ${BillField.id} $_idType,
        ${BillField.customerId} $_integerType,
        ${BillField.readingId} $_integerType,
        ${BillField.type} $_textType,
        ${BillField.currentReading} $_textTypeN,
        ${BillField.previousReading} $_textTypeN,
        ${BillField.consumeCM} $_integerType,
        ${BillField.billAmount} $_integerType,
        ${BillField.previousbalance} $_integerType,
        ${BillField.totalAmount} $_integerType,
        ${BillField.createdAt} $_textType
      )
    ''');

    _batch.execute('''
      CREATE TABLE $tablePayments(
        ${PaymentField.id} $_idType,
        ${PaymentField.customerId} $_integerType,
        ${PaymentField.amount} $_integerType,
        ${PaymentField.note} $_textType,
        ${PaymentField.createdAt} $_textType
      )
    ''');

    await _batch.commit();
    print('done creating db');
  }

  Future<Customer?> addCustomer({required Customer customer}) async {
    final _db = await instance.database;
    final _id = await _db.insert(tableCustomers, customer.toJson());
    return customer.copy(id: _id);
  }

  Future<Customer> updateCustomer({required Customer updatedCustomer}) async {
    final _db = await instance.database;
    await _db.update(
      tableCustomers,
      updatedCustomer.toJson(),
      where: '${CustomerField.id} = ?',
      whereArgs: [updatedCustomer.id],
    );
    return updatedCustomer;
  }

  Future<int?> addReading({
    required Reading newReading,
    required Customer customer,
  }) async {
    // final reading = Reading(
    //   billType: billType,
    //   reading: currentReading,
    //   customerId: customer.id!,
    //   createdAt: DateTime.now(),
    // );
    final db = await instance.database;
    // final currentReading = customer.currentReading;
    final updatedCustomer = customer.copy(
      previousReading: customer.currentReading,
      currentReading: newReading.reading,
    );

    int? readingId;

    await db.transaction(
      (txn) async => {
        readingId = await txn.insert(tableReadings, newReading.toJson()),
        await txn.update(
          tableCustomers,
          updatedCustomer.toJson(),
          where: '${CustomerField.id} = ?',
          whereArgs: [updatedCustomer.id],
        ),
      },
    );
    return readingId;
  }

  Future<List<Map<String, Object?>>> getReadingList(
      int customerId, BillType billType) async {
    final _db = await instance.database;
    return await _db.rawQuery(
        'SELECT * FROM $tableReadings WHERE ${ReadingField.customerId} = $customerId ORDER BY ${ReadingField.id} ASC');
  }

  Future<List<Reading>?> getLastTwoReading(
      int customerId, BillType billType) async {
    try {
      final _db = await instance.database;
      // final _result = await _db
      //     .query(tableReadings, where: 'id  = ?', whereArgs: [customerId]);
      final _result = await _db.rawQuery(
          'SELECT * FROM $tableReadings WHERE ${ReadingField.customerId} = $customerId ORDER BY ${ReadingField.id} DESC LIMIT 2');
      print(_result);
      return _result.map((e) => Reading.fromJson(e)).toList();
    } catch (e) {
      print('error: $e');
      return null;
    }
  }

  Future<List<Map<String, Object?>>> getCustomerList() async {
    final _db = await instance.database;
    const _orderBy = '${CustomerField.fullName} ASC';
    return await _db.query(tableCustomers, orderBy: _orderBy);
  }

  Future<Bill?> createBill({
    required Customer customer,
    required Reading currentReading,
    required Reading previousReading,
    required BillType billType,
  }) async {
    try {
      final _db = await instance.database;
      final _consumeCM = int.parse(currentReading.reading) -
          int.parse(previousReading.reading);
      final _billAmount = _consumeCM * 80;
      final _balance = customer.toPay;
      final _totalAmount = _billAmount + _balance;
      final _bill = Bill(
        customerId: customer.id!,
        readingId: currentReading.id!,
        type: billType,
        currentReading: currentReading.reading,
        previousReading: previousReading.reading,
        consumeCM: _consumeCM,
        billAmount: _billAmount,
        previousbalance: _balance,
        totalAmount: _totalAmount,
        createdAt: DateTime.now(),
      );
      // final _id = await _db.insert();
      final _batch = _db.batch();

      _batch.insert(tableBills, _bill.toJson());

      final _customer = customer.copy(toPay: _totalAmount);
      _batch.update(tableCustomers, _customer.toJson(),
          where: '${CustomerField.id} = ?', whereArgs: [_customer.id]);
      final _result = await _batch.commit();
      print(_result);
      return _bill.copy();
    } catch (e) {
      return null;
    }
  }

  Future<Bill?> getBill({required int readingId}) async {
    try {
      final _db = await instance.database;
      final _result = await _db.rawQuery(
          'SELECT * FROM $tableBills WHERE ${BillField.readingId} = $readingId');
      return Bill.fromJson(_result[0]);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Payment?> postPayment(
      {required String amount, required Customer customer}) async {
    try {
      final _payment = Payment(
        customerId: customer.id!,
        amount: int.parse(amount),
        note: '',
        createdAt: DateTime.now().toString(),
      );
      final _db = await instance.database;
      int? paymentId;
      final result = await _db.transaction((txn) async {
        paymentId = await txn.insert(tablePayments, _payment.toJson());
        int newTopay = customer.toPay - _payment.amount;
        await txn.update(tableCustomers, {CustomerField.toPay: newTopay},
            where: '${CustomerField.id} = ?', whereArgs: [customer.id]);
      });
      print('payment result = $result');
      return _payment.copy(id: paymentId);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> close() async {
    print('closing');
    final _db = await instance.database;
    await _db.close();
  }
}
