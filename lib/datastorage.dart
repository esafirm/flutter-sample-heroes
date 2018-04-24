import 'dart:convert';
import 'comments.dart';
import 'package:shared_preferences/shared_preferences.dart';

addComment(String id, Comment comment) async {
  final commentsMaps = await _getCommentRaw(id);
  commentsMaps.add(comment.toJson());
  _setCommentRaw(id, commentsMaps);
}

getComments(String id) async {
  final commentMaps = await _getCommentRaw(id);
  print("getComments: $commentMaps");
  if (commentMaps.isEmpty) {
    return new List<Comment>();
  }
  return commentMaps.map((map) => new Comment.fromMap(map)).toList();
}

_setCommentRaw(String storageId, List comments) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(storageId, json.encode(comments));
}

_getCommentRaw(String storageId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String rawJson = prefs.getString(storageId);
  return rawJson == null ? List() : json.decode(rawJson).toList();
}
