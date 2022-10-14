import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:germanenapp/network/Database.dart';
import 'package:germanenapp/screens/content/content_item_list.dart';
import 'package:intl/intl.dart';
import '../../components/stream_comments_wrapper.dart';
import '../../models/comment_model.dart';
import '../../widgets/app_toolbar.dart';
import '../../widgets/like_button_widget.dart';
import 'gallery_photo_zoomable_view.dart';

class Comments extends StatefulWidget {
  final ContentField contentField;

  Comments({required this.contentField});

  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  //UserModel user;
  late List<String> itemList = widget.contentField.images.map((e) => e as String).toList();

  //PostService services = PostService();
  final DateTime timestamp = DateTime.now();
  TextEditingController commentsTEC = TextEditingController();

  currentUserId() {
    return FirebaseAuth.instance.currentUser?.displayName;
  }

  final DateFormat formatter = DateFormat('dd.MM.yyyy');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          title: AppToolbar(
            sectionName: 'Germanen-App',
          )
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Flexible(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: buildFullPost(),
                  ),
                  Divider(thickness: 1.5),
                  buildComments()
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,//Theme.of(context).primaryColor,
                ),
                constraints: BoxConstraints(
                  maxHeight: 190.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.all(8),
                      title: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: commentsTEC,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          hintText: "Schreibe einen Kommentar...",
                          hintStyle: TextStyle(
                            fontSize: 15.0,
                            color:
                            Colors.black12,
                          ),
                        ),
                        maxLines: null,
                      ),
                      trailing: GestureDetector(
                        onTap: () async {
                          await Database.uploadComment(
                            currentUserId(),
                            commentsTEC.text,
                            widget.contentField.docId,
                          );
                          commentsTEC.clear();


                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Icon(
                            Icons.send,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildFullPost() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 20.0,
            child: GalleryPhotoZoomableView(
              images: widget.contentField.images,
            ),//Text("cachedNetworkThing"),//cachedNetworkImage(widget.post.mediaUrl),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LikeButtonWidget(
                      userId: currentUserId(),
                      likes: widget.contentField.likes,
                      postId: widget.contentField.docId,
                    ),
                    Text(
                      widget.contentField.description,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Row(
                      children: [
                        Text(
                          formatter.format(DateTime.parse(widget.contentField.date)).toString(),
                          style: TextStyle(),
                        ),
                        SizedBox(width: 3.0),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                //buildLikeButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildComments()  {
    return CommentsStreamWrapper(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      stream: Database.readComments(widget.contentField.docId),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (_, DocumentSnapshot snapshot) {
        CommentModel comments = CommentModel.fromJson(snapshot.data() as Map<String, dynamic>);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0),

              title: Text(
                comments.userId,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                formatter.format(DateTime.parse(comments.timestamp)).toString(),
                style: TextStyle(fontSize: 12.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                comments.comment,
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
            ),
            Divider()
          ],
        );
      },
    );
  }
}