import 'package:flutter/material.dart';

class AppToolbar extends StatelessWidget {

  final String sectionName;

  const AppToolbar({
    Key? key,
    required this.sectionName,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
        padding: const EdgeInsets.symmetric(
          vertical: 15
        ),
        alignment: FractionalOffset.center,
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Image.asset('assets/zirkel.png', height: 50,),
        ],
      )
    );


  }



  @override
  Size get preferredSize => Size.fromHeight(56.0);
}
