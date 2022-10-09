import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:germanenapp/models/user_model.dart';
import 'package:germanenapp/network/Database.dart';
import 'package:germanenapp/screens/register/create_profile_screen.dart';
import 'package:germanenapp/screens/users/profile_picture_page.dart';

import '../../main.dart';
import '../../widgets/app_toolbar.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage(this.userId, {Key? key}) : super(key: key);
  final String userId;
  static TextStyle _textStyleKey = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 18,
      color: buildMaterialColor(Color(0xFF7D7D7D)));
  static TextStyle _textStyleValue = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 18,
      color: buildMaterialColor(Color(0xFF7D7D7D)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: AppToolbar(
            sectionName: 'Germanen-App',
          ),
        ),
        body: FutureBuilder<DocumentSnapshot>(
            future: Database.readUser(userId),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                  return Center(
                    child: Text("Connection active"),
                  );
                case ConnectionState.none:
                  return Center(
                    child: Text("Connection none"),
                  );
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text(
                        "snapshot has error ${snapshot.error}\n\n ${snapshot.stackTrace}");
                  }
                  if (snapshot.hasData) {
                    Map<String, dynamic>? data =
                        snapshot.data?.data() as Map<String, dynamic>?;
                    debugPrint("daten: ${data.runtimeType}");
                    UserModel userModel = new UserModel(
                        userId: userId,
                        hobbys: data!['hobbys'],
                        status: data['status'],
                        activeSince: data['activeSince'],
                        mayor: data['mayor'],
                        job: data['job'],
                        location: data['location'],
                        image: data['image']);
                    debugPrint("UserModel ${userModel.userId}");

                    return Scaffold(
                      floatingActionButton: userModel.userId ==
                              Database.getDisplayName()
                          ? FloatingActionButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => CreateProfileScreen(
                                        userModel, userModel.userId),
                                  ),
                                );
                              },
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 32,
                              ),
                            )
                          : null,
                      backgroundColor: Colors.white,
                      body: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 16.0,
                                        ),
                                        child: Container(
                                          child: Stack(
                                              alignment: Alignment.bottomRight,
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black12,
                                                    border: Border.all(
                                                      color: Colors.black38,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(16),
                                                    ),
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return ProfilePicturePage(
                                                            userModel.image !=
                                                                    ""
                                                                ? userModel
                                                                    .image!
                                                                : Image.asset(
                                                                    "assets/Germanen-Zirkel.png",
                                                                    width: 152,
                                                                    height: 152,
                                                                  ));
                                                      }));
                                                    },
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      child: Hero(
                                                        tag: 'profile_pic',
                                                        child:
                                                            userModel.image !=
                                                                    ""
                                                                ? Image.network(
                                                                    userModel
                                                                        .image!,
                                                                    width: 152,
                                                                    height: 152,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )
                                                                : Image.asset(
                                                                    "assets/Germanen-Zirkel.png",
                                                                    width: 152,
                                                                    height: 152,
                                                                  ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              userModel.userId,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                //color: Color(0x80121212),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 16),
                              child: Table(
                                defaultColumnWidth: FlexColumnWidth(0.1),
                                children: [
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 8.0),
                                      child: Text(
                                        'Status:',
                                        style: _textStyleKey,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 8.0),
                                      child: Text(
                                        userModel.status,
                                        style: _textStyleValue,
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 8.0),
                                      child: Text(
                                        'Aktiv seit:',
                                        style: _textStyleKey,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 8.0),
                                      child: Text(
                                        userModel.activeSince,
                                        style: _textStyleValue,
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 8.0),
                                      child: Text(
                                        'Studienfach:',
                                        style: _textStyleKey,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 8.0),
                                      child: Text(
                                        userModel.mayor,
                                        style: _textStyleValue,
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 8.0),
                                      child: Text(
                                        'Beruf:',
                                        style: _textStyleKey,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 8.0),
                                      child: Text(
                                        userModel.job,
                                        style: _textStyleValue,
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 8.0),
                                      child: Text(
                                        'Wohnsitz:',
                                        style: _textStyleKey,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 8.0),
                                      child: Text(
                                        userModel.location,
                                        style: _textStyleValue,
                                      ),
                                    ),
                                  ]),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Text("no Data");
              }
            }));
  }
}
