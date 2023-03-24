import 'package:flutter/material.dart';
import 'package:germanenapp/network/Database.dart';
import 'package:germanenapp/screens/users/protocol_page.dart';
import 'package:germanenapp/screens/users/user_profile_page.dart';

class BeerListEntry extends StatelessWidget {
  final String userId;
  final int beers;

  BeerListEntry({
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
              InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserProfilePage(userId))),
                child: Container(
                  child: SizedBox(
                    width: 150,
                    child: Text(
                      userId,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.red[900],
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        //color: Color(0x80121212),
                      ),
                    ),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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

}
