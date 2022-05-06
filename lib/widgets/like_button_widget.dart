import 'package:flutter/material.dart';
import 'package:germanenapp/screens/comment.dart';
import 'package:like_button/like_button.dart';

import '../network/Database.dart';

class LikeButtonWidget extends StatefulWidget {
  final String? userId;
  final String postId;
  final List<dynamic>? likes;

  const LikeButtonWidget(
      {Key? key, required this.userId, required this.postId, required this.likes})
      : super(key: key);

  @override
  State<LikeButtonWidget> createState() => _LikeButtonWidgetState();
}

class _LikeButtonWidgetState extends State<LikeButtonWidget> {
  bool isLiked = false;

  //getter

  @override
  Widget build(BuildContext context) {
    int likeCount = 0;
    String displayName = "";
    if (widget.likes != null) {
      late List<String>? likes = widget.likes!.map((e) => e as String).toList();
      likeCount = likes.length;
      if (likes.contains(widget.userId)) {
        isLiked = true;
      }
    }
    if (widget.userId != null) {
      displayName = widget.userId!;
    }

    final double size = 24;
    return LikeButton(
      size: size,
      isLiked: isLiked,
      likeCount: likeCount,
      likeBuilder: (isLiked) {
        final color = isLiked ? Colors.blue : Colors.grey;
        return Icon(
          Icons.thumb_up_rounded,
          color: color,
          size: size,
        );
      },
      likeCountPadding: EdgeInsets.only(left: 12),
      countBuilder: (count, isLiked, text) {
        var color = isLiked ? Colors.blueAccent : Colors.grey;
        return Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: size / 2,
            fontWeight: FontWeight.bold,
          ),
        );
      },
      onTap: (isLiked) async {
        this.isLiked = !isLiked;
        likeCount += this.isLiked ? 1 : -1;

        Database.setLike(
          postId: widget.postId,
          isLiked: isLiked,
          userId: displayName,
        );
        //database setter


        return !isLiked;
      },
    );
  }
}
