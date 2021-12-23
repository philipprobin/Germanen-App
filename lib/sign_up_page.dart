

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  var loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrieren'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
                  children: [
                    const SizedBox(height: 10),

                    _TextField(label: 'Name', controller: _nameController,
                        validator: _requiredNameValidator),
                    const SizedBox(height: 10),

                    _TextField(label: 'Email', controller: _emailController,
                        validator: _requiredEmailValidator),
                    const SizedBox(height: 10),

                    _TextField(label: 'Passwort', controller: _passwordController,
                        validator: _requiredPasswordValidator,
                        password:true),
                    const SizedBox(height: 10),

                    _TextField(label: 'Bestätige Passwort', controller: _confirmController,
                        validator: _confirmPasswordValidator,
                        password:true),
                    const SizedBox(height: 10),

                    if(loading)...[
                      const Center(child: CircularProgressIndicator()),
                    ],
                    if(!loading)...[
                      SubmitButton(
                        onPressed: (){
                          if(_formKey.currentState!= null && _formKey.currentState!.validate()){
                            _signUp();
                          }
                        },
                        text: 'Registrieren',
                        padding: 16,
                      ),
                    ],
                  ],
                ),
              ),
          ),
    );
  }
  void _showToast(BuildContext context, String? message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message!),
      ),
    );
  }

  String? _requiredNameValidator(String? text){
    if(text==null|| text.trim().isEmpty){
      return 'Bitte gib einen Benutzernamen ein.';
    }
    return null;
  }
  String? _requiredEmailValidator(String? text){
    if(text==null|| text.trim().isEmpty){
      return 'Bitte gib eine Email ein.';
    }
    return null;
  }

  String? _requiredPasswordValidator(String? text){
    if(text==null|| text.trim().isEmpty){
      return 'Bitte gib ein Passwort ein.';
    }
    return null;
  }

  String? _confirmPasswordValidator(String? confirmPasswordText){
    if(confirmPasswordText==null|| confirmPasswordText.trim().isEmpty){
      return 'Bitte bestätige dein Passwort.';
    }
    if(_passwordController.text != confirmPasswordText) {
      return 'Passwörter stimmen nicht überein';
    }
    return null;
  }

  Future _signUp() async {
    debugPrint('signUp print');
    setState(() { loading = true; });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      await FirebaseFirestore.instance.collection('users').add({
        'email': _emailController.text,
        'name': _nameController.text,
      });

      _showToast(context, 'Registrierung erfolgreich!');
      Navigator.of(context).pop();

    } on FirebaseAuthException catch (e) {
      _handleSignUpError(e);
      setState(() { loading = false; });
    }
  }

  void _handleSignUpError(FirebaseAuthException e) {
    String messageToDisplay ="";
    switch (e.code) {
      case 'email-already-in-use':
        messageToDisplay = 'Die E-Mail wird schon verwendet';
        break;
      case 'invalid-email':
        messageToDisplay = 'Die E-Mail ist ungültig';
        break;
      case 'operation-not-allowed':
        messageToDisplay = 'Diese Operation ist nicht erlaubt';
        break;
      case 'weak-password':
        messageToDisplay = 'Das Passwort ist zu schwach';
        break;
      default:
        messageToDisplay = 'Unbekannter Fehler';
        break;
    }
    _showToast(context, messageToDisplay);
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