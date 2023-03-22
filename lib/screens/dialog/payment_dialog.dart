import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../network/Database.dart';

class PaymentDialog extends StatelessWidget {
  final int beers;

  PaymentDialog({required this.beers, required BuildContext context});

  final Database database = Database();


  @override
  Widget build(BuildContext context) {


    return AlertDialog(
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.all(40),
          title: Text(
            'Wie möchtest dein Bier bezahlen?',
            textAlign: TextAlign.center,
            //style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "${beers / 2}0€",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  'Paypal',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFDEDEDE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        child: GestureDetector(
                          child: Text("https://www.paypal.me/germania1877",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                              )),
                          onTap: () async {
                            const url = 'https://www.paypal.me/germania1877';
                            if (await canLaunch(url)) launch(url);
                          },
                        ),
                      ),
                      IconButton(
                          icon: const Icon(Icons.content_copy),
                          onPressed: () {
                            _copyToClipboard(
                                text: 'https://www.paypal.me/philirobsow',
                                context: context);
                          }),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Banküberweisung',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFDEDEDE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          'DE90 3706 0590 0000 0008 74',
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      IconButton(
                          icon: const Icon(Icons.content_copy),
                          onPressed: () {
                            _copyToClipboard(
                                text: 'DE90 3706 0590 0000 0008 74',
                                context: context);
                          }),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    'Du hast dein Bier bereits bezahlt?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
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
                          database.payBeers(Database.getDisplayName()!);
                          Navigator.of(context).pop();
                        }),
                  ],
                ),
              ],
            ),
          ),
        );
  }
  Future<void> _copyToClipboard(
      {required String text, required BuildContext context}) async {
    await Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Kopiert'),
    ));
  }
}
