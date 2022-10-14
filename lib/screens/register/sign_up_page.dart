import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:germanenapp/network/Database.dart';
import 'package:germanenapp/screens/register/create_profile_screen.dart';
import 'package:germanenapp/widgets/submit_button.dart';
import 'package:germanenapp/widgets/text_field_widget.dart';
import 'package:provider/src/provider.dart';

import '../../network/authentication_service.dart';

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
  final _confirmPasswordController = TextEditingController();

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
                    TextFieldWidget(
                      label: 'Vorname',
                      controller: _firstNameController,
                      icon: Icon(Icons.account_circle),
                      validator: _userIdValidator,
                      inputAction: TextInputAction.next,
                      isPasswordField: false,
                    ),
                    const SizedBox(height: 10),
                    TextFieldWidget(
                      label: 'Nachname',
                      controller: _secondNameController,
                      icon: Icon(Icons.account_circle),
                      validator: _userIdValidator,
                      inputAction: TextInputAction.next,
                      isPasswordField: false,
                    ),
                    const SizedBox(height: 10),
                    TextFieldWidget(
                      label: 'Email',
                      controller: _emailController,
                      icon: Icon(Icons.mail),
                      validator: _emailValidator,
                      inputAction: TextInputAction.next,
                      isPasswordField: false,
                    ),
                    const SizedBox(height: 10),
                    TextFieldWidget(
                      label: 'Passwort',
                      controller: _passwordController,
                      icon: Icon(Icons.vpn_key),
                      validator: _passwordValidator,
                      isPasswordField: true,
                      inputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 10),
                    TextFieldWidget(
                      label: 'Bestätige Passwort',
                      controller: _confirmPasswordController,
                      icon: Icon(Icons.vpn_key),
                      validator: _confirmPasswordValidator,
                      isPasswordField: true,
                      inputAction: TextInputAction.done,
                    ),
                    if (loading) ...[
                      const Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                          child: CircularProgressIndicator(),
                      ),
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

  String? _emailValidator(String? text) {
    if (text == null || text.trim().isEmpty) {
      return 'Bitte gib deine Email ein.';
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

  String? _passwordValidator(String? confirmPasswordText) {
    if (confirmPasswordText == null || confirmPasswordText.trim().isEmpty) {
      return 'Bitte gib dein Passwort ein.';
    }
    return null;
  }


  String? _confirmPasswordValidator(String? confirmPasswordText) {
    if (confirmPasswordText == null || confirmPasswordText.trim().isEmpty) {
      return 'Bitte gib dein Passwort ein.';
    }
    if (_passwordController.text != confirmPasswordText) {
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
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CreateProfileScreen(null, FirebaseAuth.instance.currentUser!.displayName!)));
      //Navigator.of(context).pop();
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
