import 'package:flutter/material.dart';
import 'package:germanenapp/network/Database.dart';
import 'package:germanenapp/screens/users/protocol_page.dart';

class CouleurListEntry extends StatelessWidget {
  final String userId;
  final int beers;

  CouleurListEntry({
    required this.userId,
    required this.beers,
  });

  final Database database = Database();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: SizedBox(
                  width: 60,
                  child: Text(
                    userId,
                    style: TextStyle(
                      color: Colors.red[900],
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      //color: Color(0x80121212),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.delete_rounded,
                      color: Theme.of(context).primaryColor,
                      size: 24.0,
                    ),
                    onPressed: () {
                      openPaymentDialog(context: context, beers: beers);
                    },
                  ),

                  VerticalDivider(
                    width: 10,
                  ),
                  //beer
                  IconButton(
                    icon: Icon(
                      Icons.sports_bar,
                      color: Theme.of(context).primaryColor,
                      size: 24.0,
                    ),
                    onPressed: () {
                      openAddBeerDialog(context: context);
                    },
                  ),
                  VerticalDivider(
                    width: 40,
                  ),
                  Text(
                    beers.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      //color: Color(0x80121212),
                    ),
                  ),

                  VerticalDivider(
                    width: 20,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.receipt_long,
                      color: Theme.of(context).primaryColor,
                      size: 24.0,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProtocolListPage(
                            userId: userId,
                          ),
                        ),
                      );
                    },
                  ),
                  VerticalDivider(
                    width: 10,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  Future openAddBeerDialog({required BuildContext context}) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.all(40),
          title: Text(
            'Wie viel Oetti hat Couleur getrunken?',
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
        ),
      );

  Future openPaymentDialog(
          {required BuildContext context, required int beers}) =>
      showDialog(
        useRootNavigator: false,
        context: context,
        builder: (BuildContext dialogContext) => AlertDialog(
          titlePadding: EdgeInsets.all(40),
          title: Text(
            'Möchtest du alle Couleurstriche zurücksetzen?',
            textAlign: TextAlign.center,
            //style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    color: Colors.red,
                    iconSize: 48,
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                IconButton(
                    color: Colors.green,
                    iconSize: 48,
                    icon: const Icon(
                      Icons.check_circle,
                    ),
                    onPressed: () {
                      //deletes from beers
                      database.payBeers(userId);
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          ),
        ),
      );


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
