import 'package:flutter/material.dart';

class SingleForm extends StatefulWidget {
  final TextInputType textInputType;
  final String label;
  final String? Function(String?) validation;
  final Future<bool> Function(String) success;
  const SingleForm(
      {Key? key,
      required this.textInputType,
      required this.label,
      required this.validation,
      required this.success})
      : super(key: key);

  @override
  State<SingleForm> createState() => _SingleFormState();
}

class _SingleFormState extends State<SingleForm> {
  final TextEditingController _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

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
                keyboardType: widget.textInputType,
                decoration: InputDecoration(labelText: widget.label),
                controller: _textController,
                validator: widget.validation,
                enabled: _isLoading ? false : true,
              ),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final _result = _formKey.currentState?.validate();
                            if (_result == true) {
                              setState(() {
                                _isLoading = true;
                              });
                              await Future.delayed(
                                  const Duration(milliseconds: 1000));
                              final result =
                                  await widget.success(_textController.text);

                              if (result) {
                                _textController.clear();
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
                            _textController.clear();
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
