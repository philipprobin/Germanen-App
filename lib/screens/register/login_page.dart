import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:germanenapp/screens/home_page.dart';
import 'package:germanenapp/screens/register/sign_up_page.dart';
import 'package:germanenapp/widgets/submit_button.dart';
import 'package:germanenapp/widgets/text_field_widget.dart';
import 'package:provider/src/provider.dart';

import 'package:germanenapp/network/Database.dart';
import '../../network/authentication_service.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                        height: 300,
                        child: Image.asset(
                          "assets/germanen_wappen.jpg",
                          fit: BoxFit.contain,
                        )),
                    const SizedBox(height: 15),
                    TextFieldWidget(
                      label: 'Email',
                      controller: emailController,
                      validator: _emailValidator,
                      icon: Icon(Icons.mail),
                      inputAction: TextInputAction.next,
                      isPasswordField: false,
                    ),
                    const SizedBox(height: 15),
                    TextFieldWidget(
                      controller: passwordController,
                      validator: _passwordValidator,
                      isPasswordField: true,
                      label: "Passwort",
                      icon: Icon(Icons.vpn_key),
                      inputAction: TextInputAction.done,
                    ),
                    SubmitButton(
                      onPressed: () async {
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) {
                          String? responds = await context
                              .read<AuthenticationService>()
                              .signIn(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );
                          debugPrint("nach signIn() $responds");
                          if (!await Database.isInternetConnected()) {
                            Fluttertoast.showToast(
                                msg: "Keine Internet Verbindung");
                          } else if(responds == "Signed in"){
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => HomePage()),
                            );

                          }
                            else if (responds == 'Email nicht vorhanden') {
                            debugPrint("email toast");
                            Fluttertoast.showToast(msg: responds);
                          } else if (responds ==
                              'Falsches Passwort zu dieser Email') {
                            Fluttertoast.showToast(msg: responds);
                          } else {
                            CircularProgressIndicator();
                          }
                        }
                      },
                      text: 'Anmelden',
                      padding: 16,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Du hast noch keinen Account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpPage()));
                            },
                            child: Text(
                              "Registrieren",
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          )
                        ])
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
    return null;
  }

  String? _passwordValidator(String? confirmPasswordText) {
    if (confirmPasswordText == null || confirmPasswordText.trim().isEmpty) {
      return 'Bitte gib dein Passwort ein.';
    }
    return null;
  }
}
