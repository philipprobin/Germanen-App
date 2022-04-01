import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:germanenapp/network/Database.dart';

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
                itemCount: snapshot.data!.docs.length);
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
                    //beer
                    userId != database.getDisplayName()
                        ? ElevatedButton.icon(
                            onPressed: null,
                            icon: Icon(
                              Icons.sports_bar,
                              //color: Colors.white, //Theme.of(context).primaryColor,
                              size: 24.0,
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  return Colors.grey.shade300;
                                },
                              ),
                            ),
                            label: Text('Oetti'),
                          )
                        : ElevatedButton.icon(
                            icon: Icon(
                              Icons.sports_bar,
                              color: Colors
                                  .white, //Theme.of(context).primaryColor,
                              size: 24.0,
                            ),
                            label: Text('Oetti'),
                            onPressed: () {
                              openDialog(context: context);
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

                    userId != database.getDisplayName()
                        ? OutlinedButton.icon(
                            onPressed: null,
                            icon: Icon(
                              Icons.euro_rounded,
                              //color: Colors.white, //Theme.of(context).primaryColor,
                              size: 24.0,
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  return Colors.white;
                                },
                              ),
                            ),
                            label: Text('Zahlen'),
                          )
                        : OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: BorderSide(
                                    color: Theme.of(context).primaryColor)),
                            icon: Icon(
                              Icons.euro_rounded,
                              color: Theme.of(context).primaryColor,
                              size: 24.0,
                            ),
                            label: Text('Zahlen'),
                            onPressed: () {},
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

  Future openDialog({required BuildContext context}) => showDialog(
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
