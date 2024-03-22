import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isPasswordField;
  final Icon icon;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final TextInputAction inputAction;

  const TextFieldWidget({
    Key? key,
    required this.label,
    required this.controller,
    required this.icon,
    required this.inputAction,
    this.validator,
    required this.isPasswordField,
    this.keyboardType,
  }) : super(key: key);

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {

  bool _obscureText = true;
  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: TextFormField(
        autofocus: false,
        textCapitalization: widget.isPasswordField ? TextCapitalization.sentences : TextCapitalization.none,
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.label,
          prefixIcon: widget.icon,
          border: const OutlineInputBorder(),
          suffixIcon: widget.isPasswordField
              ? IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: _obscureText
                        ? Colors.grey
                        : Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    _toggle();
                  },
                )
              : null,
        ),
        keyboardType: widget.keyboardType,
        obscureText: widget.isPasswordField ? _obscureText : false,
        validator: widget.validator,
        textInputAction: widget.inputAction,
      ),
    );
  }
}
