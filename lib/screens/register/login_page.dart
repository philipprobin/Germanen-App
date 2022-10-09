import 'package:flutter/material.dart';
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
                          "assets/Germanen-Wappen.jpg",
                          fit: BoxFit.contain,
                        )),
                    const SizedBox(height: 15),
                    TextFieldWidget(
                      label: 'Email',
                      controller: emailController,
                      icon: Icon(Icons.mail),
                      inputAction: TextInputAction.next,
                      isPasswordField: false,
                    ),
                    const SizedBox(height: 15),
                    TextFieldWidget(
                      controller: passwordController,
                      isPasswordField: true,
                      label: "Passwort",
                      icon: Icon(Icons.vpn_key),
                      inputAction: TextInputAction.done,
                    ),
                    SubmitButton(
                      onPressed: () async {
                        String? responds =
                            await context.read<AuthenticationService>().signIn(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                );
                        if (responds != 'Signed in') {
                          Database.handleSignUpError(
                              'Anmeldung', responds!, context);
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
}


