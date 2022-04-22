import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:germanenapp/network/Database.dart';
import 'package:germanenapp/screens/protocol_list.dart';
import 'package:url_launcher/url_launcher.dart';

class UserList extends StatelessWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Database.readBeers(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          } else if (snapshot.hasData) {
            debugPrint("snapshotdata ${snapshot}");
            return ListView.separated(
              reverse: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                Map<String, dynamic> data =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                var beers = data['beers'];
                var sum = 0;
                for (var entry in beers) {
                  if (entry['amount'] != null) {
                    sum += entry['amount'] as int;
                  }
                }
                String userId = snapshot.data!.docs[index].id;
                return _BeerListEntry(
                  userId: userId,
                  beers: sum,
                );
              },
              separatorBuilder: (context, index) => Divider(
                color: Color(0xFFF1F1F1),
                height: 20,
                thickness: 1,
              ),
              itemCount: snapshot.data!.docs.length,
            );
          }
          return Center(child: Text("Keine Daten"));
        });
  }
}

class _BeerListEntry extends StatelessWidget {
  final String userId;
  final int beers;

  _BeerListEntry({
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
          Padding(
            padding: const EdgeInsets.all(0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 70,
                  child: Text(
                    userId,
                    style: TextStyle(
                      fontSize: 14,
                      //color: Color(0x80121212),
                    ),
                  ),
                ),
                Text(
                  beers.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    //color: Color(0x80121212),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.receipt_long,
                        color: Theme.of(context).primaryColor,
                        size: 24.0,

                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProtocolListPage(userId: userId,),
                          ),
                        );
                      },
                    ),

                    VerticalDivider(
                      color: Colors.black,
                      //color of divider
                      width: 10,
                      //width space of divider
                      thickness: 0,
                      //thickness of divier line
                      indent: 10,
                      //Spacing at the top of divider.
                      endIndent: 10, //Spacing at the bottom of divider.
                    ),

                    //pay

                    //other user
                    userId != database.getDisplayName()
                        ? IconButton(
                            icon: Icon(
                              Icons.euro_rounded,
                              color:
                                  Colors.grey, //Theme.of(context).primaryColor,
                              size: 24.0,
                            ),
                            onPressed: () {},
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.euro_rounded,
                              color: Theme.of(context).primaryColor,
                              size: 24.0,
                            ),
                            onPressed: () {
                              openPaymentDialog(context: context);
                            },
                          ),

                    VerticalDivider(
                      color: Colors.black,
                      //color of divider
                      width: 10,
                      //width space of divider
                      thickness: 0,
                      //thickness of divier line
                      indent: 10,
                      //Spacing at the top of divider.
                      endIndent: 10, //Spacing at the bottom of divider.
                    ),
                    //beer
                    userId != database.getDisplayName()
                        ? IconButton(
                            onPressed: (){},
                            icon: Icon(
                              Icons.sports_bar,
                              color: Colors.grey, //Theme.of(context).primaryColor,
                              size: 24.0,
                            ),
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.sports_bar,
                              color: Theme.of(context).primaryColor,
                              size: 24.0,
                            ),
                            onPressed: () {
                              openAddBeerDialog(context: context);
                            },
                          ),
                  ],
                ),
              ],
            ),
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
                        debugPrint('beer $value');
                        database.submitBeerAmount(value);
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

  Future openPaymentDialog({required BuildContext context}) => showDialog(
        useRootNavigator: false,
        context: context,
        builder: (BuildContext dialogContext) => AlertDialog(
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
                          child: Text("https://www.paypal.me/philirobsow",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                              )),
                          onTap: () async {
                            const url = 'https://www.paypal.me/philirobsow';
                            if (await canLaunch(url)) launch(url);
                          },
                        ),
                      ),
                      IconButton(
                          icon: const Icon(Icons.content_copy),
                          onPressed: () {
                            _copyToClipboard(
                                text: 'https://www.paypal.me/philirobsow',
                                context: dialogContext);
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
                                context: dialogContext);
                          }),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Bar',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFDEDEDE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Direkt an den Bierwart.',
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
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
                          database.payBeers();
                          Navigator.of(context).pop();
                        }),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Future<void> _copyToClipboard(
      {required String text, required BuildContext context}) async {
    await Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Kopiert'),
    ));
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
