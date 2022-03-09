import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maaa/presentation/resources/enum.dart';
import 'package:maaa/resources/maaa_database.dart';
import 'package:sqflite/sqflite.dart';

import '../../../model/customer/customer.dart';
import '../../../model/reading/reading.dart';
import '../../resources/color_manager.dart';

enum FormType { addCustomer, addReading }

class CustomersWaterBillsView extends StatefulWidget {
  const CustomersWaterBillsView({Key? key}) : super(key: key);

  @override
  _CustomersWaterBillsViewState createState() =>
      _CustomersWaterBillsViewState();
}

class _CustomersWaterBillsViewState extends State<CustomersWaterBillsView> {
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _cm = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late MaaaDatabase _instance;
  // late List<Customer> _customers;

  @override
  void initState() {
    super.initState();
  }

  Future<Database?> loadDatabase() async {
    _instance = MaaaDatabase.instance;
    await Future.delayed(const Duration(milliseconds: 1000));
    return await _instance.database;
  }

  @override
  void dispose() {
    _fullName.dispose();
    _cm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
              size: 35.0,
            ),
            onSelected: (Choose value) =>
                _onChoiceSelected(choose: value, context: context),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Choose>>[
              _buildPopupMenuItem(
                text: "Add Customer",
                value: Choose.addCustomer,
              ),
              _buildPopupMenuItem(
                text: "Create New Bill",
                value: Choose.createNewBill,
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<Database?>(
        future: loadDatabase(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Colors.white,
                ))
              //check database
              : !snapshot.hasData
                  ? Container()
                  : FutureBuilder<List<Customer>?>(
                      future: getAllCustomer(),
                      builder: (context, snapshot) {
                        return snapshot.connectionState ==
                                ConnectionState.waiting
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : (snapshot.data != null &&
                                    snapshot.data!.isNotEmpty)
                                ? DataTable(
                                    columns: const <DataColumn>[
                                      DataColumn(
                                        label: Text('Customer'),
                                      ),
                                      DataColumn(
                                        label: Text('New Reading'),
                                      )
                                    ],
                                    rows: List<DataRow>.generate(
                                      snapshot.data!.length,
                                      (index) {
                                        return DataRow(
                                          cells: <DataCell>[
                                            DataCell(
                                              Text(snapshot
                                                  .data![index].fullName),
                                            ),
                                            DataCell(
                                              const Icon(
                                                  Icons.add_circle_outline),
                                              onTap: () {
                                                _onChoiceSelected(
                                                    choose: Choose.addReading,
                                                    context: context,
                                                    customer:
                                                        snapshot.data![index]);
                                              },
                                            )
                                          ],
                                        );
                                      },
                                    ),
                                  )
                                : const Text('No customer data.');
                      },
                    );
        },
      ),
    );
  }

  PopupMenuItem<Choose> _buildPopupMenuItem({
    required String text,
    required Choose value,
  }) {
    return PopupMenuItem(
      child: Text(text),
      value: value,
    );
  }

  void _onChoiceSelected(
      {required Choose choose,
      required BuildContext context,
      Customer? customer}) {
    showModalBottomSheet<void>(
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      clipBehavior: Clip.hardEdge,
      builder: (BuildContext context) {
        switch (choose) {
          case Choose.addCustomer:
            return _buildAddWidget(
              formType: FormType.addCustomer,
            );
          case Choose.addReading:
            return _buildAddWidget(
                formType: FormType.addReading, customer: customer);
          case Choose.createNewBill:
            return Container();
        }
      },
    );
  }

  Widget _buildAddWidget({required FormType formType, Customer? customer}) {
    switch (formType) {
      case FormType.addCustomer:
        return _buildAddForm(
          // context: context,
          inputType: TextInputType.name,
          label: 'Full Name',
          controller: _fullName,
          onAddTap: () async => await addCustomer(name: _fullName.text),
          onCancelTap: () {
            _fullName.clear();
            Navigator.pop(context);
          },
        );

      case FormType.addReading:
        return _buildAddForm(
          // context: context,
          inputType: TextInputType.number,
          label: 'Enter New ${customer?.fullName} Reading',
          controller: _cm,
          onAddTap: () async =>
              await addReading(reading: _cm.text, customerId: customer!.id!),
          onCancelTap: () {
            _cm.clear();
            Navigator.pop(context);
          },
        );
    }
  }

  Widget _buildAddForm({
    required TextInputType inputType,
    required String label,
    required TextEditingController controller,
    required VoidCallback onAddTap,
    required VoidCallback onCancelTap,
  }) {
    return Builder(builder: (context) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Form(
          key: _formKey,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  keyboardType: inputType,
                  decoration: InputDecoration(labelText: label),
                  controller: controller,
                  validator: isTextValid,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: onAddTap,
                      child: const Text('ADD'),
                    ),
                    const SizedBox(
                      width: 12.0,
                    ),
                    OutlinedButton(
                      onPressed: onCancelTap,
                      child: const Text('Cancel'),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  String? isTextValid(String? value) {
    return (value != null && value.isNotEmpty) ? null : 'Input your full name';
  }

  String? isCMValid(String? value) {
    return (value != null && value.length == 4)
        ? null
        : 'Input a correct reading with 4 characters. ';
  }

  Future<List<Customer>?> getAllCustomer() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return await _instance.getAllCustomer();
  }

  Future<Customer?> addCustomer({required String name}) async {
    final result = _formKey.currentState?.validate();
    Customer? _customer;
    if (result!) {
      await Future.delayed(const Duration(milliseconds: 1000));
      _customer = await _instance.addCustomer(fullName: name);
    }
    return _customer;
  }

  Future<Reading?> addReading(
      {required String reading, required int customerId}) async {
    final result = _formKey.currentState?.validate();
    Reading? _reading;
    if (result!) {
      await Future.delayed(const Duration(milliseconds: 1000));
      _reading = await _instance.addReading(
        reading: reading,
        billType: BillType.water,
        customerId: customerId,
      );
    }
    return _reading;
  }
}
