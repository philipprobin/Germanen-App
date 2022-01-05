

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:germanenapp/widgets/submit_button.dart';
import 'package:provider/src/provider.dart';

import 'authentication_service.dart';

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
              padding: const EdgeInsets.all(18.0),
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

                    _TextField(label: 'Name', controller: _nameController,
                        icon: Icon(Icons.account_circle),
                        validator: _requiredValidator),
                    const SizedBox(height: 10),

                    _TextField(label: 'Email', controller: _emailController,
                        icon: Icon(Icons.mail),
                        validator: _requiredValidator),
                    const SizedBox(height: 10),

                    _TextField(label: 'Passwort', controller: _passwordController,
                        icon: Icon(Icons.vpn_key),
                        validator: _requiredValidator,
                        password:true),
                    const SizedBox(height: 10),

                    _TextField(label: 'Bestätige Passwort',
                        controller: _confirmController,
                        icon: Icon(Icons.vpn_key),
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

  Future _signUp() async {
    ///loading starts after submitting
    ///user account gets created
    ///user gets signed in
    ///user profile gets updated
    ///if it fails -> error message gets displayed
    setState(() { loading = true; });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      //update user profile
      await FirebaseAuth.instance.currentUser.updateProfile(
          displayName: _nameController.text
      );
      await FirebaseFirestore.instance.collection('users').add({
        'email': _emailController.text,
        'name': _nameController.text,
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
      _handleSignUpError(e);
      setState(() { loading = false; });
    }
  }

  void _handleSignUpError(FirebaseAuthException e) {
    String messageToDisplay;
    switch (e.code) {
      case 'email-already-in-use':
        messageToDisplay = 'Diese E-Mail wird schon verwendet';
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
    showDialog(context: context, builder: (BuildContext context) => AlertDialog(
      title: Text('Anmelden fehlgeschlagen'),
      content: Text(messageToDisplay),
      actions: [TextButton(onPressed: () {
        Navigator.of(context).pop();

      }, child: Text('Ok'))],
    ));
  }




}

class _TextField extends StatelessWidget {

  final TextEditingController controller;
  final String label;
  final bool password;
  final Icon icon;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;

  const _TextField({
    required this.label,
    required this.controller,
    required this.icon,
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
      ),
    );
  }
}