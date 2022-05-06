import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String postId;
  String comment;
  String timestamp;
  String userId;

  CommentModel({
    required this.postId,
    required this.comment,
    required this.timestamp,
    required this.userId,
  });

  static CommentModel fromJson(Map<String, dynamic> json) {
    final CommentModel model = new CommentModel(
        postId: json['postId'],
        comment: json['comment'],
        timestamp: json['timestamp'],
        userId: json['userId']);
    return model;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postId'] = this.postId;
    data['comment'] = this.comment;
    data['timestamp'] = this.timestamp;
    data['userId'] = this.userId;
    return data;
  }
}
