

import 'package:flutter/material.dart';
import 'package:germanenapp/widgets/submit_button.dart';

class SignUpPage extends StatefulWidget{
  const SignUpPage({Key? key}) : super(key: key);

  @override
    _SignUpState createState()=> _SignUpState();
  }

class _SignUpState extends State<SignUpPage> {

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrieren'),
      ),
      body: SafeArea(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Flexible(
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    _TextField(label: 'Name', controller: _nameController,
                        validator: _requiredValidator),
                    const SizedBox(height: 15),

                    _TextField(label: 'Email', controller: _emailController,
                        validator: _requiredValidator),
                    const SizedBox(height: 15),

                    _TextField(label: 'Passwort', controller: _passwordController,
                        validator: _requiredValidator,
                        password:true),
                    const SizedBox(height: 10),

                    _TextField(label: 'Bestätige Passwort', controller: _confirmController,
                        validator: _confirmPasswordValidator,
                        password:true),
                    const SizedBox(height: 10),

                    SubmitButton(
                      onPressed: (){
                        if(_formKey.currentState!= null && _formKey.currentState!.validate()){

                        }
                      },
                      text: 'registrieren',
                      padding: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  String? _requiredValidator(String? text){
    if(text==null|| text.trim().isEmpty){
      return 'Bitte gib einen Benutzernamen ein.';
    }
    return null;
  }
  String? _confirmPasswordValidator(String? confirmPasswordText){
    if(confirmPasswordText==null|| confirmPasswordText.trim().isEmpty){
      return 'Bitte gib einen Benutzernamen ein.';
    }
    if(_passwordController.text != confirmPasswordText) {
      return 'Passwörter stimmen nicht überein';
    }
    return null;
  }
}
class _TextField extends StatelessWidget {

  final TextEditingController controller;
  final String label;
  final bool password;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;

  const _TextField({
    required this.label,
    required this.controller,
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
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        obscureText: password,
        validator: validator,
      ),
    );
  }
}