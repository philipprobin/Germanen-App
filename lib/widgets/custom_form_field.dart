import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {

  final TextEditingController controller;
  final bool password;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;

  const CustomFormField({
    required this.controller,
    required this.textInputAction,
    required this.focusNode,
    this.validator,
    this.password = false,
    this.keyboardType,


  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        obscureText: password,
        validator: validator,
        textInputAction: textInputAction,
        focusNode: focusNode,
      ),
    );
  }
}
