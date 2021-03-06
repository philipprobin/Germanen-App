import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:germanenapp/network/Database.dart';
import 'package:germanenapp/widgets/submit_button.dart';
import 'package:provider/src/provider.dart';

import '../authentication_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _secondNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  var loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () {
            // passing this to our root
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        height: 180,
                        child: Image.asset(
                          "assets/Germanen-Wappen.jpg",
                          fit: BoxFit.contain,
                        )),
                    const SizedBox(height: 10),
                    _TextField(
                      label: 'Vorname',
                      controller: _firstNameController,
                      icon: Icon(Icons.account_circle),
                      validator: _userIdValidator,
                      inputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 10),
                    _TextField(
                      label: 'Nachname',
                      controller: _secondNameController,
                      icon: Icon(Icons.account_circle),
                      validator: _userIdValidator,
                      inputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 10),
                    _TextField(
                      label: 'Email',
                      controller: _emailController,
                      icon: Icon(Icons.mail),
                      validator: _requiredValidator,
                      inputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 10),
                    _TextField(
                      label: 'Passwort',
                      controller: _passwordController,
                      icon: Icon(Icons.vpn_key),
                      validator: _requiredValidator,
                      password: true,
                      inputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 10),
                    _TextField(
                      label: 'Best??tige Passwort',
                      controller: _confirmController,
                      icon: Icon(Icons.vpn_key),
                      validator: _confirmPasswordValidator,
                      password: true,
                      inputAction: TextInputAction.done,
                    ),
                    if (loading) ...[
                      const Center(child: CircularProgressIndicator()),
                    ],
                    if (!loading) ...[
                      SubmitButton(
                        onPressed: () {
                          if (_formKey.currentState != null &&
                              _formKey.currentState!.validate()) {
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
          ),
        ),
      ),
    );
  }

  String? _requiredValidator(String? text) {
    if (text == null || text.trim().isEmpty) {
      return 'Bitte gib etwas ein.';
    }
    if (text == 'email-already-in-use') {
      return 'Email wird schon verwendet';
    }
    return null;
  }

  String? _userIdValidator(String? text) {
    debugPrint('docname if true');
    if (text == null || text.trim().isEmpty) {
      return 'Bitte gib einen Benutzernamen ein.';
    }

    bool checkDb = Database.checkUserIdExists(
        userId:
            '${_firstNameController.text.trim()} ${_secondNameController.text.trim()}');
    debugPrint('docname if $bool');
    if (checkDb) {
      debugPrint('docname if true');
      return 'Diese Kombination ist schon vergeben.';
    }
    return null;
  }

  String? _confirmPasswordValidator(String? confirmPasswordText) {
    if (confirmPasswordText == null || confirmPasswordText.trim().isEmpty) {
      return 'Bitte gib einen Benutzernamen ein.';
    }
    if (_passwordController.text != confirmPasswordText) {
      return 'Passw??rter stimmen nicht ??berein';
    }
    return null;
  }

  Future _signUp() async {
    ///loading starts after submitting
    ///user account gets created
    ///user gets signed in
    ///user profile gets updated
    ///if it fails -> error message gets displayed
    setState(() {
      loading = true;
    });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      //create beerList entry
      await FirebaseFirestore.instance
          .collection('beers')
          .doc(
              '${_firstNameController.text.trim()} ${_secondNameController.text.trim()}')
          .set({
        'beers': [],
        'paidBeers': [],
        'totalBeers': 0,
        'totalPaidBeers': 0,
      });
      //update user profile
      await FirebaseAuth.instance.currentUser!.updateDisplayName(
          '${_firstNameController.text.trim()} ${_secondNameController.text.trim()}');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(
              '${_firstNameController.text.trim()} ${_secondNameController.text.trim()}')
          .set({
        'email': _emailController.text,
      });
      //sign in
      context.read<AuthenticationService>().signIn(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      //fragment pops
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      log('createUserWithEmail exception log');
      debugPrint('createUserWithEmail exception debug');
      Database.handleSignUpError('Registrierung', e.code, context);
      setState(() {
        loading = false;
      });
    }
  }


}

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool password;
  final Icon icon;
  final TextInputType? keyboardType;
  final TextInputAction inputAction;
  final FormFieldValidator<String>? validator;

  const _TextField({
    required this.label,
    required this.controller,
    required this.icon,
    required this.inputAction,
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
          prefixIcon: icon,
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        obscureText: password,
        validator: validator,
        textInputAction: inputAction,
      ),
    );
  }
}
