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
    const _boolType = 'BOOLEAN NOT NULL';
    const _integerType = 'INTEGER NOT NULL';
    const _integerTypeN = 'INTEGER';

    final _batch = db.batch();
    _batch.execute('''
      CREATE TABLE $tableCustomers(
        ${CustomerField.id} $_idType,
        ${CustomerField.fullName} $_textType,
        ${CustomerField.billType} $_textType,
        ${CustomerField.createdAt} $_textType,
        ${CustomerField.updatedAt} $_textTypeN
      )
    ''');

    // _batch.execute('''
    //   CREATE TABLE $tableReadings(
    //     ${ReadingField.id} $_idType,
    //     ${ReadingField.initial} $_boolType,
    //     ${ReadingField.customerId} $_integerType,
    //     ${ReadingField.billType} $_textType,
    //     ${ReadingField.reading} $_textType,
    //     ${ReadingField.createdAt} $_textType
    //   )
    // ''');

    _batch.execute('''
      CREATE TABLE $tableWaterBillsInfo(
        ${WaterBillsInfoField.id} $_idType,
        ${WaterBillsInfoField.customerId} $_integerType,
        ${WaterBillsInfoField.reading} $_textType,
        ${WaterBillsInfoField.bill} $_integerTypeN,
        ${WaterBillsInfoField.initial} $_boolType,
        ${WaterBillsInfoField.dateCreated} $_textType,
        ${WaterBillsInfoField.dateUpdated} $_textTypeN
      )
    ''');

    // _batch.execute('''
    //   CREATE TABLE $tableWaterBills(
    //     ${WaterBillsInfoField.id} $_idType,
    //     ${WaterBillsInfoField.customerId} $_boolType,
    //     ${WaterBillsInfoField.reading} $_integerType,
    //     ${WaterBillsInfoField.bill} $_textType,
    //     ${WaterBillsInfoField.dateCreated} $_textType,
    //     ${WaterBillsInfoField.dateUpdated} $_textTypeN
    //   )
    // ''');

    // _batch.execute('''
    //   CREATE TABLE $tableBills(
    //     ${BillField.id} $_idType,
    //     ${BillField.customerId} $_integerType,
    //     ${BillField.readingId} $_integerType,
    //     ${BillField.type} $_textType,
    //     ${BillField.currentReading} $_textTypeN,
    //     ${BillField.previousReading} $_textTypeN,
    //     ${BillField.consumeCM} $_integerType,
    //     ${BillField.billAmount} $_integerType,
    //     ${BillField.previousbalance} $_integerType,
    //     ${BillField.totalAmount} $_integerType,
    //     ${BillField.createdAt} $_textType
    //   )
    // ''');

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

  Future<List<Map<String, Object?>>> getCustomerList(
      {required BillType billType}) async {
    final _db = await instance.database;
    const _orderBy = '${CustomerField.fullName} ASC';
    return await _db.query(tableCustomers,
        where: '${CustomerField.billType} = ?',
        whereArgs: [billType.name],
        orderBy: _orderBy);
  }

  Future<int> addCustomer({required Customer customer}) async {
    final _db = await instance.database;
    return await _db.insert(tableCustomers, customer.toJson());
  }

  Future<int> addWaterBillInfo({required WaterBillInfo waterBillInfo}) async {
    final _db = await instance.database;
    return await _db.insert(tableWaterBillsInfo, waterBillInfo.toJson());
  }

  Future<void> updateWaterBillInfo(
      {required WaterBillInfo waterBillInfo}) async {
    final _db = await instance.database;
    await _db.update(
      tableWaterBillsInfo,
      waterBillInfo.toJson(),
      where: '${WaterBillsInfoField.id} == ? ',
      whereArgs: [waterBillInfo.id],
    );
  }

  Future<List<Map<String, Object?>>> getListOfWaterBillInfo(
      {required Customer customer}) async {
    final _db = await instance.database;
    return await _db.query(
      tableWaterBillsInfo,
      where: '${WaterBillsInfoField.customerId} ==  ?',
      whereArgs: [customer.id],
    );
  }

  Future<int> createWaterBill({required WaterBill waterBill, required}) async {
    final _db = await instance.database;
    return await _db.insert(tableWaterBills, waterBill.toJson());
  }

  // Future<List<Map<String, Object?>>> fetchWaterBill(
  //     {required int waterBillId}) async {
  //   final _db = await instance.database;
    // return await _db.query(tableWaterBills,
    //     where: '${FieldWaterBills.id} == ?', whereArgs: [waterBillId]);
  // }

////////////////////////////////////////////////////////////////////////////////////
  

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
        // int newTopay = customer.toPay - _payment.amount;
        // await txn.update(tableCustomers, {CustomerField.toPay: newTopay},
        //     where: '${CustomerField.id} = ?', whereArgs: [customer.id]);
      });
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
