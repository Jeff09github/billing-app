import 'package:flutter/material.dart';

class SingleTextForm extends StatefulWidget {
  final TextInputType keyboardInputType;
  final String label;
  final String? Function(String?) validation;
  final void Function(String) success;
  const SingleTextForm(
      {Key? key,
      required this.keyboardInputType,
      required this.label,
      required this.validation,
      required this.success})
      : super(key: key);

  @override
  State<SingleTextForm> createState() => _SingleTextFormState();
}

class _SingleTextFormState extends State<SingleTextForm> {
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
                keyboardType: widget.keyboardInputType,
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
                              widget.success(_textController.text);
                              _textController.clear();
                              Navigator.pop(context);
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
