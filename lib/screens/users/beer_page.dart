import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:germanenapp/screens/dialog/beer_dialog.dart';
import '../../network/Database.dart';

import '../../widgets/custom_app_bar.dart';
import '../dialog/payment_dialog.dart';
import 'beer_list_entry.dart';
import 'couleur_list_entry.dart';

class BeerListPage extends StatefulWidget {
  const BeerListPage({Key? key}) : super(key: key);

  @override
  _BeerListPageState createState() => _BeerListPageState();
}

class _BeerListPageState extends State<BeerListPage> {
  var userId = Database.getDisplayName();

  var userBeers = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 3,
                              blurRadius: 3,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StreamBuilder(
                                  stream: Database.readBeers(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: (MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      2) -
                                                  100),
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }
                                    if (snapshot.hasError) {
                                      return Text('Something went wrong');
                                    }

                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Text("Loading");
                                    } else if (snapshot.hasData) {
                                      debugPrint("snapshotdata ${snapshot}");
                                      return Column( // set to 0 to show the new widget, set to 1 to show the BeerListEntry widget
                                          children: [

                                            ListView.builder(
                                              reverse: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                Map<String, dynamic> data =
                                                snapshot.data!.docs[index].data()
                                                as Map<String, dynamic>;
                                                var beers = data['beers'];
                                                var image = "";
                                                try {
                                                  image = data["image"];
                                                } catch (e) {}
                                                var sum = 0;
                                                for (var entry in beers) {
                                                  if (entry['amount'] != null) {
                                                    sum += entry['amount'] as int;
                                                  }
                                                }
                                                var user =
                                                    snapshot.data!.docs[index].id;


                                                if (user == userId) {
                                                  debugPrint(
                                                      "My user id is $user and i drank $sum beers");
                                                  userBeers = sum;
                                                }
                                                if (user == "Couleur") {
                                                  return CouleurListEntry(userId: "Couleur", beers: sum);
                                                }
                                                else {
                                                  return BeerListEntry(
                                                    userId: user,
                                                    beers: sum,
                                                  );
                                                }
                                              },
                                              itemCount: snapshot.data!.docs.length,
                                            ),

                                        ]
                                      );
                                    }
                                    return Center(child: Text("Keine Daten"));
                                  }),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          openPaymentDialog(context: context, beers: userBeers);
                        },
                        child: Text(
                          'Zahlen',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: TextButton(
                        child: Text('Stricheln',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          openAddBeerDialog(context: context);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future openAddBeerDialog({required BuildContext context}) => showDialog(
      context: context,
      builder: (context) => BeerDialog(userId: userId!, context: context));

  Future openPaymentDialog(
          {required BuildContext context, required int beers}) =>
      showDialog(
          useRootNavigator: false,
          context: context,
          builder: (BuildContext dialogContext) =>
              PaymentDialog(beers: beers, context: dialogContext));
}


