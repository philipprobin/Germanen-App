import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:germanenapp/screens/register/login_page.dart';

import '../../network/Database.dart';
import '../../widgets/submit_button.dart';

class PasswordPage extends StatefulWidget {
  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  final _storage = FlutterSecureStorage();
  String _firebaseString = '';

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    String? passwordValidated = await _storage.read(key: 'passwordValidated');
    debugPrint("validated = $passwordValidated");
    if (passwordValidated == "true") {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  Future<void> _correctPassword() async {
    await _storage.write(key: 'passwordValidated', value: 'true');
    _checkFirstTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gib das Germanen Passwort ein.'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
          future: Database.readPassword(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.active:
                return Center(
                  child: Text("Connection active"),
                );
              case ConnectionState.none:
                return Center(
                  child: Text("Connection none"),
                );
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Text(
                      "snapshot has error ${snapshot.error}\n\n ${snapshot.stackTrace}");
                }
                if (snapshot.hasData) {
                  Map<String, dynamic>? data =
                      snapshot.data?.data() as Map<String, dynamic>?;
                  _firebaseString = data!["pw"];

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                            ),
                            validator: _passwordValidator,
                          ),
                          SubmitButton(
                            onPressed: () async {
                              if (_formKey.currentState != null &&
                                  _formKey.currentState!.validate()) {
                                if (!await Database.isInternetConnected()) {
                                  Fluttertoast.showToast(
                                      msg: "Keine Internet Verbindung");
                                } else {
                                  if (_passwordController.text.trim() ==
                                      _firebaseString) {
                                    _correctPassword();
                                  }
                                  else{
                                    Fluttertoast.showToast(
                                        msg: "Falsches Passwort");
                                  }
                                }
                              }
                            },
                            text: 'Anmelden',
                            padding: 16,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Text("no Data");
            }
          }),
    );
  }

  String? _passwordValidator(String? confirmPasswordText) {
    if (confirmPasswordText == null || confirmPasswordText.trim().isEmpty) {
      return 'Bitte gib dein Passwort ein.';
    }
    return null;
  }
}
