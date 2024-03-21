import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../helper/value_formatter_helper.dart';
import '../../network/Database.dart';

import '../../widgets/custom_app_bar.dart';

class ProtocolListPage extends StatefulWidget {
  final String userId;

  const ProtocolListPage({Key? key, required this.userId}) : super(key: key);

  @override
  _ProtocolListPageState createState() => _ProtocolListPageState();
}

class _ProtocolListPageState extends State<ProtocolListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFFFF2DE),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.userId,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 18,
                    ),

                    //open beers
                    StreamBuilder(
                        stream: Database.readUserBeers(
                          widget.userId,
                        ),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasData) {
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            var totalBeers = data['totalBeers'];
                            return RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(text: 'Hat '),
                                  TextSpan(
                                      text: '${totalBeers}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(text: ' Oetti offen:'),
                                ],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              height: 20,
                              color: Colors.red,
                            );
                          }
                        }),

                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: StreamBuilder(
                          stream: Database.readUserBeers(widget.userId),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (!snapshot.hasData || !snapshot.data!.exists) {
                              return Container();
                            }
                            debugPrint(
                                "snapshotdataprotocol ${snapshot.data?.data()}");
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            var beers = data['beers'];
                            return ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: beers.length,
                              itemBuilder: (context, index) {
                                var beer = beers[index];
                                var longDate = beer['date'];
                                var amount = beer['amount'];
                                String date = ValueFormatterHelper.convertDateToString(longDate);
                                return Text('$amount Oetti vom $date');
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) => Divider(
                                color: Colors.grey[700],
                                height: 2,
                                thickness: 1,
                              ),
                            );
                          }),
                    ),

                    SizedBox(
                      height: 18,
                    ),

                    //paid total beers
                    StreamBuilder(
                        stream: Database.readUserBeers(
                          widget.userId,
                        ),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasData) {
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            var totalBeers = data['totalPaidBeers'];
                            return RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(text: 'Hat '),
                                  TextSpan(
                                      text: '${totalBeers}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(text: ' Oetti bezahlt:'),
                                ],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              height: 20,
                              color: Colors.red,
                            );
                          }
                        }),

                    //paid beers
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: StreamBuilder(
                          stream: Database.readUserBeers(widget.userId),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (!snapshot.hasData || !snapshot.data!.exists) {
                              return Container();
                            }
                            debugPrint(
                                "snapshotdataprotocol ${snapshot.data?.data()}");
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            var beers = data['paidBeers'];
                            return ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              reverse: true,
                              itemCount: beers.length,
                              itemBuilder: (context, index) {
                                var beer = beers[index];
                                if (beer['date'] != null &&
                                    beer['amount'] != null) {
                                  var longDate = beer['date'];
                                  var amount = beer['amount'];
                                  String date = ValueFormatterHelper.convertDateToString(longDate);
                                  return Text('$amount Oetti vom $date');
                                } else {
                                  var longDate = beer['onDate'];
                                  var amount = beer['totalAmountPaid'];
                                  String date = ValueFormatterHelper.convertDateToString(longDate);
                                  return Text('$amount Oetti am $date bezahlt');
                                }
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) => Divider(
                                color: Colors.grey[700],
                                height: 2,
                                thickness: 1,
                              ),
                            );
                          }),
                    ),
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

/*

                StreamBuilder(
                    stream: Database.readUserBeers(widget.userId),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {

                      if (snapshot.hasData && snapshot.data!.exists) {

                        debugPrint(
                            "snapshotdataprotocol ${snapshot.data?.data()}");
                        var beers = [];
                        return ListView.separated(
                          reverse: true,
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            //critical Error
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            debugPrint("protocoldata ${data}");
                            beers = data['beers'];
                            var longDate = beers[index]['date'];
                            String date = formatter.format(DateTime.parse(longDate)).toString();
                            return Text(
                                '${beers[index]['amount']} Oetti vom $date');
                          },
                          separatorBuilder: (context, index) => Divider(
                            color: Color(0xFFF1F1F1),
                            height: 20,
                            thickness: 1,
                          ),
                          itemCount: snapshot.data!['beers'].length,
                        );
                      }
                      return Center(child: Text("Keine Daten"));
                    })
 */
