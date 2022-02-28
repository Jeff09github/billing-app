import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maaa/presentation/resources/enum.dart';

import '../../resources/color_manager.dart';

class CustomersWaterBillsView extends StatefulWidget {
  const CustomersWaterBillsView({Key? key}) : super(key: key);

  @override
  _CustomersWaterBillsViewState createState() =>
      _CustomersWaterBillsViewState();
}

class _CustomersWaterBillsViewState extends State<CustomersWaterBillsView> {
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _cm = TextEditingController();
  final StreamController<bool?> _fullNameIsValid = StreamController.broadcast();
  final StreamController<bool?> _cmIsValid = StreamController.broadcast();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _fullNameIsValid.close();
    _cmIsValid.close();
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
            onSelected: _onChoiceSelected,
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

  void _onChoiceSelected(Choose choose) {
    showModalBottomSheet<void>(
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      clipBehavior: Clip.hardEdge,
      builder: (BuildContext context) {
        switch (choose) {
          case Choose.addCustomer:
            return _getAddCustomerWidget();
          case Choose.createNewBill:
            return Container();
        }
      },
    );
  }

  Widget _getAddCustomerWidget() {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StreamBuilder<bool?>(
                  stream: _fullNameIsValid.stream,
                  builder: (context, snapshot) {
                    return TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        errorText: (snapshot.data ?? true) ? null : 'error',
                      ),
                      controller: _fullName,
                      onChanged: (newValue) {
                        isFullNameValid(newValue);
                      },
                    );
                  }),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Current CM'),
                controller: _cm,
                onChanged: (newValue) {
                  isCMValid(newValue);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('ADD'),
                  ),
                  const SizedBox(
                    width: 12.0,
                  ),
                  OutlinedButton(
                    onPressed: () {
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

  void isFullNameValid(String value) {
    if (value.isEmpty) {
      _fullNameIsValid.add(false);
    } else {
      _fullNameIsValid.add(true);
    }
  }

  void isCMValid(String value) {
    if (value.isEmpty) {
      _fullNameIsValid.add(false);
    } else {
      _fullNameIsValid.add(true);
    }
  }
}
