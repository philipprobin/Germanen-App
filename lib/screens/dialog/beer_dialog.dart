import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../network/Database.dart';

class BeerDialog extends StatelessWidget {
  final String userId;

  BeerDialog({required this.userId, required BuildContext context});

  final Database database = Database();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {


    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.all(40),
      title: Text(
        'Wie viel Oetti hast du getrunken?',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/beer_background.png',
            fit: BoxFit.cover,
          ),
          Container(
            width: 70,
            child: Form(
              key: _formKey,
              child: TextFormField(
                textAlign: TextAlign.center,
                validator: _confirmBeerAmount,
                autofocus: true,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  //hintText: '0',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      width: 4,
                      color: Colors.white,
                    ),
                  ),
                ),
                onFieldSubmitted: (value) {
                  if (_formKey.currentState != null &&
                      _formKey.currentState!.validate()) {
                    debugPrint('users $value');
                    database.submitBeerAmount(value, userId);
                    Database.updateTotalBeerAmount(userId, 'beers');
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
  String? _confirmBeerAmount(String? number) {
    try {
      var test = int.parse(number!);
      if (test < 1) {
        return 'Phritte';
      }
    } catch (e) {
      debugPrint('${e}');
      return 'Zahl!';
    }
    return null;
  }
}
