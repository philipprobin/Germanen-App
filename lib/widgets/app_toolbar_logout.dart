import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../network/authentication_service.dart';
import '../screens/register/login_page.dart';

class AppToolbarLogout extends StatelessWidget {
  final String sectionName;

  const AppToolbarLogout({
    Key? key,
    required this.sectionName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      alignment: FractionalOffset.center,
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/zirkel.png',
            height: 50,
          ),
          //if(ModalRoute.of(context)!.settings.name == "/home")
          IconButton(
            onPressed: () {
              // Sign out and navigate to LoginPage
              context.read<AuthenticationService>().signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            color: Colors.white,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
    );
  }

/*
  @override
  Size get preferredSize => Size.fromHeight(56.0);

 */
}
