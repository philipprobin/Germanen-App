
import 'package:flutter/material.dart';
import 'package:germanenapp/screens/sign_up_page.dart';
import 'package:germanenapp/widgets/Widgets.dart';
import 'package:germanenapp/widgets/submit_button.dart';
import 'package:provider/src/provider.dart';

import 'package:germanenapp/network/Database.dart';
import '../network/authentication_service.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Widgets widgets = Widgets();


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
                          "assets/Germanen-Wappen.jpg",
                          fit: BoxFit.contain,
                        )),
                    const SizedBox(height: 15),

                    _TextField(
                      label: 'Email',
                      controller: emailController,
                      icon: Icon(Icons.mail),
                      inputAction: TextInputAction.next,
                    ),

                    const SizedBox(height: 15),
                    _TextField(
                      controller: passwordController,
                      label: "Passwort",
                      icon: Icon(Icons.vpn_key),
                      inputAction: TextInputAction.done,
                    ),
                    SubmitButton(
                      onPressed: () async {
                        String? responds = await context.read<AuthenticationService>().signIn(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );
                        if(responds!= 'Signed in'){
                          Database.handleSignUpError('Anmeldung', responds!, context);
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
                                      builder: (context) =>
                                          SignUpPage()));
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
}
class _TextField extends StatelessWidget {

  final TextEditingController controller;
  final String label;
  final bool password;
  final Icon icon;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final TextInputAction inputAction;

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
        autofocus: false,
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon,
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