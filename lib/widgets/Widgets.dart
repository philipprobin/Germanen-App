import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../sign_up_page.dart';

class Widgets {
  Widget buildSignUn(context) {
    return Row(
      children: <Widget>[
        const Text('Du hast noch keinen Account?'),
        TextButton(
          child: const Text(
            'Registrieren',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          onPressed: () {
            //signup screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpPage()),
            );
          },
        )
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}