import 'package:flutter/material.dart';
import 'package:maaa/presentation/water_bills/customers_waterbills/customers_waterbills.dart';

import '../../../model/customer/customer.dart';
import '../../../model/reading/reading.dart';
import '../../../resources/maaa_database.dart';
import '../../resources/enum.dart';

class BottomSheetWidget extends StatefulWidget {
  // const BottomSheetWidget({Key? key}) : super(key: key);
  final FormType formType;
  final Customer? customer;
  final VoidCallback setState;

  const BottomSheetWidget({
    Key? key,
    required this.formType,
    this.customer,
    required this.setState,
  }) : super(key: key);

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  final _formKey = GlobalKey<FormState>();
  final _db = MaaaDatabase.instance;
  bool _isLoading = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _readingController = TextEditingController();

  Future<Customer?> addCustomer({required String name}) async {
    Customer? _customer;
    await Future.delayed(const Duration(milliseconds: 1000));
    _customer = await _db.addCustomer(fullName: name);

    return _customer;
  }

  Future<Reading?> addReading(
      {required String reading, required int customerId}) async {
    Reading? _reading;

    await Future.delayed(const Duration(milliseconds: 1000));
    _reading = await _db.addReading(
      reading: reading,
      billType: BillType.water,
      customerId: customerId,
    );

    return _reading;
  }

  String? isTextValid(String? value) {
    return (value != null && value.isNotEmpty) ? null : 'Input your full name';
  }

  String? isCMValid(String? value) {
    return (value != null && value.length == 4)
        ? null
        : 'Input a correct reading with 4 characters. ';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                keyboardType: widget.formType == FormType.addCustomer
                    ? TextInputType.name
                    : TextInputType.number,
                decoration: InputDecoration(
                    labelText: widget.formType == FormType.addCustomer
                        ? 'Full Name'
                        : 'New Reading'),
                controller: widget.formType == FormType.addCustomer
                    ? _nameController
                    : _readingController,
                validator: widget.formType == FormType.addCustomer
                    ? isTextValid
                    : isCMValid,
                enabled: _isLoading ? false : true,
              ),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final result = _formKey.currentState?.validate();
                            if (result! &&
                                widget.formType == FormType.addCustomer) {
                              setState(() {
                                _isLoading = true;
                              });
                              await Future.delayed(
                                  const Duration(milliseconds: 1000));
                              final result =
                                  await addCustomer(name: _nameController.text);
                              if (result != null) {
                                _nameController.clear();
                                widget.setState();
                                Navigator.pop(context);
                              } else {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            } else {
                              setState(() {
                                _isLoading = true;
                              });
                              await Future.delayed(
                                  const Duration(milliseconds: 1000));

                              final result = await addReading(
                                  reading: _readingController.text,
                                  customerId: widget.customer!.id!);
                              if (result != null) {
                                _nameController.clear();
                                widget.setState();
                                Navigator.pop(context);
                              } else {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            }
                          },
                          child: const Text('ADD'),
                        ),
                        const SizedBox(
                          width: 12.0,
                        ),
                        OutlinedButton(
                          onPressed: () {
                            widget.formType == FormType.addCustomer
                                ? _nameController.clear()
                                : _readingController.clear();
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        )
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
