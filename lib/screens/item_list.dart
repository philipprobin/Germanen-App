import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:germanenapp/network/Database.dart';
import 'gallery_photo_zoomable_view.dart';

class ItemList extends StatelessWidget {
  const ItemList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint("Item List Class");

    return StreamBuilder<QuerySnapshot>(
        stream: Database.readItems(),
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
                  String title = data['title'];
                  String description = data['description'];
                  String userId = data['userId'];
                  String date = data['date'];
                  List images = data['images'];
                  return _ContentField(
                    userId: userId,
                    title: title,
                    description: description,
                    date: date,
                    images: images,
                  );
                },
                separatorBuilder: (context, index) => SizedBox(
                      height: 16.0,
                    ),
                itemCount: snapshot.data!.docs.length);
          }
          return Center(child: Text("Keine Daten"));
        });
  }
}

class _ContentField extends StatelessWidget {
  final String userId;
  final String title;
  final String description;
  final String date;
  final List<dynamic> images;

  _ContentField({
    required this.userId,
    required this.title,
    required this.description,
    required this.date,
    required this.images,
  });

  final Database database = Database();

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd.MM.yyyy');
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFDDDDDD),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  userId,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0x80121212),
                  ),
                ),
                database.getDisplayName() != userId
                    ? Container()
                    : PopupMenuButton(
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('löschen'),
                            )
                          ];
                        },
                        onSelected: (String value) =>
                            actionPopUpItemSelected(value, userId, date),
                      ),
              ]),
              Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),

                      //in construction
                      images.length == 0
                          ? Container()
                          : Container(
                              child: GalleryPhotoZoomableView(
                                images: images,
                              ),
                            ),
                      SizedBox(
                        height: 4,
                      ),
                      /*
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              padding: EdgeInsets.all(2),
                              color: Colors.grey[800],
                              child: Center(
                                child: Image.network(images[index]),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),

                       */
                    ]),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text(
                  formatter.format(DateTime.parse(date)).toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0x80121212),
                  ),
                ),
              ]),
            ],
          )),
    );
  }

  actionPopUpItemSelected(String value, String userId, String date) {
    if (value == 'delete' && userId == database.getDisplayName()) {
      database.deleteItem(date: date);
    }
  }
}

/*

Container(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              padding: EdgeInsets.all(2),
                              color: Colors.grey[800],
                              child: Center(
                                child: Image.network(images[index]),
                              ),
                            );
                          },
                        ),
                      ),


      return ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Map< String, dynamic > data = snapshot.data!.docs[index].data();
                  String title = data['title'];
                  String description = data['description'];
                  return _ContentField(
                    userId: "docID",
                    title: title,
                    subtitle: description,
                    date: "12.08.1997",
                  );
                },

                separatorBuilder: (context, index) =>
                    SizedBox(height: 16.0,),
                itemCount:  snapshot.data!.docs.length//snapshot.docs.length,snapshot.data.lenght
            );



Ink(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          onTap: () {},
                          leading: Text(
                            docID,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          title: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
 */
