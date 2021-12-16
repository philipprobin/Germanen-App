
import 'package:flutter/material.dart';
import 'package:germanenapp/sign_up_page.dart';
import 'package:germanenapp/widgets/Widgets.dart';
import 'package:germanenapp/widgets/submit_button.dart';
import 'package:provider/src/provider.dart';

import 'authentication_service.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Widgets widgets = Widgets();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Anmelden'),
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
                    const SizedBox(height: 15),

                    _TextField(
                      label: 'Email',
                      controller: emailController,
                    ),

                    const SizedBox(height: 15),
                    _TextField(
                      controller: passwordController,
                      label: "Passwort",
                    ),
                    SubmitButton(
                      onPressed: () {
                        context.read<AuthenticationService>().signIn(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );
                      },
                      text: 'Anmelden',
                      padding: 16,
                    ),

                  ],
                ),
              ),
              Container(
                height: 60,
                child: widgets.buildSignUn(context),
              )
            ],
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