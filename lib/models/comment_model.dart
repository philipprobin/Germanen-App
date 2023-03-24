import 'package:cloud_firestore/cloud_firestore.dart';

import '../network/Database.dart';

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
        comment: Database.decrypt(json['comment']),
        timestamp: Database.decrypt(json['timestamp']),
        userId: Database.decrypt(json['userId']));
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
