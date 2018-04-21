import 'dart:async';
import 'dart:convert';
import 'comments.dart';
import 'package:shared_preferences/shared_preferences.dart';

addComment(int heroHashCode, Comment comment) async {
  final storageId = heroHashCode.toString();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String rawJson = prefs.getString(storageId);
  List<Map> commentsMaps = rawJson == null ? new List() : json.decode(rawJson);
  Map<String, String> newCommentMap = new Map()
    ..["name"] = comment.name
    ..["comment"] = comment.comment;

  commentsMaps.add(newCommentMap);
  prefs.setString(storageId, json.encode(commentsMaps));
}

getComments(int heroHashCode) async {
  print("Get comments!");

  final storageId = heroHashCode.toString();
  final List<Map> commentMaps = await _getCommentRaw(storageId);
  if (commentMaps.isEmpty) {
    return new Future.value(new List<Comment>());
  }

  print(
      "-> ${commentMaps.map((map) => new Comment.fromMap(map)).toList().toString()}");

  return new Future.value(
      commentMaps.map((map) => new Comment.fromMap(map)).toList());
}

_getCommentRaw(String storageId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String rawJson = prefs.getString(storageId);
  return rawJson == null ? new List() : json.decode(rawJson);
}
