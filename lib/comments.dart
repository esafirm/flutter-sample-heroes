class Comment {
  final String name;
  final String comment;

  Comment({this.name, this.comment});
  Comment.fromMap(Map map) : this(name: map['name'], comment: map['comment']);

  toJson() => {"name": name, "comment": comment};
}
