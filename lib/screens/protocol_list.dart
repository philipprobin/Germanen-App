import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import '../network/Database.dart';
import '../widgets/app_toolbar.dart';

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
      appBar: AppBar(
          elevation: 0,
          title: AppToolbar(
            sectionName: 'Germanen App',
          )),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Text(
                  widget.userId,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 18,
                ),

              ],
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
